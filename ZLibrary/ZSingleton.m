

//-----------------------------------------------------------------------------------------------
//
//																			   		 ZSingleton.m
//																					 ZLibrary-Mac
//
//								   								  A rigorous singleton base class
//																	  Edward Smith, November 2008
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZSingleton.h"
#import "ZDebug.h"


#pragma clang option push
#pragma clang option no-objc-arc

#if __has_feature(objc_arc)
#error This file cannot be compiled with ARC.  Use the -fno-objc-arc flag to disable ARC for this file.
#endif


@implementation ZSingleton

//ZSingletonSubclass(ZSingleton)	//	Do not un-comment!

- (void) dealloc
	{
	ZDebugAssertWithMessage(NO, @"Dealloc called on a singleton!");
	[super dealloc];
	}

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
