//
//  NSDate+ZLibrary.h
//  ZLibrary
//
//  Created by Edward Smith on 2/3/15.
//  Copyright (c) 2015 Edward Smith. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSDate (NSDate_ZLibrary)

- (NSString*) stringRelativeToNow;
+ (NSDate*)   now;

@end
