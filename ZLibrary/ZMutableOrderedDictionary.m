//
//  ZMutableOrderedDictionary.m
//  ZLibrary
//
//  Created by Edward Smith on 5/23/16.
//  Copyright © 2016 Edward Smith. All rights reserved.
//


#import "ZMutableOrderedDictionary.h"


#pragma mark - ZMutableOrderedDictionary


@interface ZMutableOrderedDictionary ()
	{
	NSMutableArray		*array;
	NSMutableDictionary	*dictionary;
	}
@end


@implementation ZMutableOrderedDictionary

- (NSUInteger) count
	{
	return array.count;
	}

- (void) removeObjectForKey:(id)aKey
	{
    [dictionary removeObjectForKey:aKey];
    [array removeObject:aKey];
	}
	
- (void) setObject:(id)anObject forKey:(id)aKey
	{
   	if (![dictionary objectForKey:aKey])
		[array addObject:aKey];
    [dictionary setObject:anObject forKey:aKey];
	}

- (id) objectForKey:(id)aKey
	{
	return [dictionary objectForKey:aKey];
	}

- (NSEnumerator *)keyEnumerator
	{
    return [array objectEnumerator];
	}

- (id) objectAtIndex:(NSUInteger)index
	{
	id key = [array objectAtIndex:index];
	return (key) ? [dictionary objectForKey:key] : nil;
	}

- (id)objectAtIndexedSubscript:(NSUInteger)index;
	{
	id key = [array objectAtIndex:index];
	return (key) ? [dictionary objectForKey:key] : nil;
	}

- (instancetype) init
	{
    self = [super init];
	if (!self) return self;
	dictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
	array = [[NSMutableArray alloc] initWithCapacity:10];
    return self;
	}

- (id)initWithCapacity:(NSUInteger)capacity
	{
    self = [super init];
	if (!self) return self;
	dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
	array = [[NSMutableArray alloc] initWithCapacity:capacity];
    return self;
	}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
	{
	return [super initWithCoder:aDecoder];
	}

- (void) removeObjectAtIndex:(NSUInteger)index
	{
	id key = [array objectAtIndex:index];
	[dictionary removeObjectForKey:key];
	[array removeObjectAtIndex:index];
	}

- (void) removeLastObject
	{
	NSInteger idx = self.count-1;
	if (idx >= 0) [self removeObjectAtIndex:idx];
	}

- (id) firstObject
	{
	return (self.count > 0) ? [self objectAtIndex:0] : nil;
	}

- (id) lastObject
	{
	NSInteger idx = self.count-1;
	return (idx >= 0) ? [self objectAtIndex:idx] : nil;
	}

- (NSMutableArray*) mutableArray
	{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
	for (id key in array)
		[result addObject:[dictionary objectForKey:key]];
	return result;
	}

@end
