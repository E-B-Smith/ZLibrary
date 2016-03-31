


//-----------------------------------------------------------------------------------------------
//
//																	NSAttributedString+ZLibrary.h
//																					     ZLibrary
//
//								   				 Categories for working with NSAttributedStrings.
//																	  Edward Smith, December 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>


@interface NSAttributedString (ZLibrary)
+ (NSAttributedString*) stringWithImage:(UIImage*)image;
+ (NSMutableAttributedString*) stringWithStrings:(NSAttributedString*)string, ...;
+ (NSAttributedString*) string:(NSString*)string;
+ (NSAttributedString*) string:(NSString*)string withFont:(UIFont*)font;
+ (NSAttributedString*) string:(NSString*)string withColor:(UIColor*)color;
@end
