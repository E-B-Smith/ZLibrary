


//-----------------------------------------------------------------------------------------------
//
//																				zTriangle.Test.mm
//																					 zLibrary-Mac
//
//																 Some math and geometry functions
//																		 Edward Smith, March 2009
//
//								 -©- Copyright © 1996-2010 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZTriangle.h"
#import "ZMath.h"
#import <iostream>


#define FileAndLine			__FILE__ << "(" << __LINE__ << "): "
#define OutputPoint(p)		"(" << p.x << ", " << p.y << ")"
#define OutputTriangle(t)	"[" << OutputPoint(t.a) << ", " << OutputPoint(t.b) << ", " << OutputPoint(t.c) << "]"

#define TestPointNotInTriangle(p, t) \
	{ \
	if (zPointIsInTriangle(p, t)) \
		{ \
		Passed = false; \
		out << FileAndLine << "Point " << OutputPoint(p) << " should *not* be in triangle " << OutputTriangle(t) << ".\n"; \
		} \
	}

#define TestPointInTriangle(p, t) \
	{ \
	if (!zPointIsInTriangle(p, t)) \
		{ \
		Passed = false; \
		out << FileAndLine << "Point " << OutputPoint(p) << " should be in triangle " << OutputTriangle(t) << ".\n"; \
		} \
	}

#define TestTriangleArea \
	{ \
	area = zTriangleIntersectionArea(t, u); \
	if (0 != zCompareCGFloat(area, areaCheck)) \
		{ \
		Passed = false; \
		out << FileAndLine << "Expected triangle intersection area of " << areaCheck << " but got " << area << ".\n"; \
		} \
	}

BOOL TestPointArraySort(NSPoint* a, int count)
	{
	for (int i = 1; i < count; ++i)
		{
		if (a[i-1].x < a[i].x)
			{}
		else
		if (zCompareCGFloat(a[i-1].x, a[i].x) == 0)
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

	
void TestConvexHullProc(char* File, int Line, std::ostream& out, bool& Passed, NSPoint* a1, NSPoint* a2, int expectedCount, int count)
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
	
	

bool Test_zTriangle(std::ostream& out)
	{
	bool Passed = true;
	
	int i;
	NSPoint p;
	zTriangle t,u;
	
	t = zMakeTriangle(NSMakePoint(0.0, 0.0), NSMakePoint(2.0, 0.0), NSMakePoint(1.0, 2.0));
	if (NSEqualPoints(t.a, NSMakePoint(0.0, 0.0)) && 
		NSEqualPoints(t.b, NSMakePoint(2.0, 0.0)) && 
		NSEqualPoints(t.c, NSMakePoint(1.0, 2.0)) )
		{}
	else
		{
		out << "zMakeTriangle failed.\n";
		Passed = false;
		}


	//	Check point *not* in triangle -- 
	
	p = NSMakePoint(0.0, 1.0);
	TestPointNotInTriangle(p, t);
	
	p = NSMakePoint(1.0, -0.01);
	TestPointNotInTriangle(p, t);

	p = NSMakePoint(2.0, 1.0);
	TestPointNotInTriangle(p, t);

	p = NSMakePoint(1.0, 2.01);
	TestPointNotInTriangle(p, t);


	//	Check point in triangle -- 
	
	p = NSMakePoint(1.0, 1.0);
	TestPointInTriangle(p, t);

	p = NSMakePoint(0.01, 0.01);
	TestPointInTriangle(p, t);

	p = NSMakePoint(0.0, 0.0);
	TestPointInTriangle(p, t);

	
	//	Sort points test -- 

	NSPoint pa1[3] = {{3.0, 1.0}, {2.0, 2.0}, {1.0, 3.0}};
	zSortPointsByX(pa1, 3);
	if (!TestPointArraySort(pa1, 3))
		{
		Passed = false;
		out << FileAndLine << "Sort points failed.\n";
		}
	
	NSPoint pa2[3] = {{0.0, 3.0}, {0.0, 1.0}, {0.0, 2.0}};
	zSortPointsByX(pa2, 3);
	if (!TestPointArraySort(pa2, 3))
		{
		Passed = false;
		out << FileAndLine << "Sort points failed.\n";
		}


	//	Test convex hull -- 

	NSPoint pc1a[] = {{0.0, 0.0}, {1.0, 2.0}, {0.0, 2.0}};
	NSPoint pc1b[] = {{1.0, 2.0}, {0.0, 2.0}, {0.0, 0.0}};
	i = zFindConvexHull(pc1a, 3);
	TestConvexHull(pc1a, pc1b, 3, i);
	
	NSPoint pc2a[] = {{0.25, 0.5}, {0.5, 0.0}, {0.5, 1.0}, {1.5, 0.0}, {1.5, 1.0}, {1.75, 0.5}};
	NSPoint pc2b[] = {{1.75, 0.5}, {1.5, 1.0}, {0.5, 1.0}, {0.25, 0.5}, {0.5, 0.0}, {1.5, 0.0}};
	i = zFindConvexHull(pc2a, 6);
	TestConvexHull(pc2a, pc2b, 6, i);
	
	NSPoint pc3a[] = {{0.25, 0.5}, {0.5, 0.0}, {0.5, 1.0}, {1.5, 0.0}, {1.5, 1.0}, {1.75, 0.5}, 
				      {1.0, 2.0}, {1.0, -1.0}, {2.0, 1.0}, {2.0, 0.0}, {0.0, 1.0}, {0.0, 0.0}};
	NSPoint pc3b[] = {{2.0, 1.0}, {1.0, 2.0}, {0.0, 1.0}, {0.0, 0.0}, {1.0, -1.0}, {2.0, 0.0}};
	i = zFindConvexHull(pc3a, zCountOf(pc3a));
	TestConvexHull(pc3a, pc3b, 6, i);

	//	Hull with lots of duplicate points -- 
	
	NSPoint pc4a[] = {{0.25, 0.5}, {0.5, 0.0}, {0.5, 1.0}, {1.5, 0.0}, {1.5, 1.0}, {1.75, 0.5}, 
				      {1.0, 2.0}, {1.0, -1.0}, {2.0, 1.0}, {2.0, 0.0}, {0.0, 1.0}, {0.0, 0.0},
					  {0.25, 0.5}, {0.5, 0.0}, {0.5, 1.0}, {1.5, 0.0}, {1.5, 1.0}, {1.75, 0.5}, 
				      {1.0, 2.0}, {1.0, -1.0}, {2.0, 1.0}, {2.0, 0.0}, {0.0, 1.0}, {0.0, 0.0}};					  
	NSPoint pc4b[] = {{2.0, 1.0}, {1.0, 2.0}, {0.0, 1.0}, {0.0, 0.0}, {1.0, -1.0}, {2.0, 0.0}};
	i = zFindConvexHull(pc4a, zCountOf(pc4a));
	TestConvexHull(pc4a, pc4b, 6, i);

	
	//	Hull with four points -- 
	
	NSPoint pc5a[] = {{918.0, 252.0}, {921.0, 574.0}, {931.0, 579.0}, {935.0, 260.0}};
	NSPoint pc5b[] = {{935.0, 260.0}, {931.0, 579.0}, {921.0, 574.0}, {918.0, 252.0}};
	i = zFindConvexHull(pc5a, zCountOf(pc5a));
	TestConvexHull(pc5a, pc5b, 4, i);
	
	//	Hull with small float values -- 
	
	NSPoint pc6a[] = {{254.089310, 209.735794}, {254.089355, 209.732605}, {254.089218, 209.735748}, {254.089188, 209.732529}};
	NSPoint pc6b[] = {{254.089355, 209.732605}, {254.089218, 209.735748}, {254.089188, 209.732529}};
	i = zFindConvexHull(pc6a, zCountOf(pc6a));
	TestConvexHull(pc6a, pc6b, zCountOf(pc6b), i);
	
	NSPoint pc7a[] = {{316.209625, 158.446777}, {316.209625, 158.446976}, {320.123456, 158.454546}, {320.123457, 159.666666}};
	NSPoint pc7b[] = {{320.123457, 159.666666}, {316.209625, 158.446976}, {316.209625, 158.446777}, {320.123456, 158.454546}};
	i = zFindConvexHull(pc7a, zCountOf(pc7a));
	TestConvexHull(pc7a, pc7b, 4, i);

	NSPoint pc8a[] = {{316.209625, 158.446777}, {316.209625, 158.446793}, {316.209625, 158.44696}, {316.209625, 158.446976}};
	NSPoint pc8b[] = {{316.209625, 158.446777}, {316.209625, 158.44696}};
	i = zFindConvexHull(pc8a, zCountOf(pc8a));
	TestConvexHull(pc8a, pc8b, 2, i);
	
	NSPoint pc9a[] = {{185.634567, 22.2636719}, {185.634567, 22.2636795}, {185.634567, 22.2636929}, {185.634567, 25.2636642}, {319.983551, 157.612656}, {319.984863, 157.613953}};
	NSPoint pc9b[] = {{319.984863, 157.613953}, {185.634567, 25.2636642}, {185.634567, 22.2636719}};
	i = zFindConvexHull(pc9a, zCountOf(pc9a));
	TestConvexHull(pc9a, pc9b, 3, i);

	NSPoint pcAa[] = {{175.984924, 157.613968}, {175.98494, 157.613968}, {175.984955, 157.613968}, {175.98497, 157.613968}};
	NSPoint pcAb[] = {{175.984924, 157.613968}};
	i = zFindConvexHull(pcAa, zCountOf(pcAa));
	TestConvexHull(pcAa, pcAb, zCountOf(pcAb), i);

	NSPoint pcBa[] = {{4940.0, 3892.0}, {4894.0, 3937.0}, {4924.0, 3907.0}, {4909.0, 3922.0}};
	NSPoint pcBb[] = {{4940.0, 3892.0}, {4894.0, 3937.0}, {4924.0, 3907.0}};
	i = zFindConvexHull(pcBa, zCountOf(pcBa));
	TestConvexHull(pcBa, pcBb, 3, i);

	NSPoint pcCa[] = {{17598.4940, 15761.3892}, {17598.4894, 15761.3937}, {17598.4924, 15761.3907}, {17598.4909, 15761.3922}};
	NSPoint pcCb[] = {{17598.4940, 15761.3892}, {17598.4894, 15761.3937}, {17598.4909, 15761.3922}, {17598.4924, 15761.3907}};
	i = zFindConvexHull(pcCa, zCountOf(pcCa));
	TestConvexHull(pcCa, pcCb, zCountOf(pcCb), i);

	NSPoint pcDa[] = {{1759.84940, 1576.13892}, {1759.84894, 1576.13937}, {1759.84924, 1576.13907}, {1759.84909, 1576.13922}};
	NSPoint pcDb[] = {{1759.84940, 1576.13892}, {1759.84894, 1576.13937}, {1759.84909, 1576.13922}};
	i = zFindConvexHull(pcDa, zCountOf(pcDa));
	TestConvexHull(pcDa, pcDb, zCountOf(pcDb), i);

	NSPoint pcFa[] = {{175.984940, 157.613892}, {175.984894, 157.613937}, {175.984924, 157.613907}, {175.984909, 157.613922}};
	NSPoint pcFb[] = {{175.984940, 157.613892}};
	i = zFindConvexHull(pcFa, zCountOf(pcFa));
	TestConvexHull(pcFa, pcFb, zCountOf(pcFb), i);

	//	Test intersection area -- 
	
	double area, areaCheck;

	areaCheck = 0.5;
	u = zMakeTriangle(NSMakePoint(0.0, -1.0), NSMakePoint(2.0, -1.0), NSMakePoint(1.0, 1.0));
	TestTriangleArea;
	
	areaCheck = 2.0;
	u = zMakeTriangle(NSMakePoint(0.0, 0.0), NSMakePoint(2.0, 0.0), NSMakePoint(1.0, 2.0));
	TestTriangleArea;

	areaCheck = 1.25;
	u = zMakeTriangle(NSMakePoint(0.0, 1.0), NSMakePoint(2.0, 1.0), NSMakePoint(1.0, -1.0));
	TestTriangleArea;

	areaCheck = DBL_MIN;	//	Triangle with single point in common -- 
	u = zMakeTriangle(NSMakePoint(2.0, 0.0), NSMakePoint(4.0, 0.0), NSMakePoint(3.0, 1.0));
	TestTriangleArea;
	
	areaCheck = DBL_MIN;	//	Triangle with line in common -- 
	u = zMakeTriangle(NSMakePoint(2.0, 0.0), NSMakePoint(1.0, 2.0), NSMakePoint(3.0, 1.0));
	TestTriangleArea;
	
	
	//	Rectangle intersection -- 
	
	NSRect r = NSMakeRect(-1.0, 0.0, 4.0, 5.0);
	area = zTriangleRectIntersectionArea(t, r);
	if (area != 2.0)
		{
		Passed = false;
		out << "zTriangleRectIntersectionArea failed.\n";
		}
	
	return Passed;
	}
	
