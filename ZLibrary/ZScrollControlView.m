


//-----------------------------------------------------------------------------------------------
//
//																			 ZScrollControlView.m
//																					 ZLibrary-iOS
//
//	                           Prevents touches to controls on scroll views from being cancelled.
//																	   Edward Smith, August 2014. 
//
//								 -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------



#import "ZScrollControlView.h"


@implementation ZScrollControlView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
	{
	return NO;
	}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
	{
	for (UIView *view in self.subviews)
		{
		if ([view pointInside:point withEvent:event])
			return YES;
		}
	return NO;
	}
	
@end
