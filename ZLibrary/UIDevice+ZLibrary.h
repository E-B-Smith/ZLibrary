


//-----------------------------------------------------------------------------------------------
//
//																			  UIDevice+ZLibrary.h
//																					 ZLibrary-iOS
//
//								   											 UIDevice extensions.
//																	  Edward Smith, December 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------
//	  Based in part on code by Erica Sadun, http://ericasadun.com, iPhone Developer's Cookbook
//-----------------------------------------------------------------------------------------------


#if !defined(UIDeviceIDMacro)

#import <UIKit/UIKit.h>
#import "ZLibrary.h"


#pragma mark UIDevice+ZLibrary


typedef NS_ENUM(int32_t, UIDeviceFamily)
	{
	UIDeviceFamilyUnknown = 0,
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV
    };


@interface UIDevice (ZLibrary)

- (NSString*) modelIdentifier;			//	The firmware string, like 'iPhone6,1'.
- (NSString*) localizedModelIdentifier;	//	The 'pretty' hardware string: 'iPhone 5S GSM'.
- (NSString*) hardwareModelIdentifier;	//	The raw hardware string, like 'N51AP'. Not so useful.
- (NSString*) serialNumber;
- (NSString*) systemBuildVersion;

- (UIDeviceFamily)  deviceFamily;

- (NSInteger) cpuCount;
- (NSInteger) totalMemoryBytes;
- (NSInteger) userMemoryBytes;

- (int64_t) totalFileSystemBytes;
- (int64_t) availableFileSystemBytes;

- (BOOL) isSimulator;
- (BOOL) isiPad;
- (NSString*) MACAddress;
- (NSString*) localIPAddressIPv4;
- (NSString*) localIPAddressIPv6;
- (BOOL) hasRetinaDisplay;

APP_STORE_NON_COMPLIANT( - (BOOL) bluetoothIsEnabled; )
APP_STORE_NON_COMPLIANT( - (NSString*) usbSerialString; )

@end


#else	// UIDeviceIDMacro defined:


//UIDeviceIDMacro( identifier, description, internalID )

UIDeviceIDMacro( "AppleTV2,1",	"Apple TV 2G",			"K66AP" )
UIDeviceIDMacro( "AppleTV3,1",	"Apple TV 3G",			"J33AP" )
UIDeviceIDMacro( "AppleTV3,2",	"Apple TV 3G",			"J33IAP")
UIDeviceIDMacro( "AppleTV5,3",	"Apple TV 4G",			"")

UIDeviceIDMacro( "iPad1,1",		"iPad 1G",				"K48AP" )
UIDeviceIDMacro( "iPad2,1",		"iPad 2 Wi-Fi",			"K93AP" )
UIDeviceIDMacro( "iPad2,2",		"iPad 2 GSM",			"K94AP" )
UIDeviceIDMacro( "iPad2,3",		"iPad 2 CDMA",			"K95AP" )
UIDeviceIDMacro( "iPad2,4",		"iPad 2 Wi-Fi A",		"K93AAP")
UIDeviceIDMacro( "iPad3,1",		"iPad 3 Wi-Fi",			"J1AP"  )
UIDeviceIDMacro( "iPad3,2",		"iPad 3 GSM+CDMA",		"J2AP"  )
UIDeviceIDMacro( "iPad3,3",		"iPad 3 GSM",			"J2AAP" )
UIDeviceIDMacro( "iPad3,4",		"iPad 4 Wi-Fi",			"P101AP")
UIDeviceIDMacro( "iPad3,5",		"iPad 4 GSM",			"P102AP")
UIDeviceIDMacro( "iPad3,6",		"iPad 4 GSM+CDMA",		"P103AP")
UIDeviceIDMacro( "iPad4,1",		"iPad Air Wi-Fi",		"J71AP" )
UIDeviceIDMacro( "iPad4,2",		"iPad Air Cell",		"J72AP" )
UIDeviceIDMacro( "iPad2,5",		"iPad Mini 1G Wi-Fi",	"P105AP")
UIDeviceIDMacro( "iPad2,6",		"iPad Mini 1G GSM",		"P106AP")
UIDeviceIDMacro( "iPad2,7",		"iPad Mini 1G CDMA",	"P107AP")
UIDeviceIDMacro( "iPad4,4",		"iPad Mini 2G Wi-Fi",	"J85AP" )
UIDeviceIDMacro( "iPad4,5",		"iPad Mini 2G Cell",	"J86AP" )

UIDeviceIDMacro( "iPhone1,1",	"iPhone 2G",			"M68AP" )
UIDeviceIDMacro( "iPhone1,2",	"iPhone 3G",			"N82AP" )

UIDeviceIDMacro( "iPhone2,1",	"iPhone 3GS",			"N88AP" )

UIDeviceIDMacro( "iPhone3,1",	"iPhone 4",				"N90AP" )
UIDeviceIDMacro( "iPhone3,2",	"iPhone 4 A",			"N90BAP")
UIDeviceIDMacro( "iPhone3,3",	"iPhone 4 CDMA",		"N92AP" )

UIDeviceIDMacro( "iPhone4,1",	"iPhone 4S",			"N94AP" )

UIDeviceIDMacro( "iPhone5,1",	"iPhone 5 GSM",			"N41AP" )
UIDeviceIDMacro( "iPhone5,2",	"iPhone 5 GSM+CDMA",	"N42AP" )
UIDeviceIDMacro( "iPhone5,3",	"iPhone 5c GSM",		"N48AP" )
UIDeviceIDMacro( "iPhone5,4",	"iPhone 5c Global",		"N49AP" )

UIDeviceIDMacro( "iPhone6,1",	"iPhone 5s GSM",		"N51AP" )
UIDeviceIDMacro( "iPhone6,2",	"iPhone 5s Global",		"N53AP" )

UIDeviceIDMacro( "iPhone7,1",	"iPhone 6+ Global",		"N56AP" )
UIDeviceIDMacro( "iPhone7,2",	"iPhone 6 Global",		"N61AP" )

UIDeviceIDMacro( "iPhone8,1", 	"iPhone 6s", 			"N71AP" )	//	 N71AP, N71mAP
UIDeviceIDMacro( "iPhone8,2",	"iPhone 6s Plus",		"N66AP" )	//	 N66AP, N66mAP

UIDeviceIDMacro( "iPod1,1",		"iPod touch 1G",		"N45AP" )
UIDeviceIDMacro( "iPod2,1",		"iPod touch 2G",		"N72AP" )
UIDeviceIDMacro( "iPod3,1",		"iPod touch 3G",		"N18AP" )
UIDeviceIDMacro( "iPod4,1",		"iPod touch 4G",		"N81AP" )
UIDeviceIDMacro( "iPod5,1",		"iPod touch 5G",		"N78AP" )

UIDeviceIDMacro( "iFPGA",			"iOS FPGA Prototype",	"*" )
UIDeviceIDMacro( "iPhoneSimulator",	"iPhone Simulator",		"*" )
UIDeviceIDMacro( "iPadSimulator",	"iPad Simulator",		"*" )

#endif	//	UIDeviceIDMacro defined
