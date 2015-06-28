


//-----------------------------------------------------------------------------------------------
//
//																			    NSDate+ZLibrary.h
//																					     ZLibrary
//
//								   											   NSDate extensions.
//																	  Edward Smith, February 2015
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>


@interface NSDate (NSDate_ZLibrary)

+ (NSDate*)   now;
+ (NSDate*)   dateFromString:(NSString*)dateString withFormat:(NSString*)format;
- (NSString*) stringRelativeToNow;

//	RFC8222 Format:  Mon, 2 Jan 2006 15:04:05 -0700

- (NSString*) RFC8222String;
+ (NSDate*)   dateFromRFC8222String:(NSString*)string;

@end
