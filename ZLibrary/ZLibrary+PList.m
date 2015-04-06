

//-----------------------------------------------------------------------------------------------
//
//																			     ZLibrary+PList.m
//																					 ZLibrary-iOS
//
//					  Replaces invalid plist objects in a dictionary or array with proxy objects.
//																	   Edward Smith, January 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------



#import "ZLibrary+PList.h"
#import "ZUtilities.h"
#import "ZCoder.h"
#import "ZDebug.h"


@implementation NSDictionary (ZLibraryPList)

- (NSMutableDictionary*) dictionaryForPListReplacingInvalidObjectsWith:(id)placeHolderObject
	{		
	NSMutableDictionary* newDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
	
	for (id<NSCopying, NSObject> key in self.keyEnumerator)
		{
		id<NSObject> item = [self objectForKey:key];
		
		if (![key isKindOfClass:[NSString class]])
			{
			ZDebug(@"Invalid key of class %@: %@.", NSStringFromClass([key class]), key);
			}
		else		
		if ([item isKindOfClass:[NSString class]]	||
			[item isKindOfClass:[NSNumber class]]	||
			[item isKindOfClass:[NSDate class]]		||
			[item isKindOfClass:[NSData class]])
			{
			[newDictionary setObject:item forKey:key];
			}
		else
		if ([item isKindOfClass:[NSArray class]])
			{
			NSMutableArray* newArray =
				[(NSArray*)item arrayForPListReplacingInvalidObjectsWith:placeHolderObject];
			[newDictionary setObject:newArray forKey:key];
			}
		else
		if ([item isKindOfClass:[NSDictionary class]])
			{
			NSMutableDictionary* subDictionary =
				[(NSDictionary*)item dictionaryForPListReplacingInvalidObjectsWith:placeHolderObject];
			[newDictionary setObject:subDictionary forKey:key];
			}
		else
			{
			ZDebug(@"Invalid PList object found of type %@.\nKey: %@ Value: %@.",
				NSStringFromClass([item class]), key, item);
			if (placeHolderObject)
				[newDictionary setObject:placeHolderObject forKey:key];
			}
		}
		
	return newDictionary;
	}

- (NSMutableDictionary*) dictionaryForPListEncodingInvalidObjects
	{
	NSMutableDictionary* newDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
	
	for (id<NSCopying, NSObject> key in self.keyEnumerator)
		{
		id<NSObject> item = [self objectForKey:key];
		
		if (![key isKindOfClass:[NSString class]])
			{
			ZDebug(@"Invalid key of class %@: %@.", NSStringFromClass([key class]), key);
			}
		else		
		if ([item isKindOfClass:[NSString class]]	||
			[item isKindOfClass:[NSNumber class]]	||
			[item isKindOfClass:[NSDate class]]		||
			[item isKindOfClass:[NSData class]])
			{
			[newDictionary setObject:item forKey:key];
			}
		else
		if ([item isKindOfClass:[NSArray class]])
			{
			NSMutableArray* newArray = [((NSArray*)item) arrayForPListEncodingInvalidObjects];
			[newDictionary setObject:newArray forKey:key];
			}
		else
		if ([item isKindOfClass:[NSDictionary class]])
			{
			NSMutableDictionary* subDictionary = [(NSDictionary*)item dictionaryForPListEncodingInvalidObjects];
			[newDictionary setObject:subDictionary forKey:key];
			}
		else
			{
			NSString *newKey = [NSString stringWithFormat:@"@%@@%@", key, NSStringFromClass(item.class)];
			ZDebug(@"Encoding PList object %@.", newKey);
			NSDictionary *newItem = [((id)item) encodeToDictionary];
			newItem = [newItem dictionaryForPListEncodingInvalidObjects];
			[newDictionary setObject:newItem forKey:newKey];
			}
		}
		
	return newDictionary;
	}

- (NSMutableDictionary*) dictionaryFromPListDecodingInvalidObjects
	{
	NSMutableDictionary* newDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
	
	for (NSString* key in self.keyEnumerator)
		{
		id<NSObject> item = [self objectForKey:key];

		if ([key hasPrefix:@"@"])
			{
			NSArray *a = [key componentsSeparatedByString:@"@"];
			if (a.count != 2) continue;

			NSString*keyString = a[0];
			NSString*classString = a[1];
			NSDictionary * d = [NSClassFromString(classString) decodeFromDictionary:((NSDictionary*)item)];
			d = [d dictionaryFromPListDecodingInvalidObjects];
			[newDictionary setObject:d forKey:keyString];
			}
		else
		if ([item isKindOfClass:[NSArray class]])
			{
			item = [((NSArray*)item) arrayFromPListDecodingInvalidObjects];
			[newDictionary setObject:item forKey:key];
			}
		else
		if ([item isKindOfClass:[NSDictionary class]])
			{
			item = [((NSDictionary*)item) dictionaryFromPListDecodingInvalidObjects];
			[newDictionary setObject:item forKey:key];
			}
		else
			{
			[newDictionary setObject:item forKey:key];
			}
		}

	return newDictionary;
	}

@end



#pragma mark - NSArray


@implementation NSArray (ZLibraryPList)

- (NSMutableArray*) arrayForPListReplacingInvalidObjectsWith:(id)placeHolderObject
	{
	NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:self.count];
	for (NSInteger i = 0; i < self.count; ++i)
		{
		id<NSObject> item = [self objectAtIndex:i];

		if ([item isKindOfClass:[NSString class]]	||
			[item isKindOfClass:[NSNumber class]]	||
			[item isKindOfClass:[NSDate class]]		||
			[item isKindOfClass:[NSData class]])
			{
			[newArray addObject:item];
			}
		else
		if ([item isKindOfClass:[NSArray class]])
			{
			NSMutableArray* newItem =
				[(NSArray*)item arrayForPListReplacingInvalidObjectsWith:placeHolderObject];
			[newArray addObject:newItem];
			}
		else
		if ([item isKindOfClass:[NSDictionary class]])
			{
			NSMutableDictionary* newDictionary =
				[(NSDictionary*)item dictionaryForPListReplacingInvalidObjectsWith:placeHolderObject];
			[newArray addObject:newDictionary];
			}
		else
			{
			ZDebug(@"Invalid PList object found of type %@. Value: %@.", NSStringFromClass([item class]), item);
			if (placeHolderObject)
				[newArray addObject:placeHolderObject];
			}
		}
		
	return newArray;
	}

- (NSMutableArray*) arrayForPListEncodingInvalidObjects
	{
	NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:self.count];
	
	for (id<NSObject>item in self)
		{
		if ([item isKindOfClass:[NSString class]]	||
			[item isKindOfClass:[NSNumber class]]	||
			[item isKindOfClass:[NSDate class]]		||
			[item isKindOfClass:[NSData class]])
			{
			[newArray addObject:item];
			}
		else
		if ([item isKindOfClass:[NSArray class]])
			{
			NSMutableArray* newArray = [((NSArray*)item) arrayForPListEncodingInvalidObjects];
			[newArray addObject:newArray];
			}
		else
		if ([item isKindOfClass:[NSDictionary class]])
			{
			NSMutableDictionary* subDictionary = [(NSDictionary*)item dictionaryForPListEncodingInvalidObjects];
			[newArray addObject:subDictionary];
			}
		else
			{
			NSString *newKey = [NSString stringWithFormat:@"@%@", NSStringFromClass(item.class)];
			ZDebug(@"Encoding PList object %@.", newKey);
			NSDictionary *newItem = [((id)item) encodeToDictionary];
			newItem = [newItem dictionaryForPListEncodingInvalidObjects];
			NSDictionary * subdictionary = [NSDictionary dictionaryWithObject:newItem forKey:newKey];
			[newArray addObject:subdictionary];
			}
		}
		
	return newArray;
	}

- (NSMutableArray*) arrayFromPListDecodingInvalidObjects
	{
	NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:self.count];
	
	for (id<NSObject>item in self)
		{
		if ([item isKindOfClass:[NSArray class]])
			{
			NSArray* newItem = [((NSArray*)item) arrayFromPListDecodingInvalidObjects];
			[newArray addObject:newItem];
			}
		else
		if ([item isKindOfClass:[NSDictionary class]])
			{
			NSDictionary *dictionary = (NSDictionary*) item;
			NSArray *keys = [dictionary allKeys];
			if (keys.count == 1 && [keys[0] hasPrefix:@"@"])
				{
				NSDictionary * subdictionary = [dictionary objectForKey:keys[0]];
				NSArray *parts = [keys[0] componentsSeparatedByString:@"@"];
				if (parts.count != 2) continue;
				NSString *className = parts[1];
				id<NSObject> newItem = [NSClassFromString(className) decodeFromDictionary:subdictionary];
				[newArray addObject:newItem];
				}
			else
				{
				NSDictionary *newItem = [((NSDictionary*)item) dictionaryFromPListDecodingInvalidObjects];
				[newArray addObject:newItem];
				}
			}
		else
			{
			[newArray addObject:item];
			}
		}

	return newArray;
	}

@end

