//
//  ZKeyChain.m
//  Search
//
//  Created by Edward Smith on 4/24/14.
//  Copyright (c) 2014 Relcy, Inc. All rights reserved.
//


#import "ZKeyChain.h"
#import "ZDebug.h"


@implementation ZKeyChain

+ (void) securePasswordValue:(id)password forPasswordKey:(NSString*)passwordKey service:(NSString*)service
	{
	NSMutableDictionary* keyDictionary = 
		[NSMutableDictionary dictionaryWithObjectsAndKeys:
			(__bridge id)kSecClassGenericPassword,				(__bridge id)kSecClass,
			service,											(__bridge id)kSecAttrService,
			(__bridge id)kSecAttrAccessibleAfterFirstUnlock,	(__bridge id)kSecAttrAccessible,
			nil];
		
	if (passwordKey && password)
		{
		[keyDictionary setObject:passwordKey forKey:(__bridge id)kSecAttrAccount];
		SecItemDelete((__bridge CFDictionaryRef)keyDictionary);
		if (password)
			{
			NSData* passwordData = [NSKeyedArchiver archivedDataWithRootObject:password];
            [keyDictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
            OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keyDictionary, NULL);
            if (status) ZDebug(@"Save to keychain failed with status %d.", status);
			}
		}
	}

+ (id) securedPasswordValueForPasswordKey:(NSString*)passwordKey service:(NSString*)service
	{
	if (passwordKey.length == 0) return nil;
	
	NSString* result = nil;
	NSMutableDictionary* keyDictionary = 
		[NSMutableDictionary dictionaryWithObjectsAndKeys:
			(__bridge id)kSecClassGenericPassword,	(__bridge id)kSecClass,
            service,								(__bridge id)kSecAttrService,
            passwordKey,							(__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock, (__bridge id)kSecAttrAccessible,
			(id)kCFBooleanTrue,						(__bridge id)kSecReturnData,
			(__bridge id)kSecMatchLimitOne,			(__bridge id)kSecMatchLimit,
            nil];
	CFDataRef keyData = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keyDictionary, (CFTypeRef *)&keyData);
	if (status || !keyData)
		ZDebug(@"Retrieve from keychain failed with status %d.", status);
	else
		result = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData*)keyData];
	if (keyData) CFRelease(keyData);
	return result;
	}

+ (void) deleteSecuredPasswordValueForPasswordKey:(NSString*)passwordKey service:(NSString*)service
	{
	NSDictionary* keyDictionary =
		[NSDictionary dictionaryWithObjectsAndKeys:
			(__bridge id)kSecClassGenericPassword,				(__bridge id)kSecClass,
			(id)service,										(__bridge id)kSecAttrService,
			(__bridge id)kSecAttrAccessibleAfterFirstUnlock,	(__bridge id)kSecAttrAccessible,
			(id)passwordKey,									(__bridge id)kSecAttrAccount,
			nil];
	OSStatus status = SecItemDelete((__bridge CFDictionaryRef)keyDictionary);
	if (status) ZDebug(@"Delete from keychain failed with status %d.", status);
	}

@end
