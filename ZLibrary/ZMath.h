


//-----------------------------------------------------------------------------------------------
//
//                                                                                        ZMath.h
//                                                                                   ZLibrary-Mac
//
//                                                               Some math and geometry functions
//                                                                       Edward Smith, March 2008
//
//                               -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------
//
//                                              ZMath.h
//
//-----------------------------------------------------------------------------------------------



//#import <Cocoa/Cocoa.h>



#ifdef __cplusplus
extern "C" {
#endif


static inline CGFloat ZRadiansFromDegrees(CGFloat d)
    {
    return ((M_PI*d)/180.0);
    }


static inline CGFloat ZDegreesFromRadians(CGFloat r)
    {
    return ((r/M_PI)*180.0);
    }


extern CGFloat ZRectIntersectionArea(CGRect r1, CGRect r2);




//-----------------------------------------------------------------------------------------------
//
//                                                                                   ZPointIsLeft
//
//  Funtion ZPointIsLeft tests if a point is to the left of, on, or right of an infinite line.
//
//  Returns:
//      > 0     Point is left of the line.
//     == 0     Point is on the line.
//      < 0     Point is right of the line,
//
//      Note that the line used as input to ZPointIsLeft a vector direction:
//
//          ZPointIsLeft(L1, L2, p)
//
//      returns the opposite of:
//
//          ZPointIsLeft(L2, L1, p)
//
//    See: the January 2001 Algorithm on Area of Triangles
//
//-----------------------------------------------------------------------------------------------


static inline CGFloat ZPointIsLeft(CGPoint L1, CGPoint L2, CGPoint p)
    {
    CGFloat r = (L2.x - L1.x)*(p.y - L1.y) - (p.x - L1.x)*(L2.y - L1.y);
    return r;
    }


//-----------------------------------------------------------------------------------------------
//                                                                  Floating Point Point Is Equal
//-----------------------------------------------------------------------------------------------


static inline int ZCGFloatCompare(CGFloat a, CGFloat b)
    {
    CGFloat c = (a - b);
    if (c == 0.0)
        return 0;
    else
    if (c > 0.0)
        return 1;
    else
    if (c < 0.0)
        return -1;
    else
        return 0;
    }
	
static inline bool ZCGPointsAreEqual(CGPoint a, CGPoint b)
    {
    return
        (ZCGFloatCompare(a.x, b.x) == 0 &&
         ZCGFloatCompare(a.y, b.y) == 0) ? YES : NO;
    }


#ifdef __cplusplus
}
#endif
