

//-----------------------------------------------------------------------------------------------
//
//																				ZTriangle.Test.mm
//																					 ZLibrary-Mac
//
//																 Some math and geometry functions
//																		 Edward Smith, March 2009
//
//								 -©- Copyright © 1996-2010 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <XCTest/XCTest.h>
#import "ZTriangle.h"
#import "ZMath.h"


@interface ZTriangleTest : XCTestCase
@end


@implementation ZTriangleTest

#define FileAndLine			__FILE__ << "(" << __LINE__ << "): "
#define OutputPoint(p)		"(" << p.x << ", " << p.y << ")"
#define OutputTriangle(t)	"[" << OutputPoint(t.a) << ", " << OutputPoint(t.b) << ", " << OutputPoint(t.c) << "]"

#define TestPointNotInTriangle(p, t) \
	XCTAssertFalse(ZTriangleContainsPoint(t, p), @"Point %@ should *not* be in triangle %@.", NSStringFromCGPoint(p), NSStringFromZTriangle(t))

#define TestPointInTriangle(p, t) \
	XCTAssertTrue(ZTriangleContainsPoint(t, p), @"Point %@ should be in triangle %@.", NSStringFromCGPoint(p), NSStringFromZTriangle(t))

#define TestTriangleArea \
	{ \
	area = zTriangleIntersectionArea(t, u); \
	if (0 != zCompareCGFloat(area, areaCheck)) \
		{ \
		Passed = false; \
		out << FileAndLine << "Expected triangle intersection area of " << areaCheck << " but got " << area << ".\n"; \
		} \
	}

BOOL TestPointArraySort(CGPoint* a, int count)
	{
	for (int i = 1; i < count; ++i)
		{
		if (a[i-1].x < a[i].x)
			{}
		else
		if (ZCGFloatCompare(a[i-1].x, a[i].x) == 0)
			{
			if (a[i-1].y <= a[i].y)
				{}
			else
				return false;
			}
		else
			return false;
		}
	return true;
	}

/*	
void TestConvexHullProc(char* File, int Line, std::ostream& out, bool& Passed, CGPoint* a1, CGPoint* a2, int expectedCount, int count)
	{
	if (count != expectedCount)
		{
		Passed = false;
		out << File << "(" << Line << "): " <<  "Wrong count returned on convex hull test: " << count << ", expected: " << expectedCount << ".\n";
		return;
		}

	//	Find where the hull starts -- 
	
	int start;
	for (start = 0; start < count; ++start)
		{
		if (zPointsAreEqual(a1[0], a2[start]))
			break;
		}
	if (start >= count)
		{
		Passed = false;
		out << File << "(" << Line << "): " << "Convex hull returned wrong points.\n";
		return;
		}
		
	int i,ii = start;
	for (i = 0; i < count; ++i)
		{
		if (!zPointsAreEqual(a1[i], a2[ii]))
			{
			Passed = false;
			out << File << "(" << Line << "): " << "Convex hull returned wrong points.\n";
			return;
			}
		if (++ii >= count)
			ii = 0;
		}
	}
	
#define TestConvexHull(a1, a2, expectedCount, count) \
	TestConvexHullProc(__FILE__, __LINE__, out, Passed, a1, a2, expectedCount, count)
*/

	
- (void) testZTriangle
	{
//	bool Passed = true;
//	int i;
//	ZTriangle u;
	
	ZTriangle t;
	t = ZTriangleMake(CGPointMake(0.0, 0.0), CGPointMake(2.0, 0.0), CGPointMake(1.0, 2.0));
	XCTAssertTrue(
		CGPointEqualToPoint(t.a, CGPointMake(0.0, 0.0)) && 
		CGPointEqualToPoint(t.b, CGPointMake(2.0, 0.0)) && 
		CGPointEqualToPoint(t.c, CGPointMake(1.0, 2.0)),
		"ZTriangleMake failed.");


	//	Check point *not* in triangle -- 

	CGPoint p;	
	p = CGPointMake(0.0, 1.0);
	TestPointNotInTriangle(p, t);
	
	p = CGPointMake(1.0, -0.01);
	TestPointNotInTriangle(p, t);

	p = CGPointMake(2.0, 1.0);
	TestPointNotInTriangle(p, t);

	p = CGPointMake(1.0, 2.01);
	TestPointNotInTriangle(p, t);


	//	Check point in triangle -- 
	
	p = CGPointMake(1.0, 1.0);
	TestPointInTriangle(p, t);

	p = CGPointMake(0.01, 0.01);
	TestPointInTriangle(p, t);

	p = CGPointMake(0.0, 0.0);
	TestPointInTriangle(p, t);

	
	//	Sort points test -- 

	CGPoint pa1[3] = {{3.0, 1.0}, {2.0, 2.0}, {1.0, 3.0}};
	ZSortPointsByX(pa1, 3);
	XCTAssertTrue(TestPointArraySort(pa1, 3), "Sort points failed.");
	
	CGPoint pa2[3] = {{0.0, 3.0}, {0.0, 1.0}, {0.0, 2.0}};
	ZSortPointsByX(pa2, 3);
	XCTAssertTrue(TestPointArraySort(pa2, 3), "Sort points failed.");


/*
	//	Test convex hull -- 

	CGPoint pc1a[] = {{0.0, 0.0}, {1.0, 2.0}, {0.0, 2.0}};
	CGPoint pc1b[] = {{1.0, 2.0}, {0.0, 2.0}, {0.0, 0.0}};
	i = ZFindConvexHull(pc1a, 3);
	TestConvexHull(pc1a, pc1b, 3, i);
	
	CGPoint pc2a[] = {{0.25, 0.5}, {0.5, 0.0}, {0.5, 1.0}, {1.5, 0.0}, {1.5, 1.0}, {1.75, 0.5}};
	CGPoint pc2b[] = {{1.75, 0.5}, {1.5, 1.0}, {0.5, 1.0}, {0.25, 0.5}, {0.5, 0.0}, {1.5, 0.0}};
	i = zFindConvexHull(pc2a, 6);
	TestConvexHull(pc2a, pc2b, 6, i);
	
	CGPoint pc3a[] = {{0.25, 0.5}, {0.5, 0.0}, {0.5, 1.0}, {1.5, 0.0}, {1.5, 1.0}, {1.75, 0.5}, 
				      {1.0, 2.0}, {1.0, -1.0}, {2.0, 1.0}, {2.0, 0.0}, {0.0, 1.0}, {0.0, 0.0}};
	CGPoint pc3b[] = {{2.0, 1.0}, {1.0, 2.0}, {0.0, 1.0}, {0.0, 0.0}, {1.0, -1.0}, {2.0, 0.0}};
	i = zFindConvexHull(pc3a, zCountOf(pc3a));
	TestConvexHull(pc3a, pc3b, 6, i);

	//	Hull with lots of duplicate points -- 
	
	CGPoint pc4a[] = {{0.25, 0.5}, {0.5, 0.0}, {0.5, 1.0}, {1.5, 0.0}, {1.5, 1.0}, {1.75, 0.5}, 
				      {1.0, 2.0}, {1.0, -1.0}, {2.0, 1.0}, {2.0, 0.0}, {0.0, 1.0}, {0.0, 0.0},
					  {0.25, 0.5}, {0.5, 0.0}, {0.5, 1.0}, {1.5, 0.0}, {1.5, 1.0}, {1.75, 0.5}, 
				      {1.0, 2.0}, {1.0, -1.0}, {2.0, 1.0}, {2.0, 0.0}, {0.0, 1.0}, {0.0, 0.0}};					  
	CGPoint pc4b[] = {{2.0, 1.0}, {1.0, 2.0}, {0.0, 1.0}, {0.0, 0.0}, {1.0, -1.0}, {2.0, 0.0}};
	i = zFindConvexHull(pc4a, zCountOf(pc4a));
	TestConvexHull(pc4a, pc4b, 6, i);

	
	//	Hull with four points -- 
	
	CGPoint pc5a[] = {{918.0, 252.0}, {921.0, 574.0}, {931.0, 579.0}, {935.0, 260.0}};
	CGPoint pc5b[] = {{935.0, 260.0}, {931.0, 579.0}, {921.0, 574.0}, {918.0, 252.0}};
	i = zFindConvexHull(pc5a, zCountOf(pc5a));
	TestConvexHull(pc5a, pc5b, 4, i);
	
	//	Hull with small float values -- 
	
	CGPoint pc6a[] = {{254.089310, 209.735794}, {254.089355, 209.732605}, {254.089218, 209.735748}, {254.089188, 209.732529}};
	CGPoint pc6b[] = {{254.089355, 209.732605}, {254.089218, 209.735748}, {254.089188, 209.732529}};
	i = zFindConvexHull(pc6a, zCountOf(pc6a));
	TestConvexHull(pc6a, pc6b, zCountOf(pc6b), i);
	
	CGPoint pc7a[] = {{316.209625, 158.446777}, {316.209625, 158.446976}, {320.123456, 158.454546}, {320.123457, 159.666666}};
	CGPoint pc7b[] = {{320.123457, 159.666666}, {316.209625, 158.446976}, {316.209625, 158.446777}, {320.123456, 158.454546}};
	i = zFindConvexHull(pc7a, zCountOf(pc7a));
	TestConvexHull(pc7a, pc7b, 4, i);

	CGPoint pc8a[] = {{316.209625, 158.446777}, {316.209625, 158.446793}, {316.209625, 158.44696}, {316.209625, 158.446976}};
	CGPoint pc8b[] = {{316.209625, 158.446777}, {316.209625, 158.44696}};
	i = zFindConvexHull(pc8a, zCountOf(pc8a));
	TestConvexHull(pc8a, pc8b, 2, i);
	
	CGPoint pc9a[] = {{185.634567, 22.2636719}, {185.634567, 22.2636795}, {185.634567, 22.2636929}, {185.634567, 25.2636642}, {319.983551, 157.612656}, {319.984863, 157.613953}};
	CGPoint pc9b[] = {{319.984863, 157.613953}, {185.634567, 25.2636642}, {185.634567, 22.2636719}};
	i = zFindConvexHull(pc9a, zCountOf(pc9a));
	TestConvexHull(pc9a, pc9b, 3, i);

	CGPoint pcAa[] = {{175.984924, 157.613968}, {175.98494, 157.613968}, {175.984955, 157.613968}, {175.98497, 157.613968}};
	CGPoint pcAb[] = {{175.984924, 157.613968}};
	i = zFindConvexHull(pcAa, zCountOf(pcAa));
	TestConvexHull(pcAa, pcAb, zCountOf(pcAb), i);

	CGPoint pcBa[] = {{4940.0, 3892.0}, {4894.0, 3937.0}, {4924.0, 3907.0}, {4909.0, 3922.0}};
	CGPoint pcBb[] = {{4940.0, 3892.0}, {4894.0, 3937.0}, {4924.0, 3907.0}};
	i = zFindConvexHull(pcBa, zCountOf(pcBa));
	TestConvexHull(pcBa, pcBb, 3, i);

	CGPoint pcCa[] = {{17598.4940, 15761.3892}, {17598.4894, 15761.3937}, {17598.4924, 15761.3907}, {17598.4909, 15761.3922}};
	CGPoint pcCb[] = {{17598.4940, 15761.3892}, {17598.4894, 15761.3937}, {17598.4909, 15761.3922}, {17598.4924, 15761.3907}};
	i = zFindConvexHull(pcCa, zCountOf(pcCa));
	TestConvexHull(pcCa, pcCb, zCountOf(pcCb), i);

	CGPoint pcDa[] = {{1759.84940, 1576.13892}, {1759.84894, 1576.13937}, {1759.84924, 1576.13907}, {1759.84909, 1576.13922}};
	CGPoint pcDb[] = {{1759.84940, 1576.13892}, {1759.84894, 1576.13937}, {1759.84909, 1576.13922}};
	i = zFindConvexHull(pcDa, zCountOf(pcDa));
	TestConvexHull(pcDa, pcDb, zCountOf(pcDb), i);

	CGPoint pcFa[] = {{175.984940, 157.613892}, {175.984894, 157.613937}, {175.984924, 157.613907}, {175.984909, 157.613922}};
	CGPoint pcFb[] = {{175.984940, 157.613892}};
	i = zFindConvexHull(pcFa, zCountOf(pcFa));
	TestConvexHull(pcFa, pcFb, zCountOf(pcFb), i);

	//	Test intersection area -- 
	
	double area, areaCheck;

	areaCheck = 0.5;
	u = zMakeTriangle(CGPointMake(0.0, -1.0), CGPointMake(2.0, -1.0), CGPointMake(1.0, 1.0));
	TestTriangleArea;
	
	areaCheck = 2.0;
	u = zMakeTriangle(CGPointMake(0.0, 0.0), CGPointMake(2.0, 0.0), CGPointMake(1.0, 2.0));
	TestTriangleArea;

	areaCheck = 1.25;
	u = zMakeTriangle(CGPointMake(0.0, 1.0), CGPointMake(2.0, 1.0), CGPointMake(1.0, -1.0));
	TestTriangleArea;

	areaCheck = DBL_MIN;	//	Triangle with single point in common -- 
	u = zMakeTriangle(CGPointMake(2.0, 0.0), CGPointMake(4.0, 0.0), CGPointMake(3.0, 1.0));
	TestTriangleArea;
	
	areaCheck = DBL_MIN;	//	Triangle with line in common -- 
	u = zMakeTriangle(CGPointMake(2.0, 0.0), CGPointMake(1.0, 2.0), CGPointMake(3.0, 1.0));
	TestTriangleArea;
	
	
	//	Rectangle intersection -- 
	
	NSRect r = NSMakeRect(-1.0, 0.0, 4.0, 5.0);
	area = zTriangleRectIntersectionArea(t, r);
	if (area != 2.0)
		{
		Passed = false;
		out << "zTriangleRectIntersectionArea failed.\n";
		}
*/	
	}

@end

