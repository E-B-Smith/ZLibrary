


//-----------------------------------------------------------------------------------------------
//
//																			   CALayer+ZLibrary.m
//																					 ZLibrary-iOS
//
//								   									   Useful CALayer catagories.
//																	  Edward Smith, December 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


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

- (CALayer*) sublayerNamed:(NSString*)nameToFind
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
	shape.zPosition = 2.0;
	}

- (void) removeLine
	{
	CALayer *lineLayer = [self sublayerNamed:kShapeLayerName];
	[lineLayer removeFromSuperlayer];
	}

- (void) removeAllSublayers
	{
	NSArray * sv = self.sublayers.copy;
	for (CALayer*v in sv) [v removeFromSuperlayer];
	}

@end


#pragma mark - ZUnderlineLayer


@interface ZUnderlineLayer ()
@property (assign, nonatomic) CALayer *lastSuperLayer;
@end


@implementation ZUnderlineLayer

- (void) dealloc
	{
	self.lastSuperLayer = nil;
	}

- (void) setLastSuperLayer:(CALayer *)lastSuperLayer_
	{
	if (_lastSuperLayer ==  lastSuperLayer_) return;
	[_lastSuperLayer removeObserver:self forKeyPath:@"bounds"];
	_lastSuperLayer	= lastSuperLayer_;
	[_lastSuperLayer addObserver:self forKeyPath:@"bounds" options:0 context:NULL];
	}
	
- (void) observeValueForKeyPath:(NSString *)keyPath
					   ofObject:(id)object
					 	 change:(NSDictionary<NSString *,id> *)change
						context:(void *)context
	{
	[self setNeedsLayout];
	}

- (id<CAAction>)actionForKey:(NSString *)key
	{
	self.lastSuperLayer = self.superlayer;
	return [super actionForKey:key];
	}
	
- (void) layoutSublayers
	{
	[super layoutSublayers];
	self.frame = self.superlayer.bounds;
	self.backgroundColor = [UIColor clearColor].CGColor;

	CGSize lastSize = self.bounds.size;
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(0.0, lastSize.height)];
	[path addLineToPoint:CGPointMake(lastSize.width, lastSize.height)];
	self.path = path.CGPath;
	}

+ (ZUnderlineLayer*) layerWithColor:(CGColorRef)color width:(CGFloat)width
	{
	ZUnderlineLayer *layer = [ZUnderlineLayer layer];
	layer.strokeColor = color;
	layer.lineWidth = width;
	layer.delegate = layer;
	[layer setNeedsLayout];
	return layer;
	}
	
@end
