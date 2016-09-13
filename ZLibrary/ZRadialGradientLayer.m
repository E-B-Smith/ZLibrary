


//-----------------------------------------------------------------------------------------------
//
//																		   ZRadialGradientLayer.m
//																					 ZLibrary-iOS
//
//														  				   Draws radial gradients
//																	 Edward Smith, September 2010
//
//								 -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZRadialGradientLayer.h"
#import "ZUtilities.h"
#import "ZDebug.h"


@interface ZRadialGradientLayer () <CALayerDelegate>
	{
	CGGradientRef	gradient;
	}
@end


@implementation ZRadialGradientLayer


- (void) initZRadialGradientLayer
	{
	self.delegate = self;
	self.needsDisplayOnBoundsChange = YES;	
	}
	
- (instancetype) init
	{
	self = [super init];
	if (!self) return self;
	[self initZRadialGradientLayer];
	return self;
	}
	
- (instancetype) initWithCoder:(NSCoder *)aDecoder
	{
	self = [super initWithCoder:aDecoder];
	if (!self) return self;
	[self initZRadialGradientLayer];
	return self;
	}
		
- (instancetype) initWithLayer:(id)layer
	{
	self = [super initWithLayer:layer];
	if (!self) return self;
	[self initZRadialGradientLayer];
	return self;
	}
	
- (void) dealloc
	{
	if (gradient) CGGradientRelease(gradient);
	}

- (void) makeGradient
	{
	//	Make our gradient -- 
	
	UIColor *firstColor = nil;
	CGColorSpaceRef colorSpace = NULL;
	CGFloat * colorArray = NULL;
	CGFloat * locationArray = NULL;
	
	if (gradient) CGGradientRelease(gradient);
	gradient = NULL;

	if (self.colors.count != self.locations.count)
		{	
		ZDebugAssertWithMessage(NO, @"Color and location counts don't match.");
		goto exit;
		}
	if (self.colors.count == 0) goto exit;
	
	firstColor = [_colors objectAtIndex:0];
	size_t componentsCount = CGColorGetNumberOfComponents(firstColor.CGColor);
	
	colorArray = calloc(_colors.count*componentsCount, sizeof(CGFloat));
	if (!colorArray) goto exit;
	
	CGFloat *cp = colorArray;
	for (UIColor *c in self.colors)
		{
		size_t n = CGColorGetNumberOfComponents(c.CGColor);
		if (n != componentsCount)
			{
			ZDebugAssertWithMessage(NO, @"All colors must be of same color space.");
			goto exit;
			}
		memcpy(cp, CGColorGetComponents(c.CGColor), sizeof(CGFloat)*componentsCount);
		cp += componentsCount;
		}
	
	locationArray = calloc(_locations.count, sizeof(CGFloat));
	if (!locationArray) goto exit;
	
	CGFloat *fp = locationArray;
	for (NSNumber* n in _locations)
		*fp++ = [n floatValue];

	colorSpace = CGColorGetColorSpace(firstColor.CGColor);
	gradient = 
		CGGradientCreateWithColorComponents(
			 colorSpace
			,colorArray
			,locationArray
			,_colors.count);

exit:
	if (colorArray) free(colorArray);
	if (locationArray) free(locationArray);
	}

- (void) drawInContext:(CGContextRef)ctx
	{
	if (!gradient) [self makeGradient];
	if (gradient && ctx)
		{
		CGRect bounds = self.bounds;
		CGPoint sp = CGPointMake(bounds.size.width * _startPoint.x, bounds.size.height * _startPoint.y);
		CGPoint ep = CGPointMake(bounds.size.width * _endPoint.x, bounds.size.height * _endPoint.y);

		//CGFloat d = ZDistance(CGPointMake(0.0, 0.0), CGPointMake(bounds.size.width, bounds.size.height));
		CGFloat d = MAX(bounds.size.width, bounds.size.height);
		CGFloat sr = _startRadius * d;
		CGFloat er = _endRadius * d;
		
		CGContextDrawRadialGradient(
			 ctx
			,gradient
			,sp
			,sr
			,ep
			,er
			,_options
			);
		}	
	}

/*
- (void) drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
	{
	[layer drawInContext:ctx];
	}
*/
	
@end

