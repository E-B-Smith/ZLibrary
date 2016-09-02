//
//  UIViewController+ZLibrary.m
//  ZLibrary
//
//  Created by Edward Smith on 12/1/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


#import "UIViewController+ZLibrary.h"
#import "UIView+ZLibrary.h"
#import "ZUtilities.h"


@implementation UIViewController (ZLibrary)

- (void) forceViewToLoad
	{
	if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0)
		[self forceViewToLoad];
	else
		{
		CGRect frame = self.view.frame;		//	Forces the view to load.
		ZCenterRectOverRect(frame, frame);	//	Nonsense call to avoid compiler warning.
		}
	}

+ (UIViewController*) activeViewController
	{
	UIView* view = [[UIApplication sharedApplication] keyWindow];
	view = [view firstResponder];
	while (view && ![view.nextResponder isKindOfClass:[UIViewController class]])
		view = (id) view.nextResponder;
	if ([view isKindOfClass:[UIViewController class]])
		return (id) view;
		
	//	That didn't work. Try reversing the search.
	
	view = [[UIApplication sharedApplication] keyWindow];
	for (UIView* subview in view.subviews.reverseObjectEnumerator)
		{
		if ([subview.nextResponder isKindOfClass:[UIViewController class]])
			return (id) subview.nextResponder;
		}
	
	return nil;
	}

- (UINavigationController*) presentingNavigationController
	{
	if (self.navigationController)
		return self.navigationController;
	UIViewController *vc = self.presentingViewController;
	while (vc && ![vc isKindOfClass:[UINavigationController class]])
		vc = vc.presentingViewController;
	return (UINavigationController*) vc;
	}

@end
