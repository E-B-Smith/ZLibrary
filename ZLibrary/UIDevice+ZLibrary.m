


//-----------------------------------------------------------------------------------------------
//
//																			  UIDevice+ZLibrary.m
//																					 ZLibrary-iOS
//
//								   											 UIDevice extensions.
//																	  Edward Smith, December 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#include "UIDevice+ZLibrary.h"
#import "ZDebug.h"

#import <sys/socket.h>
#import <sys/sysctl.h>
#import <sys/types.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <arpa/inet.h>


#pragma mark Keys for deviceInfoForKey:

/*

https://github.com/Cykey/ios-reversed-headers/blob/master/MobileGestalt/MobileGestalt.h

deviceInfoForKey:

ActiveWirelessTechnology
AirplaneMode        
assistant        
BasebandCertId        
BasebandChipId        
BasebandPostponementStatus        
BasebandStatus        
BatteryCurrentCapacity        
BatteryIsCharging        
BluetoothAddress        
BoardId        
BootNonce        
BuildVersion        
CertificateProductionStatus        
CertificateSecurityMode        
ChipID        
CompassCalibrationDictionary        
CPUArchitecture        
DeviceClass        
DeviceColor        
DeviceEnclosureColor        
DeviceEnclosureRGBColor        
DeviceName        
DeviceRGBColor        
DeviceSupportsFaceTime        
DeviceVariant        
DeviceVariantGuess        
DiagData        
dictation        
DiskUsage        
EffectiveProductionStatus        
EffectiveProductionStatusAp        
EffectiveProductionStatusSEP        
EffectiveSecurityMode        
EffectiveSecurityModeAp        
EffectiveSecurityModeSEP        
FirmwarePreflightInfo        
FirmwareVersion        
FrontFacingCameraHFRCapability        
HardwarePlatform        
HasSEP        
HWModelStr        
Image4Supported        
InternalBuild        
InverseDeviceID        
ipad        
MixAndMatchPrevention        
MLBSerialNumber        
MobileSubscriberCountryCode        
MobileSubscriberNetworkCode        
ModelNumber        
PartitionType        
PasswordProtected        
ProductName        
ProductType
ProductVersion        
ProximitySensorCalibrationDictionary        
RearFacingCameraHFRCapability        
RegionCode        
RegionInfo        
SDIOManufacturerTuple        
SDIOProductInfo        
SerialNumber     
SIMTrayStatus        
SoftwareBehavior        
SoftwareBundleVersion        
SupportedDeviceFamilies        
SupportedKeyboards        
telephony        
UniqueChipID        
UniqueDeviceID        
UserAssignedDeviceName        
wifi        
WifiVendor

*/


#pragma mark - UIDevice (ZLibrary)


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
	if ([result isEqualToString:@"x86_64"] || [result isEqualToString:@"i386"])
		{
		result = [self.model stringByReplacingOccurrencesOfString:@" " withString:@""];
		if (![result localizedCaseInsensitiveContainsString:@"Simulator"])
			result = [result stringByAppendingString:@"Simulator"];
		}
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
	#if (TARGET_IPHONE_SIMULATOR)
		return YES;
	#else
		return NO;
	#endif	
	}


#pragma mark - sysctl Utilities


- (NSUInteger) getSysInfo:(uint)typeSpecifier
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

- (NSString*) usbSerialString
	{
	NSString * result = @"Unknown";
	
#if ZAllowAppStoreNonCompliant

	UIDevice * device = [UIDevice currentDevice];
	SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
	if (![device respondsToSelector:selector])
		{
		selector = NSSelectorFromString(@"_deviceInfoForKey:");
		if (![device respondsToSelector:selector])
			return result;
		}
			
	NSArray * keys =
		@[
		@"UniqueDeviceID",
		@"_UniqueDeviceID",
		@"uniqueDeviceID",
		@"uniquedeviceid",
		@"InverseDeviceID",
		@"_InverseDeviceID",
		@"UniqueDeviceIDData",
		@"deviceID",
		@"DeviceID",
		];

	for (NSString *key in keys)
		{
		#pragma clang diagnostic push
		#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		NSString* value = [device performSelector:selector withObject:key];
		#pragma clang diagnostic pop
		if (value)
			{
			ZDebug(@"Found Key: %@\t\tValue: %@.", key, value);
			return value;
			}
		}
		
#else

	result = @"AppStoreCompliant";

#endif

	return result;
	}

/*
- (NSString*) usbSerialString
	{
	NSString * result = @"Unknown";
	
#if ZAllowAppStoreNonCompliant

	UIDevice * device = [UIDevice currentDevice];

//	NSArray * selectorNames =
//		@[
//		@"deviceInfoForKey:",
//		@"_deviceInfoForKey:"
//		];

//	SEL selector = nil;
//	for (NSString * name in selectorNames)
//		{
//		ZDebug(@"Trying selector '%@'.", name);
//		selector = NSSelectorFromString(name);
//		if ([device respondsToSelector:selector])
//			break;
//		selector = nil;
//		}
//	if (!selector)
//		{
//		ZDebug(@"No selector!");
//		return nil;
//		}

	SEL selector1 = NSSelectorFromString(@"deviceInfoForKey:");
	if (![device respondsToSelector:selector1])
		selector1 = nil;
	SEL selector2 = NSSelectorFromString(@"_deviceInfoForKey:");
	if (![device respondsToSelector:selector2])
		selector2 = nil;

	NSArray * keys =
		@[
		@"DeviceColor",
		@"DeviceEnclosureColor",
		@"UniqueDeviceID",
		@"UniqueDeviceID",
		@"_UniqueDeviceID",
		@"uniquedeviceid",
		@"UDID",
		@"_UDID",
		@"InverseDeviceID",
		@"_InverseDeviceID",
		@"FirmwareVersion",
		@"UserAssignedDeviceName",
		@"UniqueDeviceIDData",
		@"EthernetMacAddress",
		@"deviceID",
		@"DeviceID",
		@"V_deviceID",
		@"V_DeviceID",
		@"UniqueDeviceID",
		@"DiagData",
		];

//		#pragma clang diagnostic push
//		#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//		#pragma clang diagnostic pop

	for (NSString *key in keys)
		{
		if (selector1)
			{
			__autoreleasing NSString* value = [device performSelector:selector1 withObject:key];
			ZDebug(@"s1 Key: %@\t\tValue: %@.", key, value);
			}
		if (selector2)
			{
			__autoreleasing NSString* value = [device performSelector:selector2 withObject:key];
			ZDebug(@"s2 Key: %@\t\tValue: %@.", key, value);
			}
//		if (value) return value;
		}

	ZDebug(@"First done!");

	NSError *error = nil;
	int fd = socket(AF_UNIX, SOCK_STREAM, 0);
	if (fd == -1)
		{
	    error = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
    	return nil;
  		}
  
	//	prevent SIGPIPE
	int on = 1;
	setsockopt(fd, SOL_SOCKET, SO_NOSIGPIPE, &on, sizeof(on));

	const struct timeval timeout = {.tv_sec=1, .tv_usec=0};
  	setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));

	// Connect socket
	struct sockaddr_un addr;
	addr.sun_family = AF_UNIX;
	strcpy(addr.sun_path, "/var/run/usbmuxd");
	socklen_t socklen = sizeof(addr);
	if (connect(fd, (struct sockaddr*)&addr, socklen) == -1)
		{
	    error = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
	    return nil;
  		}

	typedef union buffer_t
		{
		int8_t 		bytes[2048];
		uint32_t	words[512];
		}
		buffer_t;
	union buffer_t buffer;
	buffer.words[0] = 0x10000000;
	buffer.words[1] = 0x00000000;
	buffer.words[2] = 0x03000000;
	buffer.words[3] = 0x02000000;

	if (write(fd, &buffer, 4*sizeof(int32_t)) == -1)
		{
	    error = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
	    return nil;
  		}

	ssize_t len = 0;
	if ((len = read(fd, &buffer, sizeof(buffer))) == -1)
		{
	    error = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
	    return nil;
  		}

	result = @"Unknown";

#else

	result = @"AppStoreCompliant";

#endif

	return result;
	}
*/
	
	
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

- (NSString*) dik:(NSString*)key
	{
	static SEL selector = nil;
	NSString* result = nil;
	
	if (!selector)
		{
		selector = NSSelectorFromString(@"deviceInfoForKey:");
		if (![self respondsToSelector:selector])
			selector = nil;
		}
	if (!selector)
		{
		selector = NSSelectorFromString(@"_deviceInfoForKey:");
		if (![self respondsToSelector:selector])
			selector = nil;
		}

	if (selector)
		{
		#pragma clang diagnostic push
		#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		result = [self performSelector:selector withObject:key];
		#pragma clang diagnostic pop
		}

	return result;
	}
	
- (NSString*) serialNumber
	{
	return [self dik:@"SerialNumber"];
	}

- (NSString*) systemBuildVersion
	{
    int mib[2] = {CTL_KERN, KERN_OSVERSION};
    u_int namelen = sizeof(mib) / sizeof(mib[0]);

    //	Get the size for the buffer --

    size_t bufferSize = 0;
    sysctl(mib, namelen, NULL, &bufferSize, NULL, 0);
	if (bufferSize <= 0) return nil;

    u_char buildBuffer[bufferSize];
    int result = sysctl(mib, namelen, buildBuffer, &bufferSize, NULL, 0);

	NSString *version = nil;
    if (result >= 0)
        version = [[NSString alloc] initWithBytes:buildBuffer length:bufferSize-1 encoding:NSUTF8StringEncoding];

    return version;
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


#pragma mark - IPAddress


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


- (NSString*) localIPAddressIPv4
	{
	return [self localIPAddressPreferIPv4:YES];
	}

- (NSString*) localIPAddressIPv6
	{
	return [self localIPAddressPreferIPv4:NO];
	}

- (NSString *) localIPAddressPreferIPv4:(BOOL)preferIPv4
	{
    NSArray *searchOrder =
		(preferIPv4)
		? @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4,
		     IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ]

		: @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6,
			 IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;

    NSDictionary *addresses = [self IPAddresses];
    ZDebug(@"addresses: %@", addresses);

    __block NSString *address;
    [searchOrder enumerateObjectsUsingBlock:
	^ (NSString *key, NSUInteger idx, BOOL *stop)
		{
		address = addresses[key];
		if (address) *stop = YES;
        }];

    return address ? address : @"0.0.0.0";
	}

- (NSMutableDictionary<NSString*, NSString*>*) IPAddresses
	{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];

    // Retrieve the current interfaces - returns 0 on success

    struct ifaddrs *interfaces = NULL;
    if (getifaddrs(&interfaces) != 0)
		{
		if (interfaces) freeifaddrs(interfaces);
		return addresses;
		}

	// Loop through linked list of interfaces --

	struct ifaddrs *interface = NULL;
	for(interface=interfaces; interface; interface=interface->ifa_next)
		{
		if(!(interface->ifa_flags & IFF_UP))	// || (interface->ifa_flags & IFF_LOOPBACK))
			continue;

		const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
		if (!addr) continue;

		NSString *type = 0;
		NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
		char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];

		if (addr->sin_family == AF_INET)
			{
			if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN))
				type = IP_ADDR_IPv4;
			}
		else
		if (addr->sin_family == AF_INET6)
			{
			const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
			if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN))
				type = IP_ADDR_IPv6;
			}

		if (name && type)
			{
			NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
			addresses[key] = [NSString stringWithUTF8String:addrBuf];
			}
		}

    if (interfaces) freeifaddrs(interfaces);
    return addresses;
	}

@end
