


//-----------------------------------------------------------------------------------------------
//
//																			     ZLibrary+PList.h
//																					 ZLibrary-iOS
//
//					  Replaces invalid plist objects in a dictionary or array with proxy objects.
//																	   Edward Smith, January 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>


#pragma mark NSDictionary 


@interface NSDictionary (ZLibraryPList)
- (NSMutableDictionary*) dictionaryForPListReplacingInvalidObjectsWith:(id)object;

- (NSMutableDictionary*) dictionaryForPListEncodingInvalidObjects;
- (NSMutableDictionary*) dictionaryFromPListDecodingInvalidObjects;
@end


#pragma mark - NSArray


@interface NSArray (ZLibraryPList)
- (NSMutableArray*) arrayForPListReplacingInvalidObjectsWith:(id)object;

- (NSMutableArray*) arrayForPListEncodingInvalidObjects;
- (NSMutableArray*) arrayFromPListDecodingInvalidObjects;
@end
