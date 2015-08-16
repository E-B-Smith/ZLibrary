


//-----------------------------------------------------------------------------------------------
//
//																				   ZDebug.Test.mm
//																					 ZLibrary-Mac
//
//														  Simple debug message & assert functions
//																		 Edward Smith, March 2007 
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <XCTest/XCTest.h>
#import "ZDebug.h"


static NSString* globalTestDebugMessage = nil;


void TestDebugProcedure(ZDebugLevel debugLevel, NSString* DebugString)
	{
	globalTestDebugMessage = [DebugString copy];
	}


@interface ZDebugTest : XCTestCase
@end


@implementation ZDebugTest

- (void) dealloc
	{
	globalTestDebugMessage = nil;
	}

//
//
//	Extra lines to make debug messages compare correctly.
//

- (void) testDebug
	{
	#if defined(ZDEBUG)
	NSString* TestPtr = nil;
	ZDebugMessageHandlerProcedurePtr OldProcedure = ZDebugSetMessageHandler(TestDebugProcedure);
	
	//	Test the debug message facility -- 
	//	Warning!  These line number can't change or the tests will fail!

//	ZDebugSetEnabled(true);
	ZDebug(@"Debug message with no parameters.");
	TestPtr = @"ZDebug.Test.m(56): Debug message with no parameters.";
	XCTAssertEqualObjects(TestPtr, globalTestDebugMessage, @"ZDebug failed to produce the correct debug message.");

	ZDebug(@"Debug message with one parameter: %d.", 1);
	TestPtr = @"ZDebug.Test.m(60): Debug message with one parameter: 1.";
	XCTAssertEqualObjects(TestPtr, globalTestDebugMessage, @"ZDebug failed to produce the correct debug message.");

	//	Test the assert facility -- 

	ZDebugSetBreakOnAssertEnabled(NO);

	globalTestDebugMessage = nil;
	ZDebugAssert(2 + 2 == 4);
	XCTAssertTrue(globalTestDebugMessage == nil, @"ZDebugAssert triggered when it shouldn't. Checked that 2 + 2 == 4.");

	ZDebugAssert(2 + 2 == 5);
	TestPtr = @"ZDebug.Test.m(72): \n\nAssertion Failed! Assert that '2 + 2 == 5'.";
	XCTAssertEqualObjects(TestPtr, globalTestDebugMessage, @"ZDebugAssert failed to produce the correct debug message.");

	ZLog(@"Testing ZLog procedure. This will display in the console log.");
	TestPtr = @"ZDebug.Test.m(76): Testing ZLog procedure. This will display in the console log.";
	XCTAssertEqualObjects(TestPtr, globalTestDebugMessage, @"ZDebugAssert failed to produce the correct debug message.");

	ZDebugSetBreakOnAssertEnabled(YES);
	ZDebugSetMessageHandler(OldProcedure);
	#endif
	}

@end
