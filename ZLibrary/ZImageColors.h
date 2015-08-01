


//-----------------------------------------------------------------------------------------------
//
//																		   		   ZImageColors.h
//																					 ZLibrary-iOS
//
//								   								   A nicely drawn button for iOS.
//																	  Edward Smith, February 2014
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>


@interface ZImageColors : NSObject

+ (ZImageColors*) imageColorsForImage:(UIImage*)image;

- (NSArray*) topColors;
- (NSArray*) closestColors:(UIColor*)color;

@end
