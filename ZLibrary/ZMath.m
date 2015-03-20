


//-----------------------------------------------------------------------------------------------
//
//                                                                                        ZMath.m
//                                                                                   ZLibrary-Mac
//
//                                                               Some math and geometry functions
//                                                                       Edward Smith, March 2008
//
//                               -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------



#import "ZMath.h"



CGFloat ZRectIntersectionArea(CGRect r1, CGRect r2)
    {
    CGRect r = CGRectIntersection(r1, r2);
    return (r.size.height * r.size.width);
    }

