//
//  CALayer+ZLibrary.m
//  Search
//
//  Created by Edward Smith on 12/10/13.
//  Copyright (c) 2013 Relcy, Inc. All rights reserved.
//


#import "CALayer+ZLibrary.h"


@implementation CALayer (ZLibrary)

- (CALayer*) findSublayerUsingPredicateBlock:(BOOL (^) (CALayer* sublayer))predicateBlock
	{
	for (__strong CALayer* layer in self.sublayers)
		{
		if (predicateBlock(layer))
			return layer;
		else
			{
			if ((layer = [layer findSublayerUsingPredicateBlock:predicateBlock]))
				return layer;
			}
		}
	return nil;
	}	

- (CALayer*) findSublayerNamed:(NSString*)nameToFind
	{
	return [self findSublayerUsingPredicateBlock:
		^ BOOL(CALayer *sublayer) { return [sublayer.name isEqualToString:nameToFind]; }];
	}

static 	NSString* const kShapeLayerName = @"ZLibraryShapeLayer";

- (void) addLineFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2 color:(CGColorRef)color
	{
#if 0
	CAShapeLayer *shape = (id) [self findSublayerWithName:kShapeLayerName];
	if (!shape)
		{
		shape = [CAShapeLayer layer];
		shape.frame = self.bounds;
		shape.backgroundColor = [UIColor clearColor].CGColor;
		shape.name = kShapeLayerName;
		[self addSublayer:shape];
		}
#endif
	CAShapeLayer * shape = [CAShapeLayer layer];
	shape.frame = self.bounds;
	shape.backgroundColor = [UIColor clearColor].CGColor;
	shape.name = kShapeLayerName;
	[self addSublayer:shape];

	UIBezierPath *path =
		(shape.path) ? [UIBezierPath bezierPathWithCGPath:shape.path] : [UIBezierPath bezierPath];

	[path moveToPoint:point1];
	[path addLineToPoint:point2];
	
	shape.path = path.CGPath;
	shape.lineWidth = 0.5f;
	shape.strokeColor = color;
	}

- (void) removeLine
	{
	CALayer *lineLayer = [self findSublayerNamed:kShapeLayerName];
	[lineLayer removeFromSuperlayer];
	}

@end
