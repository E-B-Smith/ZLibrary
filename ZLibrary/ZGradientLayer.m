//
//  ZGradientLayer.m
//  ZLibrary-iOS
//
//  Created by Edward Smith on 1/27/15.
//  Copyright (c) 2015 Edward Smith, All rights reserved.
//


#import "ZGradientLayer.h"


@implementation ZGradientLayer

- (id) init
	{
	self = [super init];
	if (!self) return self;

	NSArray*colors =
		@[
#if 1
		(id) [UIColor colorWithWhite:1.0 alpha:0.07].CGColor,
		(id) [UIColor colorWithWhite:1.0 alpha:0.03].CGColor,
		(id) [UIColor colorWithWhite:0.0 alpha:0.05].CGColor,
		(id) [UIColor colorWithWhite:0.0 alpha:0.09].CGColor,
#else
		(id) [[UIColor redColor] colorWithAlphaComponent:1.0].CGColor,
		(id) [[UIColor redColor] colorWithAlphaComponent:0.1].CGColor,
		(id) [[UIColor blueColor] colorWithAlphaComponent:0.1].CGColor,
		(id) [[UIColor blueColor] colorWithAlphaComponent:1.0].CGColor,
#endif
		];
	NSArray*locations = @[ @0.0, @0.33, @0.66, @1.0 ];

	self.startPoint = CGPointMake(0.20, 0.0);
	self.endPoint = CGPointMake(0.80, 1.0);
	self.locations = locations;
	self.colors = colors;

	return self;
	}

- (void) layoutSublayers
	{
	[super layoutSublayers];
	self.frame = self.superlayer.bounds;
	[self.superlayer insertSublayer:self atIndex:0];
	}

@end

