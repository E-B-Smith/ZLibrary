


//-----------------------------------------------------------------------------------------------
//
//                                                                   ZWildcardGestureRecognizer.h
//                                                                                   ZLibrary-iOS
//
//                                              A gesture recognizer that recognizes any gesture.
//                                                                    Edward Smith, November 2011
//
//                               -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <UIKit/UIKit.h>


@interface ZWildcardGestureRecognizer : UIGestureRecognizer
- (id) initWithTarget:(id)target action:(SEL)action;
@property (strong) NSArray * excludedViews;
@end
