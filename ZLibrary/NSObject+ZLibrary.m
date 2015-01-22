//
//  NSObject+ZLibrary.m
//  Search
//
//  Created by Edward Smith on 1/22/14.
//  Copyright (c) 2014 Relcy, Inc. All rights reserved.
//


#import "NSObject+ZLibrary.h"
#import "ZDebug.h"
#import <objc/runtime.h>


@implementation NSObject (ZLibrary)

+ (BOOL) replaceMethod:(SEL)existingSelector withMethod:(SEL)selector
	{
	//	Method swizzling --
	
	Method existing = class_getInstanceMethod(self, existingSelector);
	Method method   = class_getInstanceMethod(self, selector);

	if (existing && method)
		{
		method_exchangeImplementations(existing, method);
		return YES;
		}
	else
		{
		ZDebug(@"Error: Swizzle methods not found.");
		return NO;
		}
	}

@end
