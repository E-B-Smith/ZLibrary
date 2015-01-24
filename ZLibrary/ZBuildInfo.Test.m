


//-----------------------------------------------------------------------------------------------
//
//																				ZBuildInfo.Test.m
//																	 ZLibrary for Mac and iPhone.
//
//															  Tracks build time and version info.
//																		 Edward Smith, March 2007
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <XCTest/XCTest.h>
#import "ZBuildInfo.h"


@interface ZBuildInfoTest : XCTestCase
@end


@implementation ZBuildInfoTest

- (void)setUp
	{
    [super setUp];
	}

- (void)tearDown
	{
	[super tearDown];
	}

- (void)testVersionCompare
	{
	XCTAssertTrue(NSOrderedSame == [ZBuildInfo compareVersionString:@"1.2.1" withVersionString:@"1.2.1"]);
	XCTAssertTrue(NSOrderedAscending == [ZBuildInfo compareVersionString:@"1.2.1" withVersionString:@"1.2.2"]);
	XCTAssertTrue(NSOrderedDescending == [ZBuildInfo compareVersionString:@"1.2.2" withVersionString:@"1.2.1"]);
	XCTAssertTrue(NSOrderedSame == [ZBuildInfo compareVersionString:@"1.2.1.3" withVersionString:@"1.2.1.3"]);
	XCTAssertTrue(NSOrderedAscending == [ZBuildInfo compareVersionString:@"1.2.1" withVersionString:@"1.2.1.3"]);

	XCTAssertTrue(NSOrderedSame == [ZBuildInfo compareVersionString:@"1.020.1" withVersionString:@"1.20.1"]);
	XCTAssertTrue(NSOrderedAscending == [ZBuildInfo compareVersionString:@"1.02.1" withVersionString:@"1.020.2"]);
	XCTAssertTrue(NSOrderedDescending == [ZBuildInfo compareVersionString:@"3.2.2" withVersionString:@"2.3.2"]);
	
	XCTAssertTrue(NSOrderedSame == [ZBuildInfo compareVersionString:@"1.2.00.00" withVersionString:@"1.2"]);
	XCTAssertTrue(NSOrderedAscending == [ZBuildInfo compareVersionString:@"1.2" withVersionString:@"1.2.0.1"]);
	XCTAssertTrue(NSOrderedDescending == [ZBuildInfo compareVersionString:@"1.2.0.1" withVersionString:@"1.2"]);
	}

@end
