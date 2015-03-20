


//-----------------------------------------------------------------------------------------------
//
//                                                                      NSScanner+ZLibrary.Test.m
//                                                                                   ZLibrary-Mac
//
//                                                               	     NSScanner Addition Tests
//                                                                       Edward Smith, March 2011
//
//                               -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <XCTest/XCTest.h>
#import "NSScanner+ZLibrary.h"


@interface NSScannerZLibrary : XCTestCase
@end


@implementation NSScannerZLibrary

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

- (void) testCharacter
	{
	NSString *testString = @"0123456789!abcdef";
	NSScanner *scanner = [NSScanner scannerWithString:testString];
	
	[scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
	XCTAssertTrue(scanner.currentCharacter == '!',
		@"%s scanner.character should be equal to '!'.", __PRETTY_FUNCTION__);
	
	[scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
	XCTAssertThrowsSpecificNamed(scanner.currentCharacter, NSException, NSRangeException, @"Expected a range exception here.");
	}
	
- (void) testScanUpToOccurance
	{
	NSString* testString1 = @"http://google.com/query/path/string?and&the&query";
	NSScanner* scanner1 = [NSScanner scannerWithString:testString1];
	
	NSString *result = nil;
	[scanner1 scanUpToOccurance:3 ofString:@"/" intoString:NULL];
	[scanner1 scanUpToOccurance:1 ofString:@"?" intoString:&result];
	XCTAssertTrue([result isEqualToString:@"/query/path/string"], @"%s failed scanning a query path: %@.", __PRETTY_FUNCTION__, result);
	
	NSString *testString2 = @"blah blah blah <<Exciting>> <<Very Exciting!>>";
	NSScanner *scanner2 = [NSScanner scannerWithString:testString2];
	[scanner2 scanUpToOccurance:2 ofString:@"<<" intoString:nil];
	[scanner2 scanString:@"<<" intoString:nil];
	[scanner2 scanUpToOccurance:1 ofString:@">>" intoString:&result];
	XCTAssertTrue([result isEqualToString:@"Very Exciting!"], @"%s failed scanning 'Very Exciting!'. Result: %@.", __PRETTY_FUNCTION__, result);
	}

@end
