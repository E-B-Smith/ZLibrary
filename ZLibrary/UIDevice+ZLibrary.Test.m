//
//  UIDeviceZLibrary.m
//  ZLibrary
//
//  Created by Edward Smith on 1/29/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import <XCTest/XCTest.h>
#import "UIDevice+ZLibrary.h"
#import "ZDebug.h"


@interface UIDeviceZLibrary : XCTestCase
@end


@implementation UIDeviceZLibrary

- (void)setUp
	{
    [super setUp];
	}

- (void)tearDown
	{
    [super tearDown];
	}

- (void)testUIDevice
	{
	/*
	2014-01-29 19:06:42.113 SearchStaging[17179:70b] UIDevice+ZLibrary.Test.m(40):    Model: iPhone Simulator.
	2014-01-29 19:06:44.296 SearchStaging[17179:70b] UIDevice+ZLibrary.Test.m(43):   LModel: iPhone Simulator.
	2014-01-29 19:06:45.939 SearchStaging[17179:70b] UIDevice+ZLibrary.Test.m(46): Platform: x86_64. (i386 for 32bit)
	2014-01-29 19:06:47.987 SearchStaging[17179:70b] UIDevice+ZLibrary.Test.m(49):  hwmodel: iMac14,2.

	2014-01-29 19:10:07.078 SearchStaging[5103:60b] UIDevice+ZLibrary.Test.m(47):    Model: iPhone.
	2014-01-29 19:10:08.752 SearchStaging[5103:60b] UIDevice+ZLibrary.Test.m(50):   LModel: iPhone.
	2014-01-29 19:10:12.188 SearchStaging[5103:60b] UIDevice+ZLibrary.Test.m(53): Platform: iPhone6,1.
	2014-01-29 19:10:16.698 SearchStaging[5103:60b] UIDevice+ZLibrary.Test.m(56):  hwmodel: N51AP.

	2014-01-30 04:06:32.267 SearchStaging[17403:70b] UIDevice+ZLibrary.Test.m(54):    Model: iPhone Simulator.
	2014-01-30 04:06:32.267 SearchStaging[17403:70b] UIDevice+ZLibrary.Test.m(57):   LModel: iPhone Simulator.
	2014-01-30 04:06:32.268 SearchStaging[17403:70b] UIDevice+ZLibrary.Test.m(60): Platform: x86_64.
	2014-01-30 04:06:32.268 SearchStaging[17403:70b] UIDevice+ZLibrary.Test.m(63):  hwmodel: MacBookPro10,1.

	2014-01-30 06:21:54.814 SearchStaging[3952:907] RUIApplicationDelegate.m(174):    Model: iPhone.
	2014-01-30 06:21:54.816 SearchStaging[3952:907] RUIApplicationDelegate.m(177):   LModel: iPhone.
	2014-01-30 06:21:54.818 SearchStaging[3952:907] RUIApplicationDelegate.m(180): Platform: iPhone4,1.
	2014-01-30 06:21:54.820 SearchStaging[3952:907] RUIApplicationDelegate.m(183):  hwmodel: N94AP.
	*/

	NSArray* iphoneSimulatorResultSet =
		@[
		@"iPhoneSimulator",		//	Model
		@"iPhone Simulator",	//	Local Model
		@"*",					//	Hardware Model
		@1,						//	Family
		@-1,					//	CPU Count
		@18446744071562067968U,	//	Total Mem.
		@-1,					//	User Mem.
		@-1,					//	File bytes
		@-1,					//	Avail file bytes.
		@1,						//	Is Simulator
		@"68:5B:35:8B:BC:4E",	//	MAC Address
		@1,						//	Has Retina
		@1						//	Bluetooth enabled.
		];

	NSArray* ipadSimulatorResultSet =
		@[
		@"iPadSimulator",		//	Model
		@"iPad Simulator",		//	Local Model
		@"*",					//	Hardware Model
		@3,						//	Family
		@-1,					//	CPU Count
		@18446744071562067968U,	//	Total Mem.
		@-1,					//	User Mem.
		@-1,					//	File bytes
		@-1,					//	Avail file bytes.
		@1,						//	Is Simulator
		@"68:5B:35:8B:BC:4E",	//	MAC Address
		@1,						//	Has Retina
		@1						//	Bluetooth enabled.
		];

	NSArray* phone61ResultSet =
		@[
		@"iPhone6,1",			//	Model
		@"iPhone 5s GSM",		//	Local Model
		@"N51AP",				//	Hardware Model
		@1,						//	Family
		@2,						//	CPU Count
		@1048203264,			//	Total Mem.
		@-1,					//	User Mem.
		@-1,					//	File bytes
		@-1,					//	Avail file bytes.
		@0,						//	Is Simulator
		@"02:00:00:00:00:00",	//	MAC Address
		@1,						//	Has Retina
		@0						//	Bluetooth enabled.
		];

	int index = 0;
	id testValue = nil;
	id resultValue = nil;
	UIDevice* device = [UIDevice currentDevice];


	NSArray* resultSet = nil;
	if ([device.modelIdentifier isEqualToString:@"iPhone6,1"])
		resultSet = phone61ResultSet;
	else
	if (device.isSimulator)
		{
		if (device.deviceFamily == UIDeviceFamilyiPad)
			resultSet = ipadSimulatorResultSet;
		else
			resultSet = iphoneSimulatorResultSet;
		}
	
	XCTAssertTrue(resultSet != nil, @"No result set for current device.");
	
	#define TestStringValue(x) \
		{ \
		resultValue = resultSet[index++]; \
		testValue = device.x; \
		NSLog(@"Testing " #x ": %@.", testValue); \
		XCTAssertTrue([testValue isEqual:resultValue], @"Test failed. For " #x " expected %@ but got %@.", resultValue, testValue); \
		}
	
	#define TestNumberValue(x) \
		{ \
		resultValue = resultSet[index++]; \
		testValue = [NSNumber numberWithUnsignedLongLong:device.x]; \
		NSLog(@"Testing " #x ": %@.", testValue); \
		if ([resultValue longValue] >= 0) \
			{ XCTAssertTrue([testValue isEqual:resultValue], @"Test failed. For " #x " expected %@ but got %@.", resultValue, testValue);  } \
		else \
			{ XCTAssertTrue([testValue unsignedLongLongValue] > 0, @"Test failed. For " #x " expected positive number but got %@.", testValue);  } \
		}

	TestStringValue(modelIdentifier);
	TestStringValue(localizedModelIdentifier);
	TestStringValue(hardwareModelIdentifier);
	TestNumberValue(deviceFamily);
	TestNumberValue(cpuCount);
	TestNumberValue(totalMemoryBytes);
	TestNumberValue(userMemoryBytes);
	TestNumberValue(totalFileSystemBytes);
	TestNumberValue(availableFileSystemBytes);
	TestNumberValue(isSimulator);
//	TestStringValue(MACAddress);
	index++;
	TestNumberValue(hasRetinaDisplay);
	APP_STORE_NON_COMPLIANT( TestNumberValue(bluetoothIsEnabled) );
	}

@end
