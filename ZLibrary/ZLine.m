


//-----------------------------------------------------------------------------------------------
//
//                                                                                        ZLine.m
//                                                                                   ZLibrary-Mac
//
//                                                               Some math and geometry functions
//                                                                       Edward Smith, March 2009
//
//                               -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------



#import "ZLine.h"
#import "ZMath.h"
#import "ZDebug.h"



ZLine const ZLineZero = { {0.0, 0.0}, {0.0, 0.0} };

NSString* NSStringFromZLine(ZLine l)
	{
	return [NSString stringWithFormat:@"{ %@, %@ }",
				NSStringFromCGPoint(l.a),
				NSStringFromCGPoint(l.b)];
	}


ZLine ZLineIntersectingArcWithCenter(CGPoint center, CGFloat centerAngle, CGFloat radius)
    {
	ZDebugAssert(NO);
	return ZLineZero;
    }


BOOL ZLineIntersectsRect(ZLine line, CGRect rect)
    {
    if (CGRectContainsPoint(rect, line.a) ||
        CGRectContainsPoint(rect, line.b))
        return YES;

    //  Check for intersections.  Need three sides only --

    CGPoint r1 = rect.origin;
    CGPoint r2 = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);

    if (ZLineIntersectsLine(line, ZLineMake(r1, r2)))
        return YES;

    CGPoint r3 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);

    if (ZLineIntersectsLine(line, ZLineMake(r2, r3)))
        return YES;

    CGPoint r4 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);

    if (ZLineIntersectsLine(line, ZLineMake(r3, r4)))
        return YES;

    return NO;
    }


//CGPoint ZLineIntersectionPoint(CGPoint p1/*fromPoint1*/, CGPoint p2/*toPoint1*/, CGPoint p3/*fromPoint2*/, CGPoint p4/*toPoint2*/)
CGPoint ZLineIntersectionPoint(ZLine line1, ZLine line2)
    {
    #define ZLineIntersectionParallelV      CGPointMake(0, nan("i"))
    #define ZLineIntersectionCoincidentalV  CGPointMake(nan("i"), 0)
    #define ZLineIntersectionNoneV          CGPointMake(nan("i"), nan("i"))
	
	CGPoint p1 = line1.a;
	CGPoint p2 = line1.b;
	CGPoint p3 = line2.a;
	CGPoint p4 = line2.b;

    CGFloat denom = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y);
    CGFloat numA  = (p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x);
    CGFloat numB  = (p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x);

    if (ZCGFloatCompare(denom, 0.0) == 0)
        {
        if (ZCGFloatCompare(numA, 0.0) == 0 && ZCGFloatCompare(numB, 0.0) == 0)
            return ZLineIntersectionCoincidentalV;  //  Coincidental lines.
        else
            return ZLineIntersectionParallelV;      //  Parallel lines.
        }

    numA /= denom;
    numB /= denom;

    if (numA >= 0.0 && numA <= 1.0 && numB >= 0.0 && numB <= 1.0)
        {
        CGFloat x = (p1.x + numA*(p2.x - p1.x));
        CGFloat y = (p1.y + numA*(p2.y - p1.y));
        return CGPointMake(x, y);
        }

    return ZLineIntersectionNoneV;  //  No intersection
    }


BOOL ZLineIntersectsLine(ZLine l1, ZLine l2)
    {
    CGPoint r = ZLineIntersectionPoint(l1, l2);
    return (ZLineIntersectionIsParallel(r) || ZLineIntersectionIsNone(r)) ? NO : YES;
    }
