//
//  ZCoder.Test.m
//  Search
//
//  Created by Edward Smith on 11/21/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


#import <XCTest/XCTest.h>
#import "ZCoder.h"


@interface CoderTestClass : NSObject <NSCoding>
	{
	@public
	
	NSString 	*ivar1;
	NSString 	*ivar2;	//	Ignored member
	NSString 	*ivar3;
	BOOL		bFalse;
	BOOL		bTrue;
	NSInteger	i;
	float		f;
	double		d;
	}
@property (strong) NSString* prop1;
@end


@implementation CoderTestClass

- (id) initWithCoder:(NSCoder*)decoder
	{
	self = [super init];
	if (!self) return  self;
	[ZCoder decodeObject:self withCoder:decoder ignoringMembers:@[@"ivar2"]];
	return self;
	}

- (void) encodeWithCoder:(NSCoder*)coder
	{
	[ZCoder encodeObject:self withCoder:coder ignoringMembers:@[@"ivar2"]];
	}

@end



@interface ZCodingTest : XCTestCase
@end


@implementation ZCodingTest

- (void)setUp
	{
    [super setUp];
	}

- (void)tearDown
	{
	[super tearDown];
	}

- (void)testZCoding
	{
	CoderTestClass *testClass = [CoderTestClass new];
	testClass->ivar1 = @"First";
	testClass->ivar2 = @"Second";
	testClass->ivar3 = @"Third";
	testClass.prop1  = @"Fourth";
	testClass->bTrue  = YES;
	testClass->i = 3;
	testClass->f = 4.5;
	testClass->d = 1000.0005;
	
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	ZCoder *coder = [ZCoder encoderWithDictionary:d];
	[testClass encodeWithCoder:coder];
	
	CoderTestClass *decodedClass = [[CoderTestClass alloc] initWithCoder:coder];
	
	XCTAssertTrue([testClass->ivar1 isEqual:decodedClass->ivar1], @"Resurrected class is not equal.");
	XCTAssertFalse([testClass->ivar2 isEqual:decodedClass->ivar2], @"Resurrected class is equal.");
	XCTAssertTrue([testClass->ivar3 isEqual:decodedClass->ivar3], @"Resurrected class is not equal.");
	XCTAssertTrue([testClass.prop1 isEqual:decodedClass.prop1], @"Resurrected class is not equal.");
	XCTAssertTrue(testClass->bFalse == decodedClass->bFalse, @"Resurrected class is not equal.");
	XCTAssertTrue(testClass->bTrue == decodedClass->bTrue, @"Resurrected class is not equal.");
	XCTAssertTrue(testClass->i == decodedClass->i, @"Resurrected class is not equal.");
	XCTAssertTrue(testClass->f == decodedClass->f, @"Resurrected class is not equal.");
	XCTAssertTrue(testClass->d == decodedClass->d, @"Resurrected class is not equal.");
	}

@end
