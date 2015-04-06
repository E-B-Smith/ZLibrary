//
//  UIColor_ZLibrary.m
//  ZLibrary
//
//  Created by Edward Smith on 2/18/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import <XCTest/XCTest.h>
#import "UIColor+ZLibrary.h"
#import <math.h>


@interface UIColorZLibrary : XCTestCase
@end


@implementation UIColorZLibrary

- (void)setUp
	{
    [super setUp];
	}

- (void)tearDown
	{
    [super tearDown];
	}

- (void) testDistanceFromColor
	{
	NSArray *testCases =
		@[
		[UIColor blackColor],			[UIColor whiteColor],		@1.0,
		[UIColor blackColor],			[UIColor blackColor],		@0.0,
		[UIColor redColor],				[UIColor whiteColor],		@0.6666,
		[UIColor yellowColor],			[UIColor whiteColor],		@0.3333,
		[UIColor yellowColor],			[UIColor blackColor],		@0.6666
		];
		
	for (int i = 0; i < testCases.count; i+=3)
		{
		CGFloat d = [(UIColor*)testCases[i] distanceFromColor:testCases[i+1]];
		XCTAssertTrue(fabs(d - [testCases[i+2] floatValue]) < 0.0001, @"Case %d failed.", i);
		}
	}

- (void) testLuminosity
	{
	NSArray *testCases =
		@[
		[UIColor blackColor],		@0.0,
		[UIColor whiteColor],		@1.0,
		[UIColor redColor],			@0.33333,
		[UIColor yellowColor],		@0.66666,
		];
	for (int i = 0; i < testCases.count; i+=2)
		{
		CGFloat l = [(UIColor*)testCases[i] luminosity];
		XCTAssertTrue(fabs(l - [testCases[i+1] floatValue]) < 0.0001, @"Case %d failed.", i);
		}
	}

- (void) testColorByBlendingWhite
	{
	NSArray *testCases =
		@[
		[UIColor blackColor],		@0.333,				[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0],
		[UIColor whiteColor],		@0.666,				[UIColor whiteColor],
		[UIColor redColor],			@0.33333,			[UIColor colorWithRed:1.0 green:0.3333 blue:0.3333 alpha:1.0],
		[UIColor yellowColor],		@0.66666,			[UIColor colorWithRed:1.0 green:1.0 blue:0.6666 alpha:1.0]
		];

	for (int i = 0; i < testCases.count; i+=3)
		{
		UIColor *b = [(UIColor*)testCases[i] colorByBlendingWhite:[testCases[i+1] floatValue]];
		CGFloat d = [b distanceFromColor:testCases[i+2]];
		XCTAssertTrue(fabs(d) < 0.0001, @"Case %d failed.", i);
		}
	}

@end
