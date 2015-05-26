


//-----------------------------------------------------------------------------------------------
//
//																		  NSFileHandle+ZLibrary.h
//																					 ZLibrary-Mac
//
//								   										 NSFileHandle extensions.
//																	       Edward Smith, May 2015
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>


@interface NSFileHandle (ZLibrary)

- (NSString*) pathname;
+ (NSFileHandle*) handleForTemporaryFile;

@end

