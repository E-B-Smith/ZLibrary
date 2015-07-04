


//-----------------------------------------------------------------------------------------------
//
//                                                                                   ZUtilities.m
//                                                                                   ZLibrary-Mac
//
//                                                               	Mac and iOS Utility Functions
//                                                                       Edward Smith, March 2009
//
//                               -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZUtilities.h"
#import "ZDebug.h"
#import <objc/runtime.h>


#pragma mark Mapping Functions
//-----------------------------------------------------------------------------------------------
//
//                                        Mapping Functions
//
//-----------------------------------------------------------------------------------------------



MKCoordinateRegion MKCoordinateRegionZero = { {0.0, 0.0}, {0.0, 0.0} };

MKMapRect MKMapRectFromCoordinateRegion(MKCoordinateRegion region)
	{
    MKMapPoint a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
        region.center.latitude + region.span.latitudeDelta / 2.0,
        region.center.longitude - region.span.longitudeDelta / 2.0));
    MKMapPoint b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
        region.center.latitude - region.span.latitudeDelta / 2.0,
        region.center.longitude + region.span.longitudeDelta / 2.0));
    return MKMapRectMake(MIN(a.x,b.x), MIN(a.y,b.y), ABS(a.x-b.x), ABS(a.y-b.y));
	}

BOOL MKLocationCoordinate2DIsValid(CLLocationCoordinate2D coordinate)
	{
	if ((coordinate.latitude == -180.0 && coordinate.longitude == -180.0) ||
		(coordinate.latitude == -360.0 && coordinate.longitude == -360.0) ||
		(coordinate.latitude ==  360.0 && coordinate.longitude ==  360.0) ||
		(coordinate.latitude ==    0.0 && coordinate.longitude ==    0.0))
		return NO;
	else
		return YES;
	}

MKCoordinateRegion MKBoundingRegionOfAnnotations(NSArray* annotations)
	{
	CLLocationCoordinate2D maxCoordinate = CLLocationCoordinate2DMake(- DBL_MAX, - DBL_MAX);
	CLLocationCoordinate2D minCoordinate = CLLocationCoordinate2DMake(  DBL_MAX,   DBL_MAX);

	for (id<MKAnnotation> a in annotations)
		{
		if(a.coordinate.latitude > maxCoordinate.latitude)
			maxCoordinate.latitude = a.coordinate.latitude;

		if(a.coordinate.longitude > maxCoordinate.longitude)
			maxCoordinate.longitude = a.coordinate.longitude;

		if(a.coordinate.latitude < minCoordinate.latitude)
			minCoordinate.latitude = a.coordinate.latitude;

		if(a.coordinate.longitude < minCoordinate.longitude)
			minCoordinate.longitude = a.coordinate.longitude;
		}

	MKCoordinateRegion region = MKCoordinateRegionZero;
	if (MKLocationCoordinate2DIsValid(maxCoordinate) &&
		MKLocationCoordinate2DIsValid(minCoordinate))
		{
		region.center.latitude = (maxCoordinate.latitude + minCoordinate.latitude) / 2.0;
		region.center.longitude = (maxCoordinate.longitude + minCoordinate.longitude) / 2.0;
		region.span.latitudeDelta = (maxCoordinate.latitude - minCoordinate.latitude) * 1.5;
		region.span.longitudeDelta = (maxCoordinate.longitude - minCoordinate.longitude) * 1.5;
		}

	return region;
	}

CLLocationCoordinate2D CLLocationCoordinateInvalid = { -360.0, -360.0 };


CLLocationCoordinate2D CLLocationCoordinate2DFromNSString(NSString*string)
	{
	double lat,lng;
	CLLocationCoordinate2D location = CLLocationCoordinateInvalid;
	if (!string) return location;
	NSScanner * s = [NSScanner scannerWithString:string];
	[s scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
	[s scanString:@"(" intoString:nil];
	if (![s scanDouble:&lat])
		return location;
	[s scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
	[s scanString:@"," intoString:nil];
	[s scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
	if (![s scanDouble:&lng])
		return location;
	location.latitude = lat;
	location.longitude = lng;
	return location;
	}

NSString* NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D location)
	{
	return [NSString stringWithFormat:@"(%f, %f)", location.latitude, location.longitude];
	}


@implementation CLLocation (ZLibrary)

+ (CLLocation*) locationFromDictionary:(NSDictionary*)dictionary
	{
	if (!dictionary) return nil;
	CLLocationCoordinate2D coordinate;
	coordinate.latitude  = [dictionary[@"latitude"] doubleValue];
	coordinate.longitude = [dictionary[@"longitude"] doubleValue ];

	CLLocation *location =
		[[CLLocation alloc]
			initWithCoordinate:coordinate
			altitude:[dictionary[@"altitude"] doubleValue]
			horizontalAccuracy:[dictionary[@"horizontalAccuracy"] doubleValue]
			verticalAccuracy:[dictionary[@"verticalAccuracy"] doubleValue ]
			timestamp:dictionary[@"timestamp"]];

	return location;
	}

- (NSDictionary*) dictionary
	{
	return
		@{
		@"longitude": 	[NSNumber numberWithDouble:self.coordinate.longitude],
		@"latitude":  	[NSNumber numberWithDouble:self.coordinate.latitude],
		@"altitude":	[NSNumber numberWithDouble:self.altitude],
		@"timestamp":	ZNSNullIfNil(self.timestamp),
		@"horizontalAccuracy":		[NSNumber numberWithDouble:self.horizontalAccuracy],
		@"verticalAccuracy":		[NSNumber numberWithDouble:self.verticalAccuracy]
		};
	}

@end


@implementation CLPlacemark (ZLibrary)

+ (CLPlacemark*) placemarkFromDictionary:(NSDictionary*)dictionary
	{
	if (!dictionary) return nil;
	CLLocationCoordinate2D coordinate;
	coordinate.latitude  = [dictionary[@"latitude"] doubleValue];
	coordinate.longitude = [dictionary[@"longitude"] doubleValue ];
	MKPlacemark * place = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:dictionary[@"address"]];
	return place;
	}

- (NSDictionary*) dictionary
	{
	CLLocation * location = self.location;
	NSDictionary * address = self.addressDictionary;

	NSDictionary *dictionary =
		@{ 	@"latitude":			[NSNumber numberWithDouble:location.coordinate.latitude],
			@"longitude":			[NSNumber numberWithDouble:location.coordinate.longitude],
			@"address":				address };

	return dictionary;
	}

- (NSString*) cityName
	{
	if (self.locality.length > 0) return self.locality;
	if (self.subAdministrativeArea.length > 0) return self.subAdministrativeArea;
	if (self.administrativeArea.length > 0) return self.administrativeArea;
	return nil;
	}

@end


#pragma mark - Geometric Functions
//-----------------------------------------------------------------------------------------------
//
//                                        Geometric Functions
//
//-----------------------------------------------------------------------------------------------



#if TARGET_OS_IPHONE

CGRect ZRectForContentMode(UIViewContentMode mode, CGRect idealRect, CGRect boundsRect)
	{
	BOOL clipped = !!(mode & UIViewContentModeClipped);
	mode = ~UIViewContentModeExtensions & mode;

	if (!clipped)
		{
		if (idealRect.size.height > boundsRect.size.height)
			boundsRect.size.height = idealRect.size.height;
		if (idealRect.size.width > boundsRect.size.width)
			boundsRect.size.width = idealRect.size.width;
		}

	idealRect = ZCenterRectOverRect(idealRect, boundsRect);

	switch (mode)
		{
		case UIViewContentModeScaleToFill:
			idealRect = boundsRect;
			break;
		case UIViewContentModeScaleAspectFit:
		case UIViewContentModeScaleAspectFill:
			{
			CGFloat ratioW = boundsRect.size.width / idealRect.size.width;
			CGFloat ratioH = boundsRect.size.height / idealRect.size.height;
			if (mode == UIViewContentModeScaleAspectFit)
				ratioW = MIN(ratioW, ratioH);
			else
				ratioW = MAX(ratioW, ratioH);
			idealRect.size.height *= ratioW;
			idealRect.size.width  *= ratioW;
			idealRect = ZCenterRectOverRect(idealRect, boundsRect);
			break;
			}
		case UIViewContentModeRedraw:
			idealRect = boundsRect;
			break;
		case UIViewContentModeCenter:
			break;
		case UIViewContentModeTop:
			idealRect.origin.y = boundsRect.origin.y;
			break;
		case UIViewContentModeBottom:
			idealRect.origin.y = boundsRect.origin.y + boundsRect.size.height - idealRect.size.height;
			break;
		case UIViewContentModeLeft:
			idealRect.origin.x = boundsRect.origin.x;
			break;
		case UIViewContentModeRight:
			idealRect.origin.x = boundsRect.origin.x + boundsRect.size.width - idealRect.size.width;
			break;
		case UIViewContentModeTopLeft:
			idealRect.origin = boundsRect.origin;
			break;
		case UIViewContentModeTopRight:
			idealRect.origin.y = boundsRect.origin.y;
			idealRect.origin.x = boundsRect.origin.x + boundsRect.size.width - idealRect.size.width;
			break;
		case UIViewContentModeBottomLeft:
			idealRect.origin.y = boundsRect.origin.y + boundsRect.size.height - idealRect.size.height;
			idealRect.origin.x = boundsRect.origin.x;
			break;
		case UIViewContentModeBottomRight:
			idealRect.origin.y = boundsRect.origin.y + boundsRect.size.height - idealRect.size.height;
			idealRect.origin.x = boundsRect.origin.x + boundsRect.size.width - idealRect.size.width;
			break;
		default:
			break;
		}

	return idealRect;
	}

#endif


#pragma mark - ZSequentialRand


static uint64_t ZSequentialRandSeedInitialValue = (uint64_t) -1;

uint64_t ZSequentialRandGetSeed()
	{
	return ZSequentialRandSeedInitialValue;
	}

void ZSequentialRandSetSeed(uint64_t seed)
	{
	if (seed == (uint64_t)-1)
		seed = rint(time(NULL) * 555.0);

	ZSequentialRandSeedInitialValue = seed;

	ushort us_seed[3];
	us_seed[0] =         seed & 0x0000ffff;
	us_seed[1] = (seed >> 16) & 0x0000ffff;
	us_seed[2] = (seed >> 32) & 0x0000ffff;

	seed48(us_seed);
	}

double ZSequentialRand()
	{
	#ifndef __clang_analyzer__
	  return drand48();
	#else
	  return 1.0;
	#endif
	}

