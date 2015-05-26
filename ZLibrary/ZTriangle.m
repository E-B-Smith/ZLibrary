


//-----------------------------------------------------------------------------------------------
//
//																					  ZTriangle.m
//																					 ZLibrary-Mac
//
//																 Some math and geometry functions
//																		 Edward Smith, March 2009
//
//								 -©- Copyright © 1996-2010 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZTriangle.h"
#import "ZMath.h"
#import "ZDebug.h"

	
NSString* NSStringFromZTriangle(ZTriangle t)
	{
	return [NSString stringWithFormat:@"{ %@, %@, %@ }",
				NSStringFromCGPoint(t.a),
				NSStringFromCGPoint(t.b),
				NSStringFromCGPoint(t.c)];
	}


int ZSortPointsXProcedure(const void* pv, const void* qv)
	{
	CGPoint*p = (CGPoint*)pv;
	CGPoint*q = (CGPoint*)qv;
	int result = ZCGFloatCompare(p->x, q->x);
	if (result == 0)
		result = ZCGFloatCompare(p->y, q->y);
	return result;
	}
	

void ZSortPointsByX(CGPoint* points, int Count)
	{
	qsort(points, Count, sizeof(CGPoint), ZSortPointsXProcedure);
	}


int ZSortPointsYProcedure(const void* pv, const void* qv)
	{
	CGPoint*p = (CGPoint*)pv;
	CGPoint*q = (CGPoint*)qv;
	int result = ZCGFloatCompare(p->y, q->y);
	if (result == 0)
		result = ZCGFloatCompare(p->x, q->x);
	return result;
	}


void ZSortPointsByY(CGPoint* points, int Count)
	{
	qsort(points, Count, sizeof(CGPoint), ZSortPointsYProcedure);
	}


BOOL ZTriangleContainsPoint(ZTriangle t, CGPoint p)
	{
	//	Uses barycentric triangles to compute if point is in the triangle --
	//
	//	Adapted from Dr. Dobbs Journal:
	//	http://www.ddj.com/184404201;jsessionid=UKAQIOFG1U454QSNDLOSKHSCJUNN2JVN?pgno=1
	
	CGPoint e0,e1,e2;
	CGFloat u, v, d;
	
	e0.x = p.x - t.a.x;
	e0.y = p.y - t.a.y;
	
	e1.x = t.b.x - t.a.x;
	e1.y = t.b.y - t.a.y;
	
	e2.x = t.c.x - t.a.x;
	e2.y = t.c.y - t.a.y;
	
	if (e1.x == 0.0)
		{
		if (e2.x == 0.0) return false;
		u = e0.x / e2.x;
		if (u < 0.0 || u > 1.0) return false;
		if (e1.y == 0.0) return false;
		v = (e0.y - (e2.y * u)) / e1.y;
		if (v < 0.0) return false;
		}
	else
		{
		d = (e2.y * e1.x) - (e2.x * e1.y);
		if (d == 0.0) return false;
		u = ((e0.y * e1.x) - (e0.x * e1.y)) / d;
		if (u < 0.0 || u > 1.0) return false;
		v = (e0.x - (e2.x * u)) / e1.x;
		if (v < 0.0) return false;
		}
	if ((u+v) > 1.0) return false;
	return true;
	}

/*
CGFloat ZTriangleRectIntersectionArea(ZTriangle t, CGRect r)
	{
	ZTriangle t1, t2;
	t1 = ZTriangleMake(
			r.origin, 
			CGPointMake(r.origin.x, r.origin.y + r.size.height), 
			CGPointMake(r.origin.x + r.size.width, r.origin.y + r.size.height)
			);
	t2 = ZTriangleMake(
			r.origin, 
			CGPointMake(r.origin.x + r.size.width, r.origin.y),
			CGPointMake(r.origin.x + r.size.width, r.origin.y + r.size.height)
			);
	return ZTriangleIntersectionArea(t, t1) + ZTriangleIntersectionArea(t, t2);
	}

CGFloat ZTriangleIntersectionArea(ZTriangle tri1, ZTriangle tri2)
	{
	int i,j;
	CGPoint t1[4];
	CGPoint t2[4];
	ZPointArrayFromTriangle(t1, tri1);
	ZPointArrayFromTriangle(t2, tri2);
	t1[3] = t1[0];
	t2[3] = t2[0];
	
	//	Find the control points -- 
	
	CGPoint controlPoint[24], p;
	int controlPointCount = 0;
	
	//	Intersections -- 
	
	for (j = 0; j < 3; ++j)
		{
		for (i = 0; i < 3; ++i)
			{
			p = zLineIntersection(t1[i], t1[i+1], t2[j], t2[j+1]);
			if (zLineIntersectionIntersects(p))
				{
				controlPoint[controlPointCount++] = p;
				}
			else
			if (zLineIntersectionCoincidental(p))
				{
				CGPoint q[4];
				q[0] = t1[i];
				q[1] = t1[i+1];
				q[2] = t2[j];
				q[3] = t2[j+1];
				zSortPointsByX(q, 4);
				controlPoint[controlPointCount++] = q[1];
				controlPoint[controlPointCount++] = q[2];
				}
			}
		}
	
	//	Add all points inside the other triangle --
	
	for (i = 0; i < 3; ++i)
		{
		if (zPointIsInTriangle(t2[i], tri1))
			controlPoint[controlPointCount++] = t2[i];
		if (zPointIsInTriangle(t1[i], tri2))
			controlPoint[controlPointCount++] = t1[i];			
		}
	zDebugAssert(controlPointCount <= 24);
	
	//	Find the convex hull -- 
	
	controlPointCount = zFindConvexHull(controlPoint, controlPointCount);
	
	//	No intersection?
	
	if (controlPointCount == 0)
		{
		return 0.0;
		}
	else
	if (controlPointCount <= 2)
		{
		//	Wha?	Glancing hit?  Technically wrong (a point or line has no area), but return a small number to indicate a hit --
		return DBL_MIN;
		}
		
	//	Compute the area we found -- 

	zDebugAssert(controlPointCount <= 6);

	CGFloat areaSum = 0.0;
	CGFloat areaDif = 0.0;
	controlPoint[controlPointCount] = controlPoint[0];
	for (i = 0; i < controlPointCount; ++i)
		{
		areaSum += controlPoint[i].x * controlPoint[i+1].y;
		areaDif += controlPoint[i].y * controlPoint[i+1].x;
		}
	
	//	Area negative if counter clockwise pentagon -- 
	
	CGFloat area = fabs(areaSum - areaDif) * 0.5;
	return area;
	}
	

//-----------------------------------------------------------------------------------------------
//
//																				  zFindConvexHull
//
//-----------------------------------------------------------------------------------------------


#if 0
int zPreparePointsForConvexHull(CGPoint* points, int count)
	{	
	//	Sort points and toss duplicates.

	zSortPoints(points, count);

	int i, j;
	CGPoint lastPoint;
	
	//	Remove duplicates -- 
	
	j = 0;
	lastPoint = points[0];
	for (i = 1; i < count; ++i)
		{
		if (!zPointsAreEqual(lastPoint, points[i]))
			{
			points[j++] = lastPoint;
			lastPoint = points[i];
			}
		}
			
	points[j++] = lastPoint;
	return j;
	}
#else

int localCompareFloat(CGFloat a, CGFloat b)
	{
	if (fabs(a - b) < 0.0001)
		return 0;
	else
		return (a > b) ? 1 : -1;
	}

int zPreparePointsForConvexHull(CGPoint* points, int count)
	{	
	//	Sort points and toss duplicates.

	int i, j;
	CGPoint lastPoint;
	
	//	Remove duplicates -- 

	zSortPointsByY(points, count);
	
	j = 0;
	lastPoint = points[0];
	for (i = 1; i < count; ++i)
		{
		if (localCompareFloat(lastPoint.y, points[i].y) == 0)
			{
			if (localCompareFloat(lastPoint.x, points[i].x) == 0)
				continue;
			else
			if ((i+1) < count && localCompareFloat(lastPoint.y, points[i+1].y) == 0)
				continue;
			}
		points[j++] = lastPoint;
		lastPoint = points[i];
		}
	points[j++] = lastPoint;
	count = j;
	
	zSortPointsByX(points, count);
	
	j = 0;
	lastPoint = points[0];
	for (i = 1; i < count; ++i)
		{
		if (localCompareFloat(lastPoint.x, points[i].x) == 0)
			{
			if (localCompareFloat(lastPoint.y, points[i].y) == 0)
				continue;
			else
			if ((i+1) < count && localCompareFloat(lastPoint.x, points[i+1].x) == 0)
				continue;
			}
		points[j++] = lastPoint;
		lastPoint = points[i];
		}
	points[j++] = lastPoint;
	count = j;
	
	return count;
	}
#endif


#define kDebugHull 1

int zFindConvexHull(CGPoint* points, int count)
	{
	//	Uses the Melmen algorithm to compute the convex hull.
	//
	//	Check this reference:
	//
	//	http://softsurfer.com/Archive/algorithm_0203/algorithm_0203.htm

	CGPoint* queue = NULL;
	
#ifdef kDebugHull
	CGPoint* sp1 = NULL;
	CGPoint* sp2 = NULL;
	
	//	Save the past points --
	int sc1 = count;
	sp1 = calloc(count, sizeof(CGPoint));
	memcpy(sp1, points, sizeof(CGPoint)*count);
#endif	
	
	count = zPreparePointsForConvexHull(points, count);
	if (count < 3) goto exit;

#ifdef kDebugHull 
	//	Save the past points --
	int sc2 = count;
	sp2 = calloc(count, sizeof(CGPoint));
	memcpy(sp2, points, sizeof(CGPoint)*count);
#endif	

	//	Initialize the queue so that the first three vertices
	//	are a counter-clockwise triangle --
	
	queue = calloc(count*2+1, sizeof(CGPoint));
	if (!queue) { count = 0; goto exit; }
	
	int i;
	int bottom = count - 2;
	int top = bottom + 3;
	
	queue[bottom] = queue[top] = points[2];
	
    if (ZCGFloatCompare(zPointIsLeft(points[0], points[1], points[2]), 0.0) > 0) 
		{
		//	Counter-clockwise vertices are indices 2,0,1,2 -- 
		
        queue[bottom + 1] = points[0];
        queue[bottom + 2] = points[1];          
		}
    else 
		{
		//	Counter-clockwise vertices are indices 2,1,0,2 -- 
		
        queue[bottom + 1] = points[1];
        queue[bottom + 2] = points[0];
		}


	//	Add points to the queued points, filling out the hull -- 
	
    for (i = 3; i < count; ++i) 
		{
		zDebugAssert((top >= bottom) && (top < 2*count+1) && (bottom >= 0));	// Queue sanity.
		
        //	Test if the next vertex is inside the queue hull --
		
		if (ZCGFloatCompare(zPointIsLeft(queue[bottom], queue[bottom+1], points[i]), 0.0) > 0 &&
			ZCGFloatCompare(zPointIsLeft(queue[top-1], queue[top], points[i]), 0.0) > 0)
			continue;
				
        //	Get the rightmost tangent at the deque bot -- 
		
		while (ZCGFloatCompare(zPointIsLeft(queue[bottom], queue[bottom+1], points[i]), 0.0) <= 0)
			++bottom;
		        
		//	Insert a point at the bottom of the queue.
		
		queue[--bottom] = points[i];	

        //	Get the leftmost tangent at the top of the queue -- 
		
		while (ZCGFloatCompare(zPointIsLeft(queue[top-1], queue[top], points[i]), 0.0) <= 0)
			--top;
					
		//	Push the point on top of the stack --

        queue[++top] = points[i];          
		}

	//	Copy the hull points back to out input array -- 
	
	CGPoint* p = points;
	CGPoint* q = &queue[bottom];
	
	i = (top - bottom);
	if (i <= count && i > 0)
		{}
	else
		{
		zDebugMessage(@"top: %d bottom: %d diff: %d.", top, bottom, i);
#ifdef kDebugHull
		zDebugMessage(@"sc1 count: %d:", sc1);
		for (int z = 0; z < sc1; ++z)
			{
			zDebugMessage(@"  (%f, %f)", sp1[z].x, sp1[z].y);
			}
		zDebugMessage(@"sc2 count: %d:", sc2);
		for (int z = 0; z < sc2; ++z)
			{
			zDebugMessage(@"  (%f, %f)", sp2[z].x, sp2[z].y);
			}
#endif
		}
	zDebugAssert(i <= count && i > 0);
	count = i;
	while (i--) 
		*p++ = *q++;

exit:
	if (queue) free(queue);
#ifdef kDebugHull
	if (sp1) free(sp1);	
	if (sp2) free(sp2);
#endif
    return count;
	}

*/
