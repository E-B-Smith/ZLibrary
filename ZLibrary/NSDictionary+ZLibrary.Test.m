


//-----------------------------------------------------------------------------------------------
//
//																     NSDictionary+ZLibrary.Test.m
//																					     ZLibrary
//
//								   										 NSDictionary extensions.
//																	  Edward Smith, November 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <XCTest/XCTest.h>
#import "NSDictionary+ZLibrary.h"


@interface NSDictionaryZLibrary : XCTestCase
@end



@implementation NSDictionaryZLibrary

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

- (void) testExtractItemOfClass
	{
	NSDictionary *testDictionary =
		@{
		@"float": @0.1,
		@"array": @[@"string0", @"string1"],
		@"dictionary":
			@{
			@"item0":	@"itemString0",
			@"item1":	@"itemString1",
			},
		@"key":	@"value",
		@"array2":
			@[
			@{},
			@{
			@"Key0":	@0,
			@"Key1":	@1
			}]
		};

	NSString *result = nil;
	
	#define test(key, value) \
		result = [testDictionary objectOfClass:[NSString class] forPath:key]; \
		XCTAssertTrue(result && value && [result isEqual:value], @"%s objectOfClass:forPath %@ should return %@ but returned %@." \
			, __PRETTY_FUNCTION__, key, value, result)
	
	test(@"dictionary.item0", @"itemString0");
	test(@"array[1]", @"string1");
	test(@"key", @"value");
	
	NSNumber *n = [testDictionary objectOfClass:[NSNumber class] forPath:@"array2[1].Key1"];
	XCTAssertTrue([n isEqual:@1], @"%s objectOfClass:forPath %@ should return %@ but returned %@." \
		, __PRETTY_FUNCTION__, @"array2[1].Key1", @1, n);
	
	NSNumber *m = [testDictionary objectOfClass:[NSNumber class] forPath:@"arrayNone[1].Key1"];
	XCTAssertFalse([m isEqual:@1], @"%s objectOfClass:forPath %@ should return %@ but returned %@." \
		, __PRETTY_FUNCTION__, @"array2[1].Key1", @1, m);
	}

@end
