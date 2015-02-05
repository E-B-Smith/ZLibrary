//
//  NSDate+NSDate_ZLibrary.m
//  Happiness
//
//  Created by Edward Smith on 2/3/15.
//  Copyright (c) 2015 Edward Smith. All rights reserved.
//


#import "NSDate+ZLibrary.h"
#import "ZUtilities.h"


@implementation NSDate (ZLibrary)

#if 1

- (NSString*) stringRelativeToNow
	{
	NSTimeInterval intervals[] = { 2*60.0, 	2.0*60.0*60.0, 		24.0*60.0*60.0, 		7.0*24.0*60.0*60.0 };
	NSTimeInterval modulus[] =   {   60.0,			 60.0,			 60.0*60.0,			24.0*60.0*60.0 };
	NSString * strings [] = 	 { @"now",	   @"minutes", 	   	      @"hours",    			   @"days" };

	NSTimeInterval span = - [self timeIntervalSinceNow];

	int i = 0;
	while (i < _countof(intervals) && span > intervals[i]) ++i;

	NSString * result = nil;
	if (i == 0)
		result = @"A moment ago";
	else
	if (i < _countof(intervals))
		{
		NSInteger d = span / modulus[i];
		result = [NSString stringWithFormat:@"%ld %@ ago", (long)d, strings[i]];
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

@end
