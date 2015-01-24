

//-----------------------------------------------------------------------------------------------
//
//																			   		 ZSingleton.h
//																					 ZLibrary-Mac
//
//								   								  A rigorous singleton base class
//																	  Edward Smith, November 2008
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>


//	A subclass must implement the define in the implementation section like:
//
//	@implementation ANewSingleton
//
//	ZSingletonSubclass(ANewSingleton)
//	...


#define ZSingletonSubclass(dSubclassName) \
\
static dSubclassName* sharedInstance = nil; \
\
+ (dSubclassName*) sharedInstance \
	{ \
	@synchronized([dSubclassName class]) \
		{ \
		if (!sharedInstance) \
			{ \
			sharedInstance = [[dSubclassName alloc] init]; \
			} \
		} \
	return sharedInstance; \
	} \
\
+ (id) allocWithZone:(NSZone *)zone \
	{ \
    @synchronized([dSubclassName class]) \
		{ \
        if (!sharedInstance) \
			{ \
            sharedInstance = [super allocWithZone:zone]; \
            return sharedInstance; \
			} \
		} \
    return nil;	\
	} \


//	(On subsequent allocation attempts allocWithZone returns nil).


@interface ZSingleton : NSObject 
	{
	}
	
+ (id) sharedInstance;

@end
