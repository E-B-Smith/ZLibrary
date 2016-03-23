//
//  APHotLabel.m
//  Blitz
//
//  Created by Edward Smith on 3/22/16.
//  Copyright © 2016 Blitz Here. All rights reserved.
//


#import "APHotLabel.h"


@interface APHotLabel ()
	{
	BOOL touchesStarted;
	}
@property (weak, nonatomic) 	id<NSObject> target;
@property (assign, nonatomic)	SEL selector;
@end


@implementation APHotLabel

- (instancetype) initWithCoder:(NSCoder *)aDecoder
	{
	self = [super initWithCoder:aDecoder];
	if (!self) return self;
	self.userInteractionEnabled = YES;
	return self;
	}

- (void) setTouchUpTarget:(id)target action:(SEL)action
	{
	self.target = target;
	self.selector = action;
	}

- (void) touchesBegan:(NSSet<UITouch *> *)touches 
			withEvent:(UIEvent *)event
	{
	if (event.type == UIEventTypeTouches)
		{
		UITouch *touch = [[event touchesForView:self] anyObject];
		CGPoint p = [touch locationInView:self];
		if (CGRectContainsPoint(self.bounds, p))
			touchesStarted = YES;
		}
	}

- (void) touchesEnded:(NSSet<UITouch *> *)touches 
	withEvent:(UIEvent *)event
	{
	if (event.type == UIEventTypeTouches)
		{
		UITouch *touch = [[event touchesForView:self] anyObject];
		CGPoint p = [touch locationInView:self];
		if (CGRectContainsPoint(self.bounds, p))
			{
			if (self.target && self.selector)
				{
				#pragma clang diagnostic push
				#pragma clang diagnostic ignored "-Warc-performSelector-leaks"				
				[self.target performSelector:self.selector withObject:self];
				#pragma clang diagnostic pop
				}
			}
		touchesStarted = NO;
		}
	}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches 
	withEvent:(UIEvent *)event
	{
	touchesStarted = NO;
	}
		
@end
