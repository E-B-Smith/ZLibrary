//
//  ZUtilities.h
//  Search
//
//  Created by Edward Smith on 11/6/13.
//  Copyright (c) 2013 Relcy, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


#if defined(__cplusplus)
extern "C" {
#endif


//
//	Geometric functions --
//	


static inline CGRect ZCenterRectOverRect(CGRect rectToCenter, CGRect overRect)
       {
       return CGRectMake(
                        overRect.origin.x + ((overRect.size.width - rectToCenter.size.width)/2.0)
                       ,overRect.origin.y + ((overRect.size.height - rectToCenter.size.height)/2.0)
                       ,rectToCenter.size.width
                       ,rectToCenter.size.height
                       );
       }

static inline CGRect ZCenterRectOverPoint(CGRect rectToCenter, CGPoint referencePoint)
	{
	return CGRectMake(
			referencePoint.x - (rectToCenter.size.width / 2.0),
			referencePoint.y - (rectToCenter.size.height / 2.0),
			rectToCenter.size.width,
			rectToCenter.size.height);
	}

static inline CGPoint ZCenterPointOfRect(CGRect rect)
	{
	CGPoint p =
		CGPointMake(
			rect.origin.x + rect.size.width / 2.0,
			rect.origin.y + rect.size.height / 2.0);
	return p;
	}

static inline CGFloat ZDistance(CGPoint p1, CGPoint p2)
	{
	CGFloat x = p1.x - p2.x;
	CGFloat y = p1.y - p2.y;
	return hypotf(x, y);
	}

static inline CGFloat Zfrange(CGFloat low, CGFloat value, CGFloat high)
    {
    if (value < low)
        return low;
    else
    if (value > high)
        return high;
    else
        return value;
    }
	
static inline CGRect ZRectInflate(CGRect r, CGFloat dx, CGFloat dy)
	{
	dx = r.size.width - (r.size.width*dx);
	dy = r.size.height - (r.size.height*dy);
	return CGRectInset(r, dx, dy);
	}

typedef enum UIViewContentModeExtension
	{
	UIViewContentModeClipped	=	(1<<8),
	UIViewContentModeExtensions = 	0xff00
	}
	UIViewContentModeExtension;

#if TARGET_OS_IPHONE
extern CGRect ZRectForContentMode(UIViewContentMode mode, CGRect idealRect, CGRect boundsRect);
#endif 

//	
//	Performing blocks on threads --
//


typedef void (^ZPerformBlockType)(void);

static inline void ZAfterSecondsPerformBlock(NSTimeInterval seconds, ZPerformBlockType block)
	{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), block);
	}

static inline void ZPerformBlockInBackground(ZPerformBlockType block)
	{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
	}

static inline void ZPerformBlockOnMainThread(ZPerformBlockType block)
	{
	dispatch_async(dispatch_get_main_queue(), block);
	}

static inline void ZPerformBlockAsync(ZPerformBlockType block)
	{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
	}

static inline void ZSleepForSeconds(NSTimeInterval seconds)
	{
	usleep((useconds_t) (seconds * 1000000.0));
	}


//	ZSequentialRand
//
//	Random numbers for testing.  Given the same initial random seed,
//	the same sequence of 'random' numbers are produced.  Great for testing,
//	bad for cryptography.

extern void     ZSequentialRandSeed(uint64_t seed);	//	If 0 is passed as a seed, a seed is choosen from epoch time.
extern uint64_t ZSequentialRandSeedValue();			//	Returns the value used as a seed.
extern double   ZSequentialRand();					//	Return a random double in range of [0.0, 1.0).


//
//
//

#ifndef _countof
#define _countof(_Array) (sizeof(_Array) / sizeof(_Array[0]))
#endif


#define ZEmptyStringIfNil(nsstring)	(nsstring)?:@""


//
//	Map stuff --
//


MKMapRect MKMapRectFromCoordinateRegion(MKCoordinateRegion region);
BOOL MKLocationCoordinate2DIsValid(CLLocationCoordinate2D coordinate);

extern MKCoordinateRegion MKCoordinateRegionZero;

MKCoordinateRegion MKBoundingRegionOfAnnotations(NSArray* annotations);

static inline BOOL MKCoordinateRegionClose(MKCoordinateRegion a, MKCoordinateRegion b, double neighborhood)
	{
	return
	   ((fabs(a.center.latitude - b.center.latitude) <= neighborhood) &&
		(fabs(a.center.longitude - b.center.longitude) <= neighborhood) &&
		(fabs(a.span.latitudeDelta - b.span.latitudeDelta) <= neighborhood) &&
		(fabs(a.span.longitudeDelta - b.span.longitudeDelta) <= neighborhood));
	}
static inline BOOL MKCoordinateRegionEqual(MKCoordinateRegion a, MKCoordinateRegion b)
	{
	return MKCoordinateRegionClose(a, b, DBL_EPSILON);
	}
static inline BOOL MKCoordinateRegionIsValid(MKCoordinateRegion region)
	{
	return
		(MKLocationCoordinate2DIsValid(region.center) &&
		region.span.latitudeDelta >= 0.0 && region.span.latitudeDelta < 360.0 &&
		region.span.longitudeDelta >= 0.0 && region.span.longitudeDelta < 360.0);
	}

#if defined(__cplusplus)
}
#endif
