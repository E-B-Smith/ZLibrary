//
//  UIApplication+ZLibrary.m
//  Search
//
//  Created by Edward Smith on 11/29/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


#import "UIApplication+ZLibrary.h"
#import "ZDebug.h"


@implementation UIApplication (ZLibrary)

+ (UIWindow*) topApplicationWindow
	{
	//	Find the top application window --

	UIWindow *appWindow = nil;
	for (UIWindow* window in [UIApplication sharedApplication].windows)
		{
		if (window.windowLevel == UIWindowLevelNormal)
			appWindow = window;
		}
	ZDebugAssertWithMessage(appWindow, @"Top application window not found!");
	return appWindow;
	}

@end
