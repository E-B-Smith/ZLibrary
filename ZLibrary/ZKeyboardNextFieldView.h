


//-----------------------------------------------------------------------------------------------
//
//																		 ZKeyboardNextFieldView.h
//																					 ZLibrary-iOS
//
//							  		  Adds next/previous/done buttons to the top of the keyboard.
//  												 Expanded from code by Bob Milani on 12/19/12
//																	  Edward Smith, December 2012
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <UIKit/UIKit.h>


//	To use in a view controller, simply add:
//
//		@property (strong, nonatomic) UIView *inputAccessoryView;
//		self.inputAccessoryView = [ZKeyboardNextFieldView new]


@interface ZKeyboardNextFieldView : UIView

@property (nonatomic, strong) NSArray *responders;
@property (nonatomic, assign) BOOL hasDoneButton;

+ (NSArray*) editableTextInputsInView:(UIView*)view;
- (id) initWithResponders:(NSArray*)responders; // Objects must be UIResponder instances
- (void) setHasDoneButton:(BOOL)hasDoneButton animated:(BOOL)animated;
- (void) updateResponders;

@end
