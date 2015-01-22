//
//  ZSingleton.m
//  ZLib-iPhone
//
//  Created by Edward Smith on 4/3/11.
//  Copyright 2011 Edward Smith. All rights reserved.
//


#import "ZSingleton.h"
	

@implementation ZSingleton

//ZSingletonSubclass(ZSingleton)	//	Do not un-comment!

- (id) copyWithZone:(NSZone *)zone
	{
    return self;
	}

- (id) retain 
	{
    return self;
	}

- (NSUInteger) retainCount 
	{
    return NSUIntegerMax;	//	Denotes an object that cannot be released
	}

- (oneway void) release 
	{
	}

- (id) autorelease 
	{
    return self;
	}

+ (id) sharedInstance
	{
	return nil;
	}
	
@end
