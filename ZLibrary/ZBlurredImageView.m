//
//  ZBlurredImageView.m
//  ZLibrary
//
//  Created by Edward Smith on 1/2/15.
//  Copyright (c) 2015 Edward Smith. All rights reserved.
//


#import "ZBlurredImageView.h"
#import "UIImage+ZLibrary.h"


@interface ZBlurredImageView ()
	{
	CALayer *blurLayer;
	}
@end


@implementation ZBlurredImageView

- (void) commonInit
	{
//	self.blurColor = [UIColor colorWithWhite:1.0 alpha:0.650];
	self.blurColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
	self.blurRadius = 90.0;
	}

- (instancetype) init
	{
	self = [super init];
	if (!self) return self;
	[self commonInit];
	return self;
	}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
	{
	self = [super initWithCoder:aDecoder];
	if (!self) return self;
	[self commonInit];
	return self;
	}

- (instancetype) initWithFrame:(CGRect)frame
	{
	self = [super initWithFrame:frame];
	if (!self) return self;
	[self commonInit];
	return self;
	}

- (void) setBlurred:(BOOL)blurred
	{
	[self setBlurred:blurred animated:NO];
	}

- (void) setBlurred:(BOOL)blur animated:(BOOL)animated
	{
	if (!!blur == !!self.isBlurred) return;
	_blurred = blur;
	[self updateBlurAnimated:animated];
	}

- (void) updateBlurAnimated:(BOOL)animated
	{
	if (self.isBlurred)
		{
		blurLayer = [CALayer layer];
		blurLayer.frame = self.bounds;
		[self.layer addSublayer:blurLayer];
		blurLayer.contents = (__bridge id)([self.image imageWithGaussianBlurOfRadius:self.blurRadius].CGImage);
		blurLayer.contentsGravity = self.layer.contentsGravity;

		CALayer *colorLayer = [CALayer layer];
		colorLayer.frame = self.bounds;
		colorLayer.backgroundColor = self.blurColor.CGColor;
		colorLayer.contentsGravity = kCAGravityResize;
		[blurLayer addSublayer:colorLayer];
		if (animated)
			{
			[CATransaction begin];
			CABasicAnimation *animation = nil;
			animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			animation.fromValue = @0.0;
			animation.toValue   = @1.0;
			animation.duration  = 0.8;
			animation.fillMode  = kCAFillModeForwards;
			animation.removedOnCompletion = YES;
			[blurLayer addAnimation:animation forKey:@"opacity"];
			[CATransaction commit];
			}
		}
	else
		{
		if (animated)
			{
			[CATransaction begin];
			[CATransaction setCompletionBlock:
				^ { [blurLayer removeFromSuperlayer]; blurLayer = nil; }];

			CABasicAnimation *animation = nil;
			animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			animation.fromValue = @0.0;
			animation.toValue   = @1.0;
			animation.duration  = 0.8;
			animation.fillMode  = kCAFillModeForwards;
			animation.removedOnCompletion = YES;
			[blurLayer addAnimation:animation forKey:@"opacity"];
			[CATransaction commit];
			}
		else
			{
			[blurLayer removeFromSuperlayer];
			blurLayer = nil;
			}
		}
	}

- (void) setBlurRadius:(CGFloat)blurRadius
	{
	if (blurRadius == self.blurRadius) return;
	_blurRadius = blurRadius;
	[self updateBlurAnimated:NO];
	}

- (void) setBlurColor:(UIColor *)blurColor
	{
	_blurColor = blurColor;
	[self updateBlurAnimated:NO];
	}

@end
