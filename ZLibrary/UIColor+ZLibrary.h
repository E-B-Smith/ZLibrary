//
//  UIColor+ZLibrary.h
//  ZLibrary
//
//  Created by Edward Smith on 1/17/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIColor (ZLibrary)

+ (UIColor*) colorWith255R:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue;
+ (UIColor*) colorWithHexInt:(NSUInteger)hex;
+ (UIColor*) colorWithHex:(NSString*)hex;

- (UIColor*) colorByBlendingWhite:(CGFloat)percent;
- (UIColor*) colorByBlendingBlack:(CGFloat)percent;
- (CGFloat)  distanceFromColor:(UIColor*)color;			//	Calculated wrong?
- (CGFloat)  luminosity;

@end
