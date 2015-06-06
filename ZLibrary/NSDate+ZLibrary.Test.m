


//-----------------------------------------------------------------------------------------------
//
//                                                                         NSDate+ZLibrary.Test.m
//                                                                                   ZLibrary-Mac
//
//                                                               	        NSDate Addition Tests
//                                                                         Edward Smith, May 2015
//
//                               -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <XCTest/XCTest.h>
#import "NSDate+ZLibrary.h"
#import "ZDebug.h"


@interface NSDateZLibraryTest : XCTestCase
@end


@implementation NSDateZLibraryTest

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

- (void) testRFC8222
	{
	NSString *s1 = @"Mon, 2 Jan 2006 14:04:05 -0800";
	NSDate   *d1 = [NSDate dateFromRFC8222String:s1];

	NSString *s2 = [d1 RFC8222String];
	XCTAssertTrue([s1 isEqualToString:s2], @"%@ should be = %@.", s1, s2);

	NSDate *d2 = [NSDate date];
	s2 = [d2 RFC8222String];
	d1 = [NSDate dateFromRFC8222String:s2];

	XCTAssertEqualWithAccuracy(
		[d1 timeIntervalSince1970],
		[d2 timeIntervalSince1970],
		1.0,
		@"Dates not equal.");
	}

- (void) testRelativeDate
	{
	ZLog([[[NSDate date] dateByAddingTimeInterval:-30.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-90.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*2.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*18.0] stringRelativeToNow]);

	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*90.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*5.0] stringRelativeToNow]);

	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*23.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*24.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*25.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*47.0] stringRelativeToNow]);
	
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*48.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*49.0] stringRelativeToNow]);

	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*48.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*72.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*24.0*7.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*24.0*14.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*24.0*365.0] stringRelativeToNow]);
	ZLog([[[NSDate date] dateByAddingTimeInterval:-60.0*60.0*24.0*365.0*2.0] stringRelativeToNow]);
	}
	
@end
