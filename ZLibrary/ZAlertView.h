//
//  ZAlertView.h
//  ZLibrary-iOS
//
//  Created by Edward Smith on 11/29/13.
//  Copyright (c) 2013 Edward Smith, Inc. All rights reserved.
//


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
