

//-----------------------------------------------------------------------------------------------
//
//																			 NSDictionary+PList.m
//																					 ZLibrary-iOS
//
//							  Replaces invalid plist objects in a disctionary with proxy objects.
//																	   Edward Smith, January 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------



#import "NSDictionary+PList.h"
#import "NSArray+PList.h"
#import "ZDebug.h"


@implementation NSDictionary (PList)

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

@end
