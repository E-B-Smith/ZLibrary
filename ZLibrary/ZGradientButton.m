


//-----------------------------------------------------------------------------------------------
//
//																		   		ZGradientButton.m
//																					 ZLibrary-iOS
//
//								   								   A nicely drawn button for iOS.
//																	     Edward Smith, March 2011
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZGradientButton.h"
#import "ZUtilities.h"
#import "UIColor+ZLibrary.h"
#import "ZDebug.h"


@interface ZGradientButton ()
	{
	CAGradientLayer*	gradient;
	}
@end


@implementation ZGradientButton

- (void) buildGradient
	{
	UIColor *darkerColor;		
	UIColor *lighterColor;
	gradient.frame = self.bounds;

	if (self.highlighted)
		{
		if (self.color.luminosity > 0.70)
			{
			darkerColor = [self.color colorByBlendingBlack:0.05];
			lighterColor= [self.color colorByBlendingWhite:0.70];
			}
		else
			{
			darkerColor	= [self.color colorByBlendingBlack:0.30];
			lighterColor= [self.color colorByBlendingWhite:0.50];
			}
		}
	else
		{
		if ([self.color luminosity] > 0.70)
			{
			darkerColor = [self.color colorByBlendingBlack:0.30];
			lighterColor= [self.color colorByBlendingWhite:1.00];
			}
		else
			{
			darkerColor	= [self.color colorByBlendingBlack:0.60];
			lighterColor= [self.color colorByBlendingWhite:0.80];
			}
		}
	gradient.colors = [NSArray arrayWithObjects:(id)lighterColor.CGColor, (id)self.color.CGColor, (id)darkerColor.CGColor, nil];
	[self setNeedsDisplay];
	}
	
- (void) commonInit
	{
	if (!self.color) self.color = [UIColor lightGrayColor];
	if (!gradient)   gradient = [[CAGradientLayer alloc] init];

	[self buildGradient];
	[self.layer insertSublayer:gradient atIndex:0];
		
	self.layer.cornerRadius = 7.0;
	self.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
	self.layer.borderWidth = 2.0;
	self.layer.masksToBounds = YES;
	}

- (id) initWithCoder:(NSCoder*)coder
	{
	self = [super initWithCoder:coder];
	if (!self) return self;
	[self commonInit];
	return self;
	}

- (id) initWithFrame:(CGRect)frame
	{
	self = [super initWithFrame:frame];
	if (!self) return self;
	[self commonInit];
	return self;
	}

- (void) setColor:(UIColor*)color
	{
	_color = color;
	[self buildGradient];
	}

- (void) setHighlighted:(BOOL)highlighted_
	{
	super.highlighted = highlighted_;
	[self buildGradient];
	}

- (void) layoutSubviews
	{
	[super layoutSubviews];
	[self buildGradient];
	}

- (void) layoutSublayersOfLayer:(CALayer *)layer
	{
	if ([UIButton instancesRespondToSelector:@selector(layoutSublayersOfLayer:)])
		{
		//	iOS 4.1 Crash work around --
		[super layoutSublayersOfLayer:layer];
		[self.layer insertSublayer:gradient atIndex:0];
		}
	}
	
@end
