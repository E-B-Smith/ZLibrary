//
//  ZDrawing.m
//  ZLibrary
//
//  Created by Edward Smith on 4/12/14.
//  Copyright (c) 2014 Edward Smith, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


//	Start & end points are 0.0 to 1.0 relative to the passed rect -- 

extern void ZDrawLinearGradientRect(
		CGContextRef context, CGRect rect,
		CGColorRef startColor, CGPoint startPoint,
		CGColorRef endColor, CGPoint endPoint);


extern void ZDrawGradientFrameRect(
		CGContextRef context, 
		CGRect outerRect, CGColorRef outerColor, 
		CGFloat gradientBias, 
		CGRect innerRect, CGColorRef innerColor);
