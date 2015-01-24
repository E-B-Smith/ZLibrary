//
//  NSMutableArray+ZLibrary.m
//  Search
//
//  Created by Edward Smith on 5/20/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


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
