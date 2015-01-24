//
//  UIBezierPath+ZLibrary.h
//  ZLibrary
//
//  Created by Edward Smith on 12/27/14.
//  Copyright (c) 2014 Edward Smith. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIBezierPath (ZLibrary)
+ (UIBezierPath*) bezierPathWithArrowInRect:(CGRect)rect;
+ (UIBezierPath*) bezierPathWithLineFrom:(CGPoint)p to:(CGPoint)q;
@end
