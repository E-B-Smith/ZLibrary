



//-----------------------------------------------------------------------------------------------
//
//                                                                                        ZLine.h
//                                                                                   ZLibrary-Mac
//
//                                                               Some math and geometry functions
//                                                                       Edward Smith, March 2009
//
//                               -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------
//
//                                              ZLine.h
//
//-----------------------------------------------------------------------------------------------


#ifdef __cplusplus
extern "C" {
#endif


typedef struct
    {
    CGPoint a,b;
    }
    ZLine;


static inline ZLine ZLineMake(CGPoint a1, CGPoint b1)
    {
    ZLine l;
    l.a = a1;
    l.b = b1;
    return l;
    }


extern ZLine const ZLineZero;
extern ZLine ZLineIntersectingArcWithCenter(CGPoint center, CGFloat centerAngle, CGFloat radius);
extern NSString* NSStringFromZLine(ZLine line);


//-----------------------------------------------------------------------------------------------
//
//                                                                              ZLineIntersection
//
//-----------------------------------------------------------------------------------------------


//  Use these functions to check for ZLineIntersection special values --

static inline bool ZLineIntersectionIsParallel(CGPoint p)           { return (!isnan(p.x) && isnan(p.y)); }
static inline bool ZLineIntersectionIsCoincidental(CGPoint p)       { return (isnan(p.x) && !isnan(p.y)); }
static inline bool ZLineIntersectionIsNone(CGPoint p)               { return (isnan(p.x) && isnan(p.y)); }
static inline bool ZLineIntersectionDoesIntersect(CGPoint p)        { return (!isnan(p.x) && !isnan(p.y)); }

extern CGPoint ZLineIntersectionPoint(ZLine l1, ZLine l2);


//-----------------------------------------------------------------------------------------------
//                                                                            Other Intersections
//-----------------------------------------------------------------------------------------------


extern BOOL ZLineIntersectsRect(ZLine line, CGRect rect);
extern BOOL ZLineIntersectsLine(ZLine line1, ZLine line2);


#ifdef __cplusplus
}
#endif


