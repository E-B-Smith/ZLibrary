//
//  UIImage+ZLibrary.h
//  ZLibrary
//
//  Created by Edward Smith on 12/9/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIImage (ZLibrary)

+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size;
+ (UIImage*) imageNamedR4:(NSString *)name;		//	Tries to load a retina 4 image first if available.
- (UIImage*) imageWithGaussianBlurOfRadius:(CGFloat)radius;
- (UIImage*) imageSliceAtIndex:(NSInteger)index size:(CGSize)size inset:(CGSize)inset;
- (UIImage*) imageTintedWithColor:(UIColor*)color;

- (UIImage*) imageWithSize:(CGSize)size;
- (UIImage*) imageWithAspectFitSize:(CGSize)size;
- (UIImage*) imageScaled:(CGFloat)scale;
- (UIImage*) imageCroppedToRect:(CGRect)rect;

@end
