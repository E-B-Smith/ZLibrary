//
//  ZCoder.h
//  ZLibrary
//
//  Created by Edward Smith on 11/6/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//

//	coderTypeDefinition
//
//	coderTypeDefinition is defined here for multiple macro indludes.  The ZCoder class is
//	defined below.
//
//	coderTypeDefinition(type, obj_c_encoding, upper_case_name, lower_case_name, coder_type)


#pragma mark coderTypeDefinition
#if defined (coderTypeDefinition)


#ifndef ignore_BOOL
//coderTypeDefinition(BOOL,	'c', Bool, 		bool,		Bool)
coderTypeDefinition(BOOL,	'B', Bool,		bool,		Bool)	//	New type in Xcode 5.1
#endif

#ifndef ignore_char
coderTypeDefinition(char, 	'c', Int, 		int,		Int)
#endif 

#ifndef ignore_int
coderTypeDefinition(int, 	'i', Integer,	int,		Int)
#endif

#ifndef ignore_short
coderTypeDefinition(short, 	's', Int, 		int,		Int)
#endif

#ifndef ignore_long
coderTypeDefinition(long, 	'l', Integer,	integer,	Integer)
#endif

#ifndef ignore_int64_t
coderTypeDefinition(int64_t,'q', LongLong,	longLong,	Int64)
#endif

#ifndef ignore_float
coderTypeDefinition(float, 	'f', Float, 	float,		Float)
#endif

#ifndef ignore_double
coderTypeDefinition(double, 'd', Double, 	double,		Double)
#endif

#ifndef ignore_id
coderTypeDefinition(id, 	'@', Object, 	object,		Object)
#endif



#else	//	!defined (coderTypeDefinition)



#pragma mark - ZCoder
#import <Foundation/Foundation.h>


@interface ZCoder : NSCoder

//	General purpose encoders /decoders --

+ (void) decodeObject:(id)object withCoder:(NSCoder*)decoder ignoringMembers:(NSArray*)ignoredMembers;
+ (void) encodeObject:(id)object withCoder:(NSCoder*)decoder ignoringMembers:(NSArray*)ignoredMembers;

//	For encoding to or from an NSDictionary --

+ (ZCoder*) encoderWithDictionary:(NSMutableDictionary*)dictionary;	//	Coder for coding and decoding.
+ (ZCoder*) decoderWithDictionary:(NSDictionary*)dictionary;		//	Coder for decoding only.

+ (NSMutableDictionary*) encodeToDictionary:(id)object;
+ (id) decodeFromDictionary:(NSDictionary*)dictionary;

- (BOOL) allowsKeyedCoding;
- (BOOL) containsValueForKey:(NSString*)key;

@property (strong) NSMutableDictionary* dictionary;

@end


#pragma mark - ZDictionaryCoder


@protocol ZDictionaryCoder <NSObject>
- (NSDictionary*) encodeToDictionary;
+ (id) decodeFromDictionary:(NSDictionary*)dictionary;
@end


#pragma mark - NSObject (ZDictionaryCoder)


@interface NSObject (ZDictionaryCoder)
- (NSDictionary*) encodeToDictionary;
- (NSDictionary*) encodeToDictionaryIgnoringMembers:(NSArray*)members;
+ (id) decodeFromDictionary:(NSDictionary*)dictionary;
@end


#endif //	#if defined (coderTypeDefinition)
