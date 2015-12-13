//
//  ZBlurredImageView.h
//  ZLibrary
//
//  Created by Edward Smith on 1/2/14.
//  Copyright (c) 2015 Edward Smith. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface ZBlurredImageView : UIImageView
@property (nonatomic, assign, getter=isBlurred) BOOL blurred;
- (void) setBlurred:(BOOL)blur animated:(BOOL)animated;
- (void) setBlurred:(BOOL)blur animated:(BOOL)animated duration:(NSTimeInterval)duration;
@property (nonatomic, strong) UIColor *blurColor;
@property (nonatomic, assign) CGFloat  blurRadius;
@end
