


//-----------------------------------------------------------------------------------------------
//
//																			   NSArray+ZLibrary.h
//																					 ZLibrary-iOS
//
//								   Replaces invalid plist objects in an array with proxy objects.
//																	   Edward Smith, January 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>


@interface NSArray (ZLibrary)
- (NSMutableArray*) shuffledArray;	//	If seed < 0 then seed is choosen.
@end
