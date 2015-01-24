//
//  ZImageColors.h
//  Search
//
//  Created by Edward Smith on 2/13/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import <Foundation/Foundation.h>


@interface ZImageColors : NSObject

+ (ZImageColors*) imageColorsForImage:(UIImage*)image;

- (NSArray*) topColors;
- (NSArray*) closestColors:(UIColor*)color;

@end
