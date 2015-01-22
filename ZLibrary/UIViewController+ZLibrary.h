//
//  UIViewController+ZLibrary.h
//  Search
//
//  Created by Edward Smith on 12/1/13.
//  Copyright (c) 2013 Relcy, Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIViewController (ZLibrary)

- (void) forceViewToLoad;
+ (UIViewController*) activeViewController;

@end
