


//-----------------------------------------------------------------------------------------------
//
//																		 NSString+ZLibrary.Test.m
//																					 	 ZLibrary
//
//								   				  NSString for transforming & formatting strings.
//																	  Edward Smith, November 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <XCTest/XCTest.h>
#import "NSString+ZLibrary.h"


@interface NSStringZLibrary : XCTestCase
@end


@implementation NSStringZLibrary

- (void)setUp
	{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
	}

- (void)tearDown
	{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
	}

- (void) testStringByEncodingJSONCharacters
	{
	NSString* rawString  = @"Abcdef\t&\r\b\nMoreString\"\'\f\\RestOfString";
	NSString* goodString = @"Abcdef\\t\\&\\r\\b\\nMoreString\\\"\\'\\f\\\\RestOfString";
	rawString = [rawString stringByEncodingJSONCharacters];
	XCTAssertTrue([goodString isEqualToString:rawString],
		@"%s should return:\n%@but returned:\n%@.", __PRETTY_FUNCTION__, goodString, rawString);
	}

- (void) testStringByEncodingXMLCharacters
	{
	NSString* inputString1 = @"Some characters <then stanza> \"Quoted String\" doesn't break. & One more test.";
	NSString* outputString1= @"Some characters &lt;then stanza&rt; &quote;Quoted String&quote; doesn&apos;t break. &amp; One more test.";
	NSString* testString = [inputString1 stringByEncodingXMLCharacters];
	
	XCTAssertTrue([outputString1 isEqual:testString],
		@"Failure n %s.\nInput: %@\nOutput: %@\nWanted: %@", __PRETTY_FUNCTION__, inputString1, testString, outputString1);

	
	NSString* inputString2 = @"&<>Bunch of characters up front & some \"\"''' in the middle. And confusion: &amp;\"";
	NSString* outputString2= @"&amp;&lt;&rt;Bunch of characters up front &amp; some &quote;&quote;&apos;&apos;&apos; in the middle. And confusion: &amp;amp;&quote;";
	testString = [inputString2 stringByEncodingXMLCharacters];

	XCTAssertTrue([outputString2 isEqual:testString],
		@"Failure n %s.\nInput: %@\nOutput: %@\nWanted: %@", __PRETTY_FUNCTION__, inputString2, testString, outputString2);
	}

- (void) testIsLike
	{
	NSString *queryString = @"Add";
	NSArray *successCases =
		@[@"Add"
		 ,@"adderall"
		 ,@"Charles Addams"
		 ,@"addams"
		 ,@"A long time to add to it."
		 ,@"this add"
		 ,@"add add add"
		 ,@"What would a Swede ådd?"
		 ,@"Maddmen"
		 ];
	NSArray *failureCases =
		@[@"aderall"
		 ,@"this has a mis-spelled ad-ding."
		 ,@"Madmen"
		 ,@"Nothing in this stri9ng at all."
		 ];
		 
	for (NSString* test in successCases)
		{
		XCTAssertTrue([test isLike:queryString], @"Testing %@ isLike %@.", test, queryString);
		}
		
	for (NSString* test in failureCases)
		{
		XCTAssertFalse([test isLike:queryString], @"Testing %@ not isLike %@.", test, queryString);
		}
	}

- (void) testUnescapeString
	{
	NSArray *trueTest =
		@[
		@"ABCDEF",				@"ABCDEF",
		@"ABC\\nDEF",			@"ABC\nDEF",
		@"ABC\\nDEF\\t",		@"ABC\nDEF\t",
		@"\\\\ABC\\nDEF\\t",	@"\\ABC\nDEF\t",
		@"abc\\zdef",			@"abc\\zdef",
		@"ABCDEF\\",			@"ABCDEF\\",
		];
	
	for (int i = 0; i < trueTest.count; i += 2)
		{
		NSString *result = [trueTest[i] stringByDecodingStringEscapes];
		XCTAssertTrue([result isEqualToString:trueTest[i+1]], @"Testing %@ is equal to %@.", result, trueTest[i+1]);
		}
	}

@end
