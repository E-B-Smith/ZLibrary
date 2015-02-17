//
//  UIBezierPath+ZLibrary.m
//  ZLibrary
//
//  Created by Edward Smith on 12/27/14.
//  Copyright (c) 2014 Edward Smith. All rights reserved.
//


#import "UIBezierPath+ZLibrary.h"


@implementation UIBezierPath (ZLibrary)

+ (UIBezierPath*) bezierPathWithArrowInRect:(CGRect)rect
	{
	CGFloat middleY = rect.origin.y + rect.size.height / 2.0;
	UIBezierPath *path = [UIBezierPath bezierPath];

	[path moveToPoint:CGPointMake(rect.origin.x, middleY)];
	[path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width, middleY)];

	CGFloat pointX = rect.origin.x + rect.size.width - rint(rect.size.width * 0.2);
	[path moveToPoint:CGPointMake(pointX, rect.origin.y)];
	[path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width, middleY)];
	[path addLineToPoint:CGPointMake(pointX, rect.origin.y+rect.size.height)];

	return path;
	}

+ (UIBezierPath*) bezierPathWithLineFromPoint:(CGPoint)p toPoint:(CGPoint)q
	{
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:p];
	[path addLineToPoint:q];
	return path;
	}

@end
