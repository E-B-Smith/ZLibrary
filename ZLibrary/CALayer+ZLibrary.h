//
//  CALayer+ZLibrary.h
//  Search
//
//  Created by Edward Smith on 12/10/13.
//  Copyright (c) 2013 Relcy, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>


@interface CALayer (ZLibrary)

- (CALayer*) findSublayerUsingPredicateBlock:(BOOL (^) (CALayer* sublayer))predicateBlock;
- (CALayer*) findSublayerNamed:(NSString*)name;

- (void) addLineFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2 color:(CGColorRef)color;
- (void) removeLine;

@end
