


//-----------------------------------------------------------------------------------------------
//
//																					 ZBuildInfo.m
//																	 ZLibrary for Mac and iPhone.
//
//															  Tracks build time and version info.
//																		 Edward Smith, March 2007
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZBuildInfo.h"
#import "ZDebug.h"


char kBuildTimeStamp [] = __TIME__ " " __DATE__ "\0";

time_t ParseBuildTimeStamp(const char* timep);
time_t ParseBuildTimeStamp(const char* timep)
	{
	struct tm longTime;
	
	//	Parse '23:59:01 Nov 24 1986' --
	
	if (NULL == strptime(timep, "%H:%M:%S %b %d %Y", &longTime))
		return 0;
	
	return mktime(&longTime);
	}


@interface NSDateFormatter(OS4Only)
+ (NSString*) localizedStringFromDate:(NSDate*)date dateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
@end


//  Handle ARC --

#if __has_feature(objc_arc)
    #define retain_if_needed(x)			(x)
    #define release_if_needed(x)		(x)
	#define autorelease_if_needed(x)	(x)
#else
    #define retain_if_needed(x)			[x retain]
    #define release_if_needed(x)		[x release]
	#define autorelease_if_needed(x)	[x autorelease]
#endif

	
NSString* stringFromDate(NSDate* date, NSDateFormatterStyle dateStyle, NSDateFormatterStyle timeStyle);
NSString* stringFromDate(NSDate* date, NSDateFormatterStyle dateStyle, NSDateFormatterStyle timeStyle)
	{
	NSString* dateString = nil;
	if ([NSDateFormatter instancesRespondToSelector:@selector(init)])
		{
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:dateStyle];
		[formatter setTimeStyle:timeStyle];
		dateString = [formatter stringFromDate:date];
		release_if_needed(formatter);
		}
	else
	if ([NSDateFormatter resolveClassMethod:@selector(localizedStringFromDate:dateStyle:timeStyle:)])
		{
		dateString = 
			[NSDateFormatter localizedStringFromDate:date
				dateStyle:dateStyle
				timeStyle:timeStyle];
		}
	else
		ZLog(@"No date formatters available.");
	return dateString;
	}


static NSDate*		kBuildDate = nil;
static NSString*	kVersionString = nil;
static NSString*	kCopyrightString = nil;


@implementation ZBuildInfo

+ (void) initialize
	{
	kBuildDate =
		retain_if_needed(
			[[[NSBundle mainBundle]
				infoDictionary]
					objectForKey:@"ZBuildInfoDate"]);

	if (!kBuildDate)
		{
		ZLog(@"Build error: ZBuildInfo.m built wrong. A custom build step must be used.");
		
		NSError *error = nil;
		NSDictionary * attributes =
			[[NSFileManager defaultManager]
				attributesOfItemAtPath:[NSBundle mainBundle].resourcePath
				error:&error];
	
		if (error)
			ZLog(@"Error getting alternate build timestamp: %@.", error);

		kBuildDate = [attributes objectForKey:NSFileModificationDate];
		}

	
	kVersionString =
		retain_if_needed(
			[[[NSBundle mainBundle]
				infoDictionary]
					objectForKey:@"CFBundleVersion"]);
					
	kCopyrightString =
		retain_if_needed(
			[[[NSBundle mainBundle]
				infoDictionary]
					objectForKey:@"NSHumanReadableCopyright"]);
	}

+ (NSDate*) buildDate
	{
	return kBuildDate;
	}
	
+ (NSString*) buildDateStringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle 
	{
	return stringFromDate(kBuildDate, dateStyle, timeStyle);
	}

+ (NSString*) buildDateString
	{
	return [ZBuildInfo buildDateStringWithDateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterLongStyle];
	}
	
+ (NSString*)	versionString
	{
	return kVersionString;
	}

+ (NSString*) copyrightString
	{
	return kCopyrightString;
	}

+ (NSString*) applicationName
	{
	NSString* applicationName = 
		[[[NSBundle mainBundle] 
			infoDictionary]
				objectForKey:@"CFBundleDisplayName"];
	return applicationName;
	}

+ (NSString*) longBuildString
	{
	NSString* debug = @"";
#if DEBUG
	debug = @" Debug";
#endif	
	
	NSString* buildString =
		[NSString stringWithFormat:@"%@ Version %@%@ Built %@ running on %@ %@",
			[ZBuildInfo applicationName],
			[ZBuildInfo versionString], 
			debug,
			[ZBuildInfo buildDateStringWithDateStyle:NSDateFormatterFullStyle
				timeStyle:NSDateFormatterLongStyle],
			[UIDevice currentDevice].systemName,
			[UIDevice currentDevice].systemVersion];
	return buildString;
	}

+ (NSString*) shortBuildString
	{
	NSString* debug = @"";
#if DEBUG
	debug = @" Debug";
#endif	
	
	NSString* buildString =
		[NSString stringWithFormat:@"%@ %@%@",
			[ZBuildInfo applicationName],
			[ZBuildInfo versionString],
			debug];
	return buildString;
	}

+ (NSComparisonResult) compareVersionString:(NSString*)string1 withVersionString:(NSString*)string2
	{
	NSArray *a1 = [string1 componentsSeparatedByString:@"."];
	NSArray *a2 = [string2 componentsSeparatedByString:@"."];

	NSEnumerator *e1 = a1.objectEnumerator;
	NSEnumerator *e2 = a2.objectEnumerator;

	NSString *s1 = e1.nextObject;
	NSString *s2 = e2.nextObject;
	
	while (s1 && s2)
		{
		if (s1.length > 3 || s2.length > 3)
			{
			s1 = [NSString stringWithFormat:@"0.%@", s1];
			s2 = [NSString stringWithFormat:@"0.%@", s2];
			}
			
		if (s1.floatValue < s2.floatValue)
			return NSOrderedAscending;
		else
		if (s1.floatValue > s2.floatValue)
			return NSOrderedDescending;
		
		s1 = e1.nextObject;
		s2 = e2.nextObject;
		}
		
	while (s2)
		{
		if (s2.intValue > 0)
			return NSOrderedAscending;
		s2 = e2.nextObject;
		}
		
	while (s1)
		{
		if (s1.intValue > 0)
			return NSOrderedDescending;
		s1 = e1.nextObject;
		}
	
	return NSOrderedSame;
	}
	
@end
