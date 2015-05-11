


//-----------------------------------------------------------------------------------------------
//
//																			   NSArray+ZLibrary.m
//																					 ZLibrary-iOS
//
//								   											   NSArray additions.
//																	   Edward Smith, January 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "NSArray+ZLibrary.h"
#import "ZUtilities.h"


@implementation NSArray (ZLibrary)

- (NSMutableArray*) shuffledArray
	{
	NSMutableArray * array = [NSMutableArray arrayWithArray:self];
	if (array.count <= 0) return array;
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
