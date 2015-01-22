//
//  UIView+ZLibraryu.h
//  Search
//
//  Created by Edward Smith on 12/3/13.
//  Copyright (c) 2013 Relcy, Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


extern void ZDebugGlobalEnableDebugViewFrames(BOOL enabled);


@interface UIView (ZLibrary)

- (UIView*) firstResponder;
- (BOOL) 	findAndResignFirstResponder;
- (id) 		findSubviewOfClass:(Class)class_;
- (id) 		findSuperviewOfClass:(Class)class_;
- (UIView*) findSubviewUsingPredicateBlock:(BOOL (^) (UIView* subview))predicateBlock;
- (void) 	applyToViewHeirarchy:(void (^) (UIView* subview))block;

- (UIImage*) image;
- (UIImage*) imageWithSubviews:(BOOL)includeSubviews;

- (CGRect) currentWindowBounds;

- (UIColor*) nextDebugColor;
- (void) setShowDebugFrame:(BOOL)on;
- (void) setShowSubviewDebugFrames:(BOOL)on;

- (UIViewController*) viewController;

@end
