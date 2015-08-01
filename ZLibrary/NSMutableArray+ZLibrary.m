


//-----------------------------------------------------------------------------------------------
//
//																		NSMutableArray+ZLibrary.h
//																					     ZLibrary
//
//								   									   NSMutableArray extensions.
//																	       Edward Smith, May 2014
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "NSMutableArray+ZLibrary.h"


@implementation NSMutableArray (ZLibrary)

- (NSUInteger) addUniqueObject:(id)object
	{
	NSUInteger idx = [self indexOfObject:object];
	if (idx == NSNotFound)
		{
		[self addObject:object];
		idx = self.count - 1;
		}
	return idx;
	}

@end
