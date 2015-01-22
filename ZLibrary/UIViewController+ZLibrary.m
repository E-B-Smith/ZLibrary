//
//  UIViewController+ZLibrary.m
//  Search
//
//  Created by Edward Smith on 12/1/13.
//  Copyright (c) 2013 Relcy, Inc. All rights reserved.
//


#import "UIViewController+ZLibrary.h"
#import "UIView+ZLibrary.h"
#import "ZUtilities.h"


@implementation UIViewController (ZLibrary)

- (void) forceViewToLoad
	{
	CGRect frame = self.view.frame;		//	Forces the view to load.
	ZCenterRectOverRect(frame, frame);	//	Nonsense call to avoid compiler warning.
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

@end
