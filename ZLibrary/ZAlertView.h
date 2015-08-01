


//-----------------------------------------------------------------------------------------------
//
//																		 			 ZAlertView.h
//																					 ZLibrary-iOS
//
//								   				  					  A UIAlert view with extras.
//																	  Edward Smith, November 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <UIKit/UIKit.h>
@class ZAlertView;


typedef void (^ ZAlertViewDismissBlock) (ZAlertView* alertView, NSInteger dismissButtonIndex);


@interface ZAlertView : UIAlertView

+ (ZAlertView*) showAlertWithTitle:(NSString*)title message:(NSString*)message;
+ (ZAlertView*) showAlertWithTitle:(NSString*)title error:(NSError*)error;
+ (ZAlertView*) showAlertWithError:(NSError*)error;

+ (ZAlertView*) showAlertWithTitle:(NSString*)title
					       message:(NSString *)message
					  dismissBlock:(ZAlertViewDismissBlock)dismissBlock
				 cancelButtonTitle:(NSString*)cancelTitle
				 otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
