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

+ (UIBezierPath*) bezierPathWithArcCenter:(CGPoint)center
								   radius:(CGFloat)radius
							   startAngle:(CGFloat)startAngle
							     endAngle:(CGFloat)endAngle
								   indent:(CGFloat)indent;
	{	
	//	Draw the left indent -- 
		
	CGPoint c1;
	CGFloat rx1 = startAngle + M_PI/2.0;
	c1.x = indent * cos(rx1) + center.x;
	c1.y = indent * sin(rx1) + center.y;
	
	CGPoint li;
	CGFloat lr1 = startAngle;	
	li.x = radius * cos(lr1) + c1.x;
	li.y = radius * sin(lr1) + c1.y;

	//	Draw the right line -- 

	CGPoint rl1;
	CGFloat rr1 = endAngle;
	rl1.x = radius * cos(rr1) + center.x;
	rl1.y = radius * sin(rr1) + center.y;

	//	Draw the right indent -- 
	
	rx1 = rr1 - M_PI/2.0;
	c1.x = indent * cos(rx1) + center.x;
	c1.y = indent * sin(rx1) + center.y;
	
	CGPoint ri;
	ri.x = radius * cos(rr1) + c1.x;
	ri.y = radius * sin(rr1) + c1.y;
	
	//	Make the arc -- 

	lr1 = atan2(li.y - center.y, li.x - center.x);
	rr1 = atan2(ri.y - center.y, ri.x - center.x);
	
	UIBezierPath* arc =
		[UIBezierPath bezierPathWithArcCenter:center
									   radius:radius
								   startAngle:lr1
									 endAngle:rr1
									clockwise:YES];
	return arc;
	}

+ (UIBezierPath*) bezierPathForQuoteWithRect:(CGRect)rect pointyBitHeight:(CGFloat)pointyHeight
	{
	void (^ pathAddLeg) (UIBezierPath* path, CGPoint point, CGPoint indent, CGPoint radii) = 
		^ void (UIBezierPath* path, CGPoint point, CGPoint indent, CGPoint radii)
			{
			[path addLineToPoint:CGPointMake(point.x - indent.x, point.y - indent.y)];
			[path addQuadCurveToPoint:CGPointMake(point.x + radii.x, point.y + radii.y) controlPoint:point];
			};

	CGFloat radius = 5.0;
	UIBezierPath * path = [UIBezierPath bezierPath];
	
	[path moveToPoint:CGPointMake(rect.origin.x + radius, rect.origin.y)];
	pathAddLeg(path,
		CGPointMake(rect.origin.x + rect.size.width, rect.origin.y),
		CGPointMake(radius, 0.0), CGPointMake(0.0, radius));
	pathAddLeg(path,
		CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height),
		CGPointMake(0.0, radius), CGPointMake(-radius, 0.0));

	//	Add the pointy bit -- 
	
	[path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width - 55.0, rect.origin.y + rect.size.height)];
	[path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width - 65.0, rect.origin.y + rect.size.height + pointyHeight)];
	[path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width - 75.0, rect.origin.y + rect.size.height)];

	//	Finish the rect -- 
	
	pathAddLeg(path,
		CGPointMake(rect.origin.x, rect.origin.y + rect.size.height),
		CGPointMake(-radius, 0.0), CGPointMake(0.0, -radius));
	pathAddLeg(path,
		CGPointMake(rect.origin.x, rect.origin.y),
		CGPointMake(0.0, -radius), CGPointMake(radius, 0.0));
	return path;
	}

@end
