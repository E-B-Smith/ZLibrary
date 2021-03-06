


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
extern CGRect ZLayoutVerticalInRectWithMargin(CGRect boundingRect, CGFloat margin, ...);


@interface UIView (ZLibrary)

- (UIView*) firstResponder;
- (BOOL) 	findAndResignFirstResponder;
+ (void) 	findAndResignFirstResponder;
- (id) 		findSubviewOfClass:(Class)class_;
- (id) 		findSuperviewOfClass:(Class)class_;
- (id) 		findSubviewUsingPredicateBlock:(BOOL (^) (UIView* subview))predicateBlock;
- (void) 	performBlockOnSubviews:(void (^) (UIView* subview))block;
- (void) 	performBlockOnSuperviews:(void (^) (UIView* subview))block;
- (void)    bringViewToFront;

- (UIImage*) image;
- (UIImage*) imageWithSubviews:(BOOL)includeSubviews;

//- (CGRect) currentWindowBounds;
- (void) setBackgroundColorPatternNamed:(NSString*)name;
- (UIViewController*) viewController;
- (void) removeAllSubviews;
- (UIColor*) apparentBackgroundColor;

- (void) setDebugShowFrames:(BOOL)on;

- (void) addUnderlineWithColor:(UIColor*)color width:(CGFloat)width;

- (UIResponder*) firstTextInputResponder;
- (UIResponder*) nextTextInputResponder;
@end
