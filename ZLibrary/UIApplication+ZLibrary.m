


//-----------------------------------------------------------------------------------------------
//
//																		 UIApplication+ZLibrary.m
//																					 ZLibrary-iOS
//
//								   				  				UIApplication+ZLibrary Extensions
//																	  Edward Smith, November 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


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
