


//-----------------------------------------------------------------------------------------------
//
//                                                                                   ZUtilities.h
//                                                                                   ZLibrary-Mac
//
//                                                               	Mac and iOS Utility Functions
//                                                                       Edward Smith, March 2009
//
//                               -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


#ifdef __cplusplus
extern "C" {
#endif


#pragma mark Geometric Functions
//-----------------------------------------------------------------------------------------------
//
//                                        Geometric Functions
//
//-----------------------------------------------------------------------------------------------



static inline CGRect ZCenterRectOverRect(CGRect rectToCenter, CGRect overRect)
       {
       return CGRectMake(
                        overRect.origin.x + ((overRect.size.width - rectToCenter.size.width)/2.0)
                       ,overRect.origin.y + ((overRect.size.height - rectToCenter.size.height)/2.0)
                       ,rectToCenter.size.width
                       ,rectToCenter.size.height
                       );
       }

static inline CGRect ZCenterRectOverRectX(CGRect rectToCenter, CGRect overRect)
	{
   return CGRectMake(
					overRect.origin.x + ((overRect.size.width - rectToCenter.size.width)/2.0)
				   ,rectToCenter.origin.y
				   ,rectToCenter.size.width
				   ,rectToCenter.size.height
				   );
	}

static inline CGRect ZCenterRectOverRectY(CGRect rectToCenter, CGRect overRect)
	{
       return CGRectMake(
                        rectToCenter.origin.x
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

static inline CGRect ZAlignRectTopWithRect(CGRect r, CGRect alignRect)
	{
	r.origin.y = alignRect.origin.y;
	return r;
	}

static inline CGRect ZAlignRectBottomWithRect(CGRect r, CGRect alignRect)
	{
	r.origin.y = alignRect.origin.y + alignRect.size.height - r.size.height;
	return r;
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

static inline CGRect ZRectInflate(CGRect r, CGFloat dx, CGFloat dy)
	{
	dx = r.size.width - (r.size.width*dx);
	dy = r.size.height - (r.size.height*dy);
	return CGRectInset(r, dx, dy);
	}

static inline CGPoint ZPointOffsetPoint(CGPoint p, CGPoint offset)
	{
	p.x += offset.x;
	p.y += offset.y;
	return p;
	}

static inline CGPoint ZPointOffset(CGPoint p, CGFloat x, CGFloat y)
	{
	p.x += x; p.y += y;
	return p;
	}

static inline CGRect ZAssureRectInsideRect(CGRect r, CGRect container)
	{
	CGFloat f = (container.origin.x + container.size.width) - (r.origin.x + r.size.width);
	if (f < 0.0) r.origin.x += f;

	f = (container.origin.y + container.size.height) - (r.origin.y + r.size.height);
	if (f < 0.0) r.origin.y += f;

	if (r.origin.y < container.origin.y)
		r.origin.y = container.origin.y;
	if (r.origin.x < container.origin.x)
		r.origin.x = container.origin.x;

	return r;
	}


#if TARGET_OS_IOS

typedef NS_ENUM(int32_t, UIViewContentModeExtension)
	{
	UIViewContentModeClipped	=	(1<<8),
	UIViewContentModeExtensions = 	0xff00
	};

extern CGRect ZRectForContentMode(UIViewContentMode mode, CGRect idealRect, CGRect boundsRect);

#endif



#pragma mark Geometric Functions
//-----------------------------------------------------------------------------------------------
//
//                                       Conversion Functions
//
//-----------------------------------------------------------------------------------------------


#ifndef ZRadiansFromDegreesDefined
#define ZRadiansFromDegreesDefined

static inline CGFloat ZRadiansFromDegrees(CGFloat d)
    {
    return ((M_PI*d)/180.0);
    }

static inline CGFloat ZDegreesFromRadians(CGFloat radians)
	{
	return  (fmod(radians, 2.0*M_PI) / 2.0*M_PI) * 360.0;
	}

#endif


static inline double ZFahrenheitFromCelsius(double celsius)
	{
	return celsius * 9.0/5.0 + 32.0;
	}

static inline double ZCelsiusFromFahrenheit(double fahrenheit)
	{
	return (fahrenheit - 32.0) * 5.0/9.0;
	}



#pragma mark - Blocks and Threads
//-----------------------------------------------------------------------------------------------
//
//                                        Blocks and Threads
//
//-----------------------------------------------------------------------------------------------



typedef void (^ZPerformBlockType)(void);


static inline dispatch_time_t ZDispatchSeconds(NSTimeInterval seconds)
	{
	return dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
	}

static inline void ZAfterSecondsPerformBlock(NSTimeInterval seconds, ZPerformBlockType block)
	{
	dispatch_after(ZDispatchSeconds(seconds), dispatch_get_main_queue(), block);
	}

static inline void ZPerformBlockInBackground(ZPerformBlockType block)
	{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
	}

static inline void ZPerformBlockOnMainThread(ZPerformBlockType block)
	{
	dispatch_async(dispatch_get_main_queue(), block);
	}

static inline void ZPerformBlockOnMainThreadSynchronous(ZPerformBlockType block)
	{
	dispatch_sync(dispatch_get_main_queue(), block);
	}

static inline void ZPerformBlockOnMainThreadAsynchronous(ZPerformBlockType block)
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


#pragma mark - ZSequentialRand
//-----------------------------------------------------------------------------------------------
//	ZSequentialRand
//
//	Random numbers for testing.  Given the same initial random seed,
//	the same sequence of 'random' numbers are produced.  Great for testing,
//	bad for cryptography.
//-----------------------------------------------------------------------------------------------



extern void     ZSequentialRandSetSeed(uint64_t seed);	//	If -1 is passed as a seed, a seed is choosen from epoch time.
extern uint64_t ZSequentialRandGetSeed();				//	Returns the value used as a seed.
extern double   ZSequentialRand();						//	Return a random double in range of [0.0, 1.0).



#pragma mark - Misc.
//-----------------------------------------------------------------------------------------------
//
//										Misc.
//
//-----------------------------------------------------------------------------------------------


#ifndef _countof
#define _countof(_Array) (sizeof(_Array) / sizeof(_Array[0]))
#endif


#define ZStringifyMacroInner(x)		#x
#define ZStringifyMacro(x)			ZStringifyMacroInner(x)


#define ZInitializeArray(array, value)		\
	do  { for (int _i = 0; _i < _countof(array); ++_i) \
			{ array[_i] = value; } \
		} while (0)


#define ZEmptyStringIfNil(nsstring)			(nsstring)?:@""
#define ZNSNullIfNil(nsobject)				(nsobject)?:[NSNull null]

#define ZRange(value, minValue, maxValue)	MAX(MIN(value, maxValue), minValue)
#define ZSign(value)						(value < 0) ? -1.0 : 1.0

#define ZUnusedVariable(x)					do { (void)(x); } while (0)


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

static inline NSString * ZGenerateNewUUIDString()
	{
	return [[[[NSUUID UUID] UUIDString]
				stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
					lowercaseString];
	}



#pragma mark - Mapping Functions
//-----------------------------------------------------------------------------------------------
//
//                                   Location Mapping Functions
//
//-----------------------------------------------------------------------------------------------


extern CLLocationCoordinate2D CLLocationCoordinate2DFromNSString(NSString*string);
extern NSString* NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D location);

MKMapRect MKMapRectFromCoordinateRegion(MKCoordinateRegion region);
BOOL MKLocationCoordinate2DIsValid(CLLocationCoordinate2D coordinate);

extern MKCoordinateRegion MKCoordinateRegionZero;
extern CLLocationCoordinate2D CLLocationCoordinateInvalid;

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


@interface CLLocation (ZLibrary)
+ (CLLocation*) locationFromDictionary:(NSDictionary*)dictionary;
- (NSDictionary*) dictionary;
@end


@interface CLPlacemark (ZLibrary)
+ (CLPlacemark*) placemarkFromDictionary:(NSDictionary*)dictionary;
- (NSDictionary*) dictionary;
- (NSString*) cityName;
@end


#if defined(__cplusplus)
}
#endif
