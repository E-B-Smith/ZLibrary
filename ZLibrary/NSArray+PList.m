


//-----------------------------------------------------------------------------------------------
//
//																				  NSArray+PList.m
//																					 ZLibrary-iOS
//
//								   Replaces invalid plist objects in an array with proxy objects.
//																	   Edward Smith, January 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "NSArray+PList.h"
#import "NSDictionary+PList.h"
#import "ZUtilities.h"
#import "ZDebug.h"


@implementation NSArray (NSArrayPList)

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

- (NSMutableArray*) shuffledArray
	{
	NSMutableArray * array = [NSMutableArray arrayWithArray:self];
	for (NSUInteger index = array.count-1; index > 0; --index)
		{
		int newIndex = rint(ZSequentialRand() * (double) index);
		id temp = array[newIndex];
		array[newIndex] = array[index];
		array[index] = temp;
		}

	return array;
	}

@end
