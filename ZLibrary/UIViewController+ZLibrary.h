//
//  UIViewController+ZLibrary.h
//  ZLibrary
//
//  Created by Edward Smith on 12/1/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIViewController (ZLibrary)

- (void) forceViewToLoad;
+ (UIViewController*) activeViewController;

@end
