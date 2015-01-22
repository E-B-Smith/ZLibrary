//
//  ZUtilitiesIOS.m
//  ZLib-iPhone
//
//  Created by Edward Smith on 3/7/11.
//  Copyright 2011 Edward Smith, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSScanner (ZLibrary)

- (void) nextLocation;
- (unichar) currentCharacter;
- (BOOL) scanUpToOccurance:(NSInteger)occurance ofString:(NSString*)string intoString:(NSString* __autoreleasing *)result;

@end
