


//-----------------------------------------------------------------------------------------------
//
//                                                                           NSScanner+ZLibrary.h
//                                                                                   ZLibrary-Mac
//
//                                                               			  NSScanner Additions
//                                                                       Edward Smith, March 2011
//
//                               -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------



#ifdef __cplusplus
extern "C" {
#endif


#import <Foundation/Foundation.h>


@interface NSScanner (ZLibrary)

- (void) nextLocation;
- (unichar) currentCharacter;
- (BOOL) scanUpToOccurance:(NSInteger)occurance ofString:(NSString*)string intoString:(NSString* __autoreleasing *)result;

@end
