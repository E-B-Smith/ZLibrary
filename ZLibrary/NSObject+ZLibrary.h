//
//  NSObject+ZLibrary.h
//  ZLibrary
//
//  Created by Edward Smith on 1/22/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSObject (ZLibrary)

+ (BOOL) replaceMethod:(SEL)existingMethod withMethod:(SEL)method;

@end
