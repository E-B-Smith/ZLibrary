


//-----------------------------------------------------------------------------------------------
//
//																		   ZRadialGradientLayer.h
//																					 ZLibrary-iOS
//
//														  				   Draws radial gradients
//																	 Edward Smith, September 2010
//
//								 -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <QuartzCore/QuartzCore.h>


@interface ZRadialGradientLayer : CALayer
@property (assign) CGPoint startPoint;
@property (assign) CGFloat startRadius;
@property (assign) CGPoint endPoint;
@property (assign) CGFloat endRadius;
@property (assign) CGGradientDrawingOptions options;

@property (strong) NSArray *colors;			//	NSArray* <UIColor*>
@property (strong) NSArray *locations;		//	NSArray* <NSNumber*>
@end
