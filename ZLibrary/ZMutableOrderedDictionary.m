//
//  ZMutableOrderedDictionary.m
//  Xprt
//
//  Created by Edward Smith on 5/23/16.
//  Copyright © 2016 Blitz Technologies. All rights reserved.
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

@end
