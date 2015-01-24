

//-----------------------------------------------------------------------------------------------
//
//																			 NSDictionary+PList.h
//																					 ZLibrary-iOS
//
//							  Replaces invalid plist objects in a disctionary with proxy objects.
//																	   Edward Smith, January 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>


@interface NSDictionary (PList)

- (NSMutableDictionary*) dictionaryForPListReplacingInvalidObjectsWith:(id)object;

@end
