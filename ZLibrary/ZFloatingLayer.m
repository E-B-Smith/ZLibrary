//
//  ZFloatingLayer.m
//  ZLibrary
//
//  Created by Edward Smith on 7/22/15.
//  Copyright (c) 2015 Edward Smith. All rights reserved.
//


#import "ZFloatingLayer.h"
#import "CALayer+ZLibrary.h"


@implementation ZFloatingLayer

- (CALayer*) hitTest:(CGPoint)p
	{
	return nil;
	}

- (BOOL) containsPoint:(CGPoint)p
	{
	return NO;
	}

@end
