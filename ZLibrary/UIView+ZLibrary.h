


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
- (void) 	applyBlockToSubviewHeirarchy:(void (^) (UIView* subview))block;
- (void) 	applyBlockToSuperviewHeirarchy:(void (^) (UIView* subview))block;

- (UIImage*) image;
- (UIImage*) imageWithSubviews:(BOOL)includeSubviews;

- (CGRect) currentWindowBounds;

- (UIColor*) nextDebugColor;
- (void) setShowDebugFrame:(BOOL)on;
- (void) setShowSubviewDebugFrames:(BOOL)on;

- (void) setBackgroundColorPatternNamed:(NSString*)name;

- (UIViewController*) viewController;

- (void) removeAllSubviews;

@end
