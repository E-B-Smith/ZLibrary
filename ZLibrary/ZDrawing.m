//
//  ZDrawing.m
//  ZLibrary
//
//  Created by Edward Smith on 4/12/14.
//  Copyright (c) 2014 Edward Smith, Inc. All rights reserved.
//


#import "ZDrawing.h"


void ZDrawLinearGradientRect(
		CGContextRef context, CGRect rect,
		CGColorRef startColor, CGPoint startPoint,
		CGColorRef endColor, CGPoint endPoint)
	{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
 
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
 
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);

	startPoint.x = rect.origin.x + rect.size.width * startPoint.x;
	startPoint.y = rect.origin.y + rect.size.height * startPoint.y;

	endPoint.x = rect.origin.x + rect.size.width * endPoint.x;
	endPoint.y = rect.origin.y + rect.size.height * endPoint.y;

	CGContextSaveGState(context);
	CGContextAddRect(context, rect);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	CGContextRestoreGState(context);

	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
	}

void  ZDrawGradientFrameRect(CGContextRef context, CGRect outerRect, CGColorRef outerColor, CGFloat gradientBias, CGRect innerRect, CGColorRef innerColor)
	{
	//	Draw top --

	CGRect r = outerRect;
	r.size.height = innerRect.origin.y;
	ZDrawLinearGradientRect(context, r, outerColor, CGPointMake(gradientBias, 0.0), innerColor, CGPointMake(gradientBias, 1.0));

	//	Draw bottom --

	r = outerRect;
	r.origin.y = innerRect.origin.y + innerRect.size.height;
	r.size.height = (outerRect.origin.y + outerRect.size.height) - r.origin.y;
	ZDrawLinearGradientRect(context, r, innerColor, CGPointMake(gradientBias, 0.0), outerColor, CGPointMake(gradientBias, 1.0));

	//	Draw left -- Clip first.

	CGContextSaveGState(context);

	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:outerRect.origin];
	[path addLineToPoint:CGPointMake(outerRect.origin.x, outerRect.origin.y + outerRect.size.height)];
	[path addLineToPoint:CGPointMake(innerRect.origin.x, innerRect.origin.y + innerRect.size.height)];
	[path addLineToPoint:innerRect.origin];
	[path closePath];
	[path addClip];

	r = outerRect;
	r.size.width = innerRect.origin.x;
	ZDrawLinearGradientRect(context, r, outerColor, CGPointMake(0.0, gradientBias), innerColor, CGPointMake(1.0, gradientBias));

	CGContextRestoreGState(context);

	//	Draw right -- Clip first.

	CGContextSaveGState(context);

	path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(innerRect.origin.x + innerRect.size.width, innerRect.origin.y)];
	[path addLineToPoint:CGPointMake(innerRect.origin.x + innerRect.size.width, innerRect.origin.y + innerRect.size.height)];
	[path addLineToPoint:CGPointMake(outerRect.origin.x + outerRect.size.width, outerRect.origin.y + outerRect.size.height)];
	[path addLineToPoint:CGPointMake(outerRect.origin.x + outerRect.size.width, outerRect.origin.y)];
	[path closePath];
	[path addClip];

	r = outerRect;
	r.origin.x = innerRect.origin.x + innerRect.size.width;
	r.size.width = (outerRect.origin.x + outerRect.size.width) - r.origin.x;
	ZDrawLinearGradientRect(context, r, innerColor, CGPointMake(0.0, gradientBias), outerColor, CGPointMake(1.0, gradientBias));

	CGContextRestoreGState(context);
	}
