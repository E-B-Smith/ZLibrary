


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
#import "ZDebug.h"


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

- (ZBorderLayer*) addBorderWithEdges:(UIRectEdge)edges color:(CGColorRef)color width:(CGFloat)width
	{
	NSString *kBorderLayerName = @"ZBorderLayer";
	ZBorderLayer *layer = (id) [self sublayerNamed:kBorderLayerName];
	if (layer)
		{
		layer.edges = edges;
		layer.color = color;
		layer.width = width;
		[layer setNeedsLayout];
		[layer setNeedsDisplay];
		}
	else
		{
		layer = [ZBorderLayer borderWithEdges:edges color:color width:width];
		layer.name = kBorderLayerName;
		[self addSublayer:layer];
		}
	return layer;
	}

@end


#pragma mark - ZBorderLayer


@interface ZBorderLayer () <CAAction>
@property (weak, nonatomic) CALayer *lastSuperLayer;
@end


@implementation ZBorderLayer : CAShapeLayer

//	Crash debugging.
#if 0	//	----------------------------------------------------------------------

- (void) dealloc
	{
	ZDebug(@"Superlayer 0x%x last 0x%x", self.superlayer, _lastSuperLayer);
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

- (void)removeFromSuperlayer
	{
	self.lastSuperLayer = nil;
	[super removeFromSuperlayer];
	}

- (id<CAAction>)actionForKey:(NSString *)key
	{
	id<CAAction> result = [super actionForKey:key];
	self.lastSuperLayer = self.superlayer;
	return result;
	}

- (void) layoutSublayers
	{
	[super layoutSublayers];
	self.frame = self.superlayer.bounds;
	self.backgroundColor = [UIColor clearColor].CGColor;

	CGSize lastSize = self.bounds.size;
	UIBezierPath *path = [UIBezierPath bezierPath];
	if (self.edges & UIRectEdgeBottom)
		{
		[path moveToPoint:CGPointMake(0.0, lastSize.height)];
		[path addLineToPoint:CGPointMake(lastSize.width, lastSize.height)];
		}
	if (self.edges & UIRectEdgeTop)
		{
		[path moveToPoint:CGPointMake(0.0, 0.0)];
		[path addLineToPoint:CGPointMake(lastSize.width, 0.0)];
		}
	if (self.edges & UIRectEdgeLeft)
		{
		[path moveToPoint:CGPointMake(0.0, 0.0)];
		[path addLineToPoint:CGPointMake(0.0, lastSize.height)];
		}
	if (self.edges & UIRectEdgeRight)
		{
		[path moveToPoint:CGPointMake(lastSize.width, 0.0)];
		[path addLineToPoint:CGPointMake(lastSize.width, lastSize.height)];
		}
	self.path = path.CGPath;
	}

+ (ZBorderLayer*) borderWithEdges:(UIRectEdge)edges color:(CGColorRef)color width:(CGFloat)width
	{
	ZBorderLayer *layer = [ZBorderLayer layer];
	layer.edges = edges;
	layer.strokeColor = color;
	layer.lineWidth = width;
	layer.delegate = layer;
	[layer setNeedsLayout];
	return layer;
	}

#else

- (void) layoutSublayers
	{
	[super layoutSublayers];
	self.frame = self.superlayer.bounds;
	self.backgroundColor = [UIColor clearColor].CGColor;
	//ZDebug(@"Border edge frame: %@.", NSStringFromCGRect(self.frame));

	CGSize lastSize = self.bounds.size;
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointZero];

	if (self.edges & UIRectEdgeTop)
		[path addLineToPoint:CGPointMake(lastSize.width, 0.0)];
	else
		[path moveToPoint:CGPointMake(lastSize.width, 0.0)];

	if (self.edges & UIRectEdgeRight)
		[path addLineToPoint:CGPointMake(lastSize.width, lastSize.height)];
	else
		[path moveToPoint:CGPointMake(lastSize.width, lastSize.height)];

	if (self.edges & UIRectEdgeBottom)
		[path addLineToPoint:CGPointMake(0.0, lastSize.height)];
	else
		[path moveToPoint:CGPointMake(0.0, lastSize.height)];

	if (self.edges & UIRectEdgeLeft)
		[path addLineToPoint:CGPointZero];
	else
		[path moveToPoint:CGPointZero];

	self.path = path.CGPath;
	[self setNeedsDisplay];
	}

- (instancetype) init
	{
	self = [super init];
	if (!self) return self;
	self.contentsGravity = kCAGravityResize;
	self.needsDisplayOnBoundsChange = YES;
	self.actions = @{ kCAOnOrderIn: self, kCAOnOrderOut: self, kCATransition: self };
	return self;
	}

- (void) dealloc
	{
	//ZDebug(@"Superlayer 0x%x last 0x%x", self.superlayer, _lastSuperLayer);
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

- (void)runActionForKey:(NSString *)key
                 object:(id)anObject
              arguments:(NSDictionary *)dict
	{
	if ([key isEqualToString:kCAOnOrderIn])
		self.lastSuperLayer = self.superlayer;
	else
	if ([key isEqualToString:kCAOnOrderOut])
		self.lastSuperLayer = nil;
	[self setNeedsLayout];
	}

+ (ZBorderLayer*) borderWithEdges:(UIRectEdge)edges color:(CGColorRef)color width:(CGFloat)width
	{
	ZBorderLayer *layer = [ZBorderLayer layer];
	layer.edges = edges;
	layer.fillColor = [UIColor clearColor].CGColor;
	layer.strokeColor = color;
	layer.lineWidth = width;
	return layer;
	}

#endif

@end
