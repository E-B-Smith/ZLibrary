//
//  ZCircularImageView.m
//  ZLibrary
//
//  Created by Edward Smith on 5/9/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import "ZCircularImageView.h"
#import "ZUtilities.h"


@interface ZCircularImageView ()
	{
	CAShapeLayer	*mask;
	CAShapeLayer	*border;
	CALayer			*overlay;
	}
@end


@implementation ZCircularImageView

- (void) setBorderColor:(UIColor*)borderColor
	{
	_borderColor = borderColor;
	[self setNeedsLayout];
	}

- (void) setOverlayImage:(UIImage *)overlayImage
	{
	_overlayImage = overlayImage;
	[self setNeedsLayout];
	}

- (void) layoutSubviews
	{
	CGRect bounds = self.bounds;
	bounds.size.width = MIN(bounds.size.height, bounds.size.width);
	bounds.size.height = bounds.size.width;
	bounds = ZRectForContentMode(self.contentMode|UIViewContentModeClipped, bounds, self.bounds);
	mask = [CAShapeLayer layer];
	mask.frame = bounds;
	mask.path = [UIBezierPath bezierPathWithOvalInRect:mask.bounds].CGPath;
	mask.fillColor = [UIColor blackColor].CGColor;
	self.layer.mask = mask;
	
	[border removeFromSuperlayer];
	border = nil;
	if (self.borderColor)
		{
		border = [CAShapeLayer layer];
		border.frame = bounds;
		border.path = [UIBezierPath bezierPathWithOvalInRect:mask.bounds].CGPath;
		border.lineWidth = 1.0;
		border.strokeColor = self.borderColor.CGColor;
		border.fillColor = [UIColor clearColor].CGColor;
		border.zPosition = 2.0;
		[self.layer addSublayer:border];
		}

	[overlay removeFromSuperlayer];
	overlay = nil;
	if (self.overlayImage)
		{
		overlay = [CALayer layer];
		overlay.frame = self.bounds;
		overlay.contents = (id) self.overlayImage.CGImage;
		overlay.zPosition = 4.0;
		[self.layer addSublayer:overlay];
		}

	}
	
@end
