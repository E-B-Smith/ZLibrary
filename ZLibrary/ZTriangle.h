


//-----------------------------------------------------------------------------------------------
//
//																					  ZTriangle.h
//																					 ZLibrary-Mac
//
//																 Some math and geometry functions
//																		 Edward Smith, March 2009
//
//								 -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------
//
//												ZTriangle.h
//
//-----------------------------------------------------------------------------------------------


#ifdef __cplusplus
extern "C" {
#endif


typedef struct 
	{
	CGPoint a,b,c;
	}
	ZTriangle;
	
static inline ZTriangle ZTriangleMake(CGPoint a1, CGPoint b1, CGPoint c1)
	{
	ZTriangle t;
	t.a = a1;
	t.b = b1;
	t.c = c1;
	return t;
	}
	
static inline void ZPointArrayFromTriangle(CGPoint* p, ZTriangle t)
	{
	p[0] = t.a;
	p[1] = t.b;
	p[2] = t.c;
	}
	
static inline ZTriangle ZTriangleOffset(ZTriangle t, CGFloat dx, CGFloat dy)
	{
	t.a.x += dx;
	t.b.x += dx;
	t.c.x += dx;
	t.a.y += dy;
	t.b.y += dy;
	t.c.y += dy;
	return t;
	}
	
extern BOOL			ZTriangleContainsPoint(ZTriangle t, CGPoint p);
//extern CGFloat	ZTriangleIntersectionArea(ZTriangle t1, ZTriangle t2);
extern CGFloat		ZTriangleRectIntersectionArea(ZTriangle t, CGRect r);
extern void			ZSortPointsByX(CGPoint* points, int Count);
extern void			ZSortPointsByY(CGPoint* points, int Count);
extern int			ZFindConvexHull(CGPoint* points, int count);
extern NSString*	NSStringFromZTriangle(ZTriangle t);

#ifdef __cplusplus
}
#endif
