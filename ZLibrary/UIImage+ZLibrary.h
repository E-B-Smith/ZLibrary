


//-----------------------------------------------------------------------------------------------
//
//																			   UIImage+ZLibrary.h
//																					     ZLibrary
//
//								   											  UIImage extensions.
//																	 Edward Smith, Decemeber 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


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
- (UIImage*) imageUnionImage:(UIImage*)image;

@end
