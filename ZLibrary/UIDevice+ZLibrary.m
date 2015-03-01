//
//  UIDevice+ZLibrary.m
//  Search
//
//  Created by Edward Smith on 1/29/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//
//	Based largely on code by Erica Sadun, http://ericasadun.com
//	iPhone Developer's Cookbook, 6.x Edition
//
// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.


#include "UIDevice+ZLibrary.h"
#import "ZDebug.h"

#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>


@implementation UIDevice (ZLibrary)


#pragma mark sysctlbyname Utilities


- (NSString *) getSysInfoByName:(char *)typeSpecifier
	{
    size_t size;
	if (sysctlbyname(typeSpecifier, NULL, &size, NULL, 0) < 0)
		{
		ZDebug(@"sysctlbyname error %d.", errno);
		return nil;
		}

    char *answer = malloc(size);
    if (sysctlbyname(typeSpecifier, answer, &size, NULL, 0) < 0)
		{
		ZDebug(@"sysctlbyname error %d.", errno);
		free(answer);
		return nil;
		}
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
	}

- (NSString *) modelIdentifier
	{
	NSString* result = [self getSysInfoByName:"hw.machine"];
	if ([result isEqualToString:@"x86_64"] ||
		[result isEqualToString:@"i386"])
		result = [self.model stringByReplacingOccurrencesOfString:@" " withString:@""];
	return result;
	}

- (NSString*) localizedModelIdentifier
	{
	NSDictionary *descriptionDictionary =
		@{
		
		#define UIDeviceIDMacro(ID, description, rawID )	@ID:	@description,
		#include "UIDevice+ZLibrary.h"
		#undef UIDeviceIDMacro
		
		};
	
	NSString* result = descriptionDictionary[self.modelIdentifier];
	if (!result)
		{
		ZDebugBreakPointMessage(@"No description for %@.", self.modelIdentifier);
		result = @"iOS Device";
		}
		
	return result;
	}

- (UIDeviceFamily) deviceFamily
	{
    NSString *platform = [self modelIdentifier];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) 	return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) 	return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"])return UIDeviceFamilyAppleTV;
    return UIDeviceFamilyUnknown;
	}

- (NSString *) hardwareModelIdentifier
	{
    return (self.isSimulator) ? @"*" : [self getSysInfoByName:"hw.model"];
	}

- (BOOL) isSimulator
	{
	NSRange r = [self.model
		rangeOfString:@"Simulator"
		options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
	return (r.location == NSNotFound) ? NO : YES;
	}


#pragma mark - sysctl Utilities


- (NSUInteger) getSysInfo: (uint) typeSpecifier
	{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
	if (sysctl(mib, 2, &results, &size, NULL, 0) < 0)
		{
		ZDebug(@"sysctl error %d.", errno);
		results = 0;
		}
    return (NSUInteger) results;
	}

- (NSInteger) cpuCount
	{
    return [self getSysInfo:HW_NCPU];
	}

- (NSInteger) totalMemoryBytes
	{
    return [self getSysInfo:HW_PHYSMEM];
	}

- (NSInteger) userMemoryBytes
	{
    return [self getSysInfo:HW_USERMEM];
	}

- (NSInteger) maximumSocketBufferBytes
	{
	//	This is the total memory dedicated to socket I/O.
	//	Again, not super useful so I removed it from the
	//	interface.
    return [self getSysInfo:KIPC_MAXSOCKBUF];
	}


#pragma mark - File System


- (int64_t) totalFileSystemBytes
	{
	assert(sizeof(long long) == sizeof(int64_t));
	NSError*error = nil;
    NSDictionary *fattributes =
		[[NSFileManager defaultManager]
			attributesOfFileSystemForPath:NSHomeDirectory()
			error:&error];
	if (error) ZDebug(@"Error: %@", error);
    return [[fattributes objectForKey:NSFileSystemSize] longLongValue];
	}

- (int64_t) availableFileSystemBytes
	{
	NSError*error = nil;
    NSDictionary *fattributes =
		[[NSFileManager defaultManager]
			attributesOfFileSystemForPath:NSHomeDirectory()
			error:&error];
	if (error) ZDebug(@"Error: %@", error);
    return [[fattributes objectForKey:NSFileSystemFreeSize] longLongValue];
	}


#pragma mark Hardware Capabilities


- (BOOL) hasRetinaDisplay
	{
    return ([UIScreen mainScreen].scale == 2.0f);
	}

- (BOOL) isiPad
	{
	return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
	}

- (NSString*) MACAddress
	{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0)
		{
        ZDebugBreakPointMessage(@"Error: if_nametoindex error.");
        return nil;
    	}
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
		{
        ZDebugBreakPointMessage(@"Error: sysctl error.");
        return nil;
    	}
    
    if ((buf = malloc(len)) == NULL)
		{
        ZDebugBreakPointMessage(@"Error: Memory allocation error.");
        return nil;
    	}
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
		{
        ZDebugBreakPointMessage(@"Error: sysctl error.");
        free(buf);
        return nil;
    	}
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
		*ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];

    free(buf);
    return outstring;
	}

#if defined(ZAllowAppStoreNonCompliant)

- (BOOL) bluetoothIsEnabled
	{
	//	Illegal Bluetooth check -- cannot be used in App Store
	
	BOOL result = NO;
	Class  btclass = NSClassFromString(@"GKBluetoothSupport");
	SEL   selector = NSSelectorFromString(@"bluetoothStatus");
	if ([btclass respondsToSelector:selector])
		{
		#pragma clang diagnostic push
		#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		int value = (int) [btclass performSelector:selector];
		#pragma clang diagnostic pop
		result = (value & (int)1) ? YES : NO;
		}

	return result;
	}

#endif

@end
