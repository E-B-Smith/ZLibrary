//
//  UIWindow+ZLibrary.m
//  Search
//
//  Created by Edward Smith on 1/9/14.
//  Copyright (c) 2014 Relcy, Inc. All rights reserved.
//


#import "UIWindow+ZLibrary.h"
#import "ZDebug.h"


@implementation UIWindow (ZLibrary)

+ (UIWindow*) rootWindow
	{
	//	Find the root application window --
	
	UIWindow *appWindow = nil;
	for (UIWindow* window in [UIApplication sharedApplication].windows)
		{
		if (window.windowLevel == UIWindowLevelNormal)
			{
			appWindow = window;
			break;
			}
		}
	ZDebugAssertWithMessage(appWindow, @"Window not found!");
	return appWindow;
	}

+ (UIWindow*) topWindow
	{
	//	Find the top application window --
	
	UIWindow *appWindow = nil;
	for (UIWindow* window in [UIApplication sharedApplication].windows.reverseObjectEnumerator)
		{
		if (window.windowLevel == UIWindowLevelNormal)
			{
			appWindow = window;
			break;
			}
		}
	ZDebugAssertWithMessage(appWindow, @"Window not found!");
	return appWindow;
	}

/*
+ (UIWindow*) keyWindow
	{
	//	Since I often type the wrong thing a wrote this helper function -- 
	return [[UIApplication sharedApplication] keyWindow];
	}
*/

@end


