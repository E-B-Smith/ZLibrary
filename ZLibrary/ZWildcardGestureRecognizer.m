//
//  ZWildcardGestureRecognizer.m
//  ZLibrary-iOS
//
//  Created by Edward Smith on 11/21/11.
//  Copyright (c) 2015 Edward Smith. All rights reserved.
//


#import "ZWildcardGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@interface ZWildcardGestureRecognizer () <UIGestureRecognizerDelegate>
@end


@implementation ZWildcardGestureRecognizer

- (id) initWithTarget:(id)target action:(SEL)action
	{
	self = [super initWithTarget:target action:action];
	if (!self) return self;
    self.cancelsTouchesInView = NO;
	self.delegate = self;
    return self;
	}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
	{
	self.state = UIGestureRecognizerStateRecognized;
	}

/*
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
	{
	}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
	{
	}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
	{
	}

- (void)reset
	{
	}

- (void)ignoreTouch:(UITouch *)touch forEvent:(UIEvent *)event
	{
	}
*/

- (BOOL) canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
	{
    return NO;
	}

- (BOOL) canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
	{
    return NO;
	}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
	   shouldReceiveTouch:(UITouch *)touch
	{
	CGPoint p = [touch locationInView:nil];
	for (UIView *view in self.excludedViews)
		{
		CGRect frame = [view convertRect:view.bounds toView:nil];
		if (CGRectContainsPoint(frame, p))
			return NO;
		}
	return YES;
	}
	
@end
