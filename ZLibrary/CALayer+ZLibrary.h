


//-----------------------------------------------------------------------------------------------
//
//																			   CALayer+ZLibrary.h
//																					 ZLibrary-iOS
//
//								   									   Useful CALayer catagories.
//																	  Edward Smith, December 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <QuartzCore/QuartzCore.h>


@interface ZBorderLayer : CAShapeLayer
+ (ZBorderLayer*) borderWithEdges:(UIRectEdge)edges color:(CGColorRef)color width:(CGFloat)width;
@property (nonatomic, assign) CGColorRef color;
@property (nonatomic, assign) CGFloat 	 width;
@property (nonatomic, assign) UIRectEdge edges;
@end


@interface CALayer (ZLibrary)
- (CALayer*) findSublayerUsingPredicateBlock:(BOOL (^) (CALayer* sublayer))predicateBlock;
- (CALayer*) sublayerNamed:(NSString*)name;

- (void) addLineFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2 color:(CGColorRef)color;
- (void) removeLine;

- (void) removeAllSublayers;

- (ZBorderLayer*) addBorderWithEdges:(UIRectEdge)edges color:(CGColorRef)color width:(CGFloat)width;
@end



