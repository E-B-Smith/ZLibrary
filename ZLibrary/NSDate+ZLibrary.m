


//-----------------------------------------------------------------------------------------------
//
//																			    NSDate+ZLibrary.m
//																					     ZLibrary
//
//								   											   NSDate extensions.
//																	  Edward Smith, February 2015
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "NSDate+ZLibrary.h"
#import "ZUtilities.h"


@implementation NSDate (ZLibrary)

#if 1

- (NSString*) stringRelativeToNow
	{
	NSTimeInterval intervals[] = { 2*60.0, 			   120.0*60.0, 		23.0*60.0*60.0, 	48.0*60.0*60.0,	4.0*24.0*60.0*60.0 };
	NSTimeInterval modulus[] =   {    0.0,					 60.0,			 60.0*60.0,				   0.0,	    24.0*60.0*60.0 };

	NSString * pastStrings [] =
		{
		@"a moment ago",
		@"%ld minutes ago",
		@"%ld hours ago",
		@"a day ago",
		@"%ld days ago"
		};

	NSString * futureStrings [] =
		{
		@"in a moment",
		@"in %ld minutes",
		@"in %ld hours",
		@"in a day",
		@"in %ld days"
		};

	BOOL isFuture = YES;
	NSTimeInterval span = [self timeIntervalSinceNow];
	if (span < 0.0)
		{
		isFuture = NO;
		span *= -1.0;
		}

	int i = 0;
	while (i < _countof(intervals) && span > intervals[i]) ++i;

	NSString * result = nil;
	if (i < _countof(intervals))
		{
		NSInteger d = 0;
		if (modulus[i] > 0.0) d = span / modulus[i];
		if (isFuture)
			result = [NSString stringWithFormat:futureStrings[i], (long) d];
		else
			result = [NSString stringWithFormat:pastStrings[i], d];
		}
	else
		{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.timeStyle = NSDateFormatterNoStyle;
		dateFormatter.dateStyle = NSDateFormatterMediumStyle;
		result = [dateFormatter stringFromDate:self];
		}

	return result;
	}

#else

- (NSString*) stringRelativeToNow
	{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.timeStyle = NSDateFormatterNoStyle;
	dateFormatter.dateStyle = NSDateFormatterMediumStyle;
	dateFormatter.doesRelativeDateFormatting = YES;
	NSString *dateString = [dateFormatter stringFromDate:self];
	return dateString;
	}

#endif

+ (NSDate*) now
	{
	return [NSDate date];
	}

+ (NSDate*) dateFromString:(NSString*)dateString withFormat:(NSString*)format
	{
	NSDate *result;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = format;
	result = [dateFormatter dateFromString:dateString];
	return result;
	}

+ (NSDateFormatter*) RFC8222DateFormatter
	{
	static NSDateFormatter * kRFC8222DateFormat = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken,
	^	{
		//	Format like: Mon, 2 Jan 2006 15:04:05 -0700
		kRFC8222DateFormat = [[NSDateFormatter alloc] init];
		//kRFC8222DateFormat.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
		kRFC8222DateFormat.dateFormat = @"E, d MMM yyyy H:mm:ss ZZZ";
		});	
	return kRFC8222DateFormat;
	}

- (NSString*) RFC8222String
	{
	return [[NSDate RFC8222DateFormatter] stringFromDate:self];
	}

+ (NSDate*) dateFromRFC8222String:(NSString*)string
	{
	return [[NSDate RFC8222DateFormatter] dateFromString:string];
	}

@end

