//
//  ZShapeButton.m
//  ZLibrary
//
//  Created by Edward Smith on 1/16/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import "ZShapeButton.h"


@interface ZShapeButton ()
	{
	CAShapeLayer	*shape;
	}
@end


@implementation ZShapeButton

- (void) commonInit
	{
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.50];
	self.layer.borderColor = [UIColor grayColor].CGColor;
	self.layer.borderWidth = 0.5f;
	}

- (void) dealloc
	{
	[shape removeFromSuperlayer];
	shape = nil;
	}

- (id)initWithFrame:(CGRect)frame
	{
    self = [super initWithFrame:frame];
    if (!self) return self;
	[self commonInit];
    return self;
	}

- (id) initWithCoder:(NSCoder *)aDecoder
	{
	self = [super initWithCoder:aDecoder];
	if (!self) return self;
	[self commonInit];
	return self;
	}

@dynamic backgroundShape;
- (UIBezierPath*) backgroundShape
	{
	CAShapeLayer *mask = (id) self.layer.sublayers.firstObject;
	if ([mask isKindOfClass:[CAShapeLayer class]])
		{
		CGPathRef path = mask.path;
		if (path) return [UIBezierPath bezierPathWithCGPath:path];
		}
	return nil;
	}

- (void) setBackgroundShape:(UIBezierPath*)backgroundShape
	{
	self.backgroundColor = [UIColor clearColor];
	self.layer.borderColor = nil;
	self.layer.borderWidth = 0.0f;
	
	if (!shape)
		{
		shape = [CAShapeLayer layer];
		shape.backgroundColor = [UIColor clearColor].CGColor;
		shape.frame = self.layer.bounds;
		shape.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.20].CGColor;
		shape.strokeColor = [UIColor grayColor].CGColor;
		shape.lineWidth = 0.5f;
		[self.layer addSublayer:shape];
		}
		
	shape.path  = backgroundShape.CGPath;
	}

@end
