//
//  ZDictionaryCoder.h
//  ZLibrary
//
//  Created by Edward Smith on 11/6/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


#include "ZCoder.h"
#import "ZDebug.h"
#import <objc/runtime.h>


@implementation ZCoder

@synthesize dictionary;

#pragma mark General instance coding / decoding

#undef coderTypeDefinition
#define coderTypeDefinition(type, obj_c_encoding, upper_case_name, lower_case_name, coder_type) \
	case obj_c_encoding: \
		{ \
		void* valuePtr = objectPtr + ivar_getOffset(*ivar); \
		type value = *(type*)valuePtr; \
		[coder encode##coder_type:value forKey:nameString]; \
		break; \
		}

+ (void) encodeObject:(id)object withCoder:(NSCoder*)coder ignoringMembers:(NSArray*)ignoredMembers
	{
	if (!object) return;
	if (!coder.allowsKeyedCoding)
		{
		[NSException raise:NSInvalidArgumentException format:@"NSCoder must allow keyed coding."];
		return;
		}
		
	uint count = 0;
	Ivar* ivarList = class_copyIvarList([object class], &count);
	Ivar* ivar = ivarList;
	void* objectPtr = (__bridge void*) object;
	
	for (int i = 0; i < count; ++i)
		{
		const char* name = ivar_getName(*ivar);
		NSString *nameString = [NSString stringWithUTF8String:name];
		if (![ignoredMembers containsObject:nameString])
			{
			char type = *ivar_getTypeEncoding(*ivar);
			switch (type)
				{
				case '@':
					{
					id value = object_getIvar(object, *ivar);
					if (value) [coder encodeObject:value forKey:nameString];
					break;
					}
				
//				#define ignore_BOOL		//	New type in Xcode 5.1
				#define ignore_id
				#include "ZCoder.h"
//				#undef ignore_BOOL
				#undef ignore_id
				
				default:
					ZDebugBreakPointMessage(@"Format not handled: %c", type);
					[NSException raise:NSInvalidArgumentException format:@"Format not handled: %c", type];
					return;
				}
			}
			
		++ivar;
		}
		
	free(ivarList);
	}

#undef coderTypeDefinition
#define coderTypeDefinition(type, obj_c_encoding, upper_case_name, lower_case_name, coder_type) \
	case obj_c_encoding: \
		{ \
		type value = [decoder decode##coder_type##ForKey:nameString]; \
		void* valuePtr = objectPtr + ivar_getOffset(*ivar); \
		*(type*)valuePtr = value; \
		break; \
		}

+ (void) decodeObject:(id)object withCoder:(NSCoder*)decoder ignoringMembers:(NSArray*)ignoredMembers
	{
	if (!object) return;
	if (!decoder.allowsKeyedCoding)
		{
		[NSException raise:NSInvalidArgumentException format:@"NSCoder must allow keyed coding."];
		return;
		}
		
	uint count = 0;
	Ivar* ivarList = class_copyIvarList([object class], &count);
	Ivar* ivar = ivarList;
	void* objectPtr = (__bridge void*) object;
	
	for (int i = 0; i < count; ++i)
		{
		const char* name = ivar_getName(*ivar);
		NSString *nameString = [NSString stringWithUTF8String:name];
		if (![ignoredMembers containsObject:nameString])
			{
			char type = *ivar_getTypeEncoding(*ivar);
			switch (type)
				{
				case '@':
					{
					id value = [decoder decodeObjectForKey:nameString];
					if (!value) ZDebug(@"Warning: %@ ivar %@ not present in archive.", [object class], nameString);
					object_setIvar(object, *ivar, value);
					break;
					}
				
//				#define ignore_BOOL		//	New type in Xcode 5.1
				#define ignore_id
				#include "ZCoder.h"
//				#undef ignore_BOOL
				#undef ignore_id
					
				default:
					[NSException raise:NSInvalidArgumentException format:@"Format not handled: %c", type];
					return;
				}
			}
			
		++ivar;
		}
		
	free(ivarList);
	}

#pragma mark - Coding to or from a NSDictionary 

+ (NSMutableDictionary*) encodeToDictionary:(id)object
	{
	NSMutableDictionary* dictionary = [NSMutableDictionary new];
	ZCoder* coder = [ZCoder encoderWithDictionary:dictionary];
	[ZCoder encodeObject:object withCoder:coder ignoringMembers:nil];
	[dictionary setObject:NSStringFromClass([object class]) forKey:@"ZCoderClass"];
	return dictionary;
	}

+ (id) decodeFromDictionary:(NSDictionary*)dictionary
	{
	NSString* classString = [dictionary objectForKey:@"ZCoderClass"];
	Class objectClass = NSClassFromString(classString);
	if (!objectClass) return nil;
	id object = [objectClass new];
	
	ZCoder *decoder = [ZCoder decoderWithDictionary:dictionary];
	[ZCoder decodeObject:object withCoder:decoder ignoringMembers:nil];
	return object;
	}

+ (ZCoder*) encoderWithDictionary:(NSMutableDictionary*)dictionary
	{
	ZCoder *zdc = [ZCoder new];
	zdc.dictionary = dictionary;
	return zdc;
	}

+ (ZCoder*) decoderWithDictionary:(NSDictionary*)dictionary
	{
	ZCoder *zdc = [ZCoder new];
	zdc.dictionary = (NSMutableDictionary*) dictionary;
	return zdc;
	}

- (BOOL) allowsKeyedCoding
	{
	return YES;
	}

- (void) encodeBytes:(const uint8_t *)bytesp length:(NSUInteger)lenv forKey:(NSString *)key
	{
	NSData *data = [NSData dataWithBytes:bytesp length:lenv];
	[self.dictionary setObject:data forKey:key];
	}

- (const uint8_t *)decodeBytesForKey:(NSString *)key returnedLength:(NSUInteger *)lengthp
	{
	NSData* data = [self.dictionary objectForKey:key];
	if ([data isKindOfClass:[NSData class]])
		{
		if (lengthp)
			*lengthp = data.length;
		return data.bytes;
		}
	else
		{
		if (lengthp)
			*lengthp = 0;
		return NULL;
		}
	}

- (BOOL) containsValueForKey:(NSString *)key
	{
	return !![dictionary objectForKey:key];
	}

- (void) encodeObject:(id)objv forKey:(NSString *)key
	{
	if (objv && key) //	eDebug -- for iOS 8.0.  Seems like an iOS bug?
		[dictionary setObject:objv forKey:key];
	}

- (id) decodeObjectForKey:(NSString*)key
	{
	return (key) ? [dictionary objectForKey:key] : nil;
//	return [dictionary objectForKey:key];
	}


#undef coderTypeDefinition
#define coderTypeDefinition(type, obj_c_encoding, upper_case_name, lower_case_name, coder_type) \
	- (void) encode##coder_type:(type)realv forKey:(NSString*)key \
		{ \
		[dictionary setObject:[NSNumber numberWith##upper_case_name:realv] forKey:key]; \
		} \
	- (type) decode##coder_type##ForKey:(NSString*)key \
		{ \
		return (type) [[dictionary objectForKey:key] lower_case_name##Value]; \
		}

#define ignore_char
#define ignore_id
#define ignore_short
#define ignore_long
#include "ZCoder.h"
#undef ignore_char
#undef ignore_id
#undef ignore_short
#undef ignore_long

@end


#pragma mark - NSObject (ZDictionaryCoder)


@implementation NSObject (ZDictionaryCoder)

- (NSDictionary*) encodeToDictionary
	{
	return [ZCoder encodeToDictionary:self];
	}

+ (id) decodeFromDictionary:(NSDictionary*)dictionary
	{
	return [ZCoder decodeFromDictionary:dictionary];
	}

@end
