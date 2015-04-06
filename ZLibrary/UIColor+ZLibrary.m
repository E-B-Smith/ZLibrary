//
//  UIColor+ZLibrary.m
//  ZLibrary
//
//  Created by Edward Smith on 1/17/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import "UIColor+ZLibrary.h"
#import "ZDebug.h"


@implementation UIColor (ZLibrary)


- (CGColorSpaceModel) colorSpaceModel 
	{
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
	}


- (BOOL) canProvideRGBComponents 
	{
	switch (self.colorSpaceModel) 
		{
		case kCGColorSpaceModelRGB:
		case kCGColorSpaceModelMonochrome:
			return YES;
		default:
			return NO;
		}
	}

//	Was needed pre-iOS 5.0, this still provides better general results --
	
- (BOOL) ZRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha
	{
	BOOL result = YES;
	const CGFloat *components = CGColorGetComponents(self.CGColor);

	CGFloat r=0.0,g=0.0,b=0.0,a=0.0;

	switch (self.colorSpaceModel) 
		{
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			a = components[1];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			a = components[3];
			break;
		default: // We don't know how to handle this model
			result = NO;
		}

	if (red) *red = r;
	if (green) *green = g;
	if (blue) *blue = b;
	if (alpha) *alpha = a;

	return result;
	}


+ (UIColor*) colorWith255R:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue
	{
	return [UIColor colorWithRed:(CGFloat)red/255.0 green:(CGFloat)green/255.0 blue:(CGFloat)blue/255.0 alpha:1.0];
	}

+ (UIColor*) colorWithHexInt:(NSUInteger)hex
	{
	CGFloat red, green, blue;
	red   = (hex >> 16) & 0xFF;
	green = (hex >>  8) & 0xFF;
	blue  =  hex        & 0xFF;
	return [UIColor colorWithRed: red / 255.0f green: green / 255.0f blue: blue / 255.0f alpha: 1.0f];
	}

+ (UIColor*) colorWithHex:(NSString*)hexstring
	{
	const char *cString = [hexstring cStringUsingEncoding: NSASCIIStringEncoding];
	NSUInteger hex;
	
	if (cString[0] == '#')
		hex = strtol(cString + 1, NULL, 16);
	else
		hex = strtol(cString, NULL, 16);
	
	return [self colorWithHexInt:hex];
	}
	
- (UIColor*) colorByBlendingWhite:(CGFloat)percent
	{
	CGFloat r=0,g=0,b=0,a=0;
	if (![self  ZRed:&r green:&g blue:&b alpha:&a])
		return self;
	CGFloat p = MAX(0.0, MIN(percent, 1.0));
	UIColor *color = [UIColor colorWithRed:MIN(r+p, 1.0) green:MIN(g+p, 1.0) blue:MIN(b+p, 1.0) alpha:a];
	return color;
	}


- (UIColor*) colorByBlendingBlack:(CGFloat)percent
	{
	CGFloat r=0,g=0,b=0,a=0;
	if (![self  ZRed:&r green:&g blue:&b alpha:&a])
		return self;
	CGFloat p = MAX(0.0, MIN(percent, 1.0));
	UIColor *color = [UIColor colorWithRed:MAX(r-p, 0.0) green:MAX(g-p, 0.0) blue:MAX(b-p, 0.0) alpha:a];
	return color;
	}


- (CGFloat) luminosity
	{
	CGFloat r=0,g=0,b=0,a=0;
	[self ZRed:&r green:&g blue:&b alpha:&a];
	return ((r + g + b) / 3.0) * a;
	}


- (CGFloat) distanceFromColor:(UIColor*)color
	{
	CGFloat c1[4], c2[4];
	[color ZRed:&c1[0] green:&c1[1] blue:&c1[2] alpha:&c1[3]];
	[self  ZRed:&c2[0] green:&c2[1] blue:&c2[2] alpha:&c2[3]];
	
	CGFloat r = c1[0]*c1[3] - c2[0]*c2[3];
	CGFloat g = c1[1]*c1[3] - c2[1]*c2[3];
	CGFloat b = c1[2]*c1[3] - c2[2]*c2[3];
	
//	return sqrtf(r*r + g*g + b*b) / 1.73205080f;	//	sqrt(3) to normalize 0.0 - 1.0  ?
	return (r*r + g*g + b*b) / 3.0f;
	}


@end
