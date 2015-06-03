


//-----------------------------------------------------------------------------------------------
//
//																				UIView+ZLibrary.h
//																					 ZLibrary-iOS
//
//								   										UIView utility categories
//																	   Edward Smith, January 2011
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <UIKit/UIKit.h>


extern void ZDebugGlobalEnableDebugViewFrames(BOOL enabled);


@interface UIView (ZLibrary)

- (UIView*) firstResponder;
- (BOOL) 	findAndResignFirstResponder;
- (id) 		findSubviewOfClass:(Class)class_;
- (id) 		findSuperviewOfClass:(Class)class_;
- (UIView*) findSubviewUsingPredicateBlock:(BOOL (^) (UIView* subview))predicateBlock;
- (void) 	performBlockOnSubviewHeirarchy:(void (^) (UIView* subview))block;
- (void) 	performBlockOnSuperviewHeirarchy:(void (^) (UIView* subview))block;

- (UIImage*) image;
- (UIImage*) imageWithSubviews:(BOOL)includeSubviews;

- (CGRect) currentWindowBounds;
- (void) setBackgroundColorPatternNamed:(NSString*)name;
- (UIViewController*) viewController;
- (void) removeAllSubviews;
- (UIColor*) apparentBackgroundColor;

- (void) setDebugShowFrames:(BOOL)on;

@end
