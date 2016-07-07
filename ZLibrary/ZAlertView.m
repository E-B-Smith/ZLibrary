


//-----------------------------------------------------------------------------------------------
//
//																		 			 ZAlertView.m
//																					 ZLibrary-iOS
//
//								   				  					  A UIAlert view with extras.
//																	  Edward Smith, November 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZAlertView.h"


@interface ZAlertView ()
@property (nonatomic, copy) ZAlertViewDismissBlock dismissBlock;
@end


@implementation ZAlertView

+ (ZAlertView*) showAlertWithTitle:(NSString*)title message:(NSString*)message
	{
	ZAlertView* alert =
		[[ZAlertView alloc]
			initWithTitle:title
			message:message
			delegate:nil
			cancelButtonTitle:@"OK"
			otherButtonTitles:nil];
	[alert show];
	return alert;
	}

//	ToDo: Format as a **super**classy** error message.

+ (ZAlertView*) showAlertWithTitle:(NSString *)title error:(NSError*)error
	{
	#ifdef showfullerror

		return [ZAlertView showAlertWithTitle:title message:[NSString stringWithFormat:@"%@", error]];

	#else

		NSString *message = [error localizedDescription];
		if (!message.length)
			message = error.userInfo.description;
		if (!message.length)
			message = error.description;
		return [ZAlertView showAlertWithTitle:title message:message];

	#endif
	}

+ (ZAlertView*) showAlertWithError:(NSError*)error
	{
	return [ZAlertView showAlertWithTitle:@"Error" error:error];
	}

+ (ZAlertView*) showAlertWithTitle:(NSString *)title
					message:(NSString *)message
					dismissBlock:(ZAlertViewDismissBlock)dismissBlock
					cancelButtonTitle:(NSString*)cancelTitle
					otherButtonTitles:(NSString*)otherButtonTitle, ...
	{
	ZAlertView* alertView =
		[[ZAlertView alloc]
			initWithTitle:title
			message:message
			delegate:nil
			cancelButtonTitle:cancelTitle
			otherButtonTitles:nil];
	alertView.dismissBlock = dismissBlock;
	alertView.delegate = alertView;

	va_list otherButtonList;
    va_start(otherButtonList, otherButtonTitle);
	while (otherButtonTitle)
		{
		[alertView addButtonWithTitle:otherButtonTitle];
		otherButtonTitle = va_arg(otherButtonList, NSString*);
		}
    va_end(otherButtonList);

	[alertView show];
	return alertView;
	}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
	{
	if ([alertView isKindOfClass:[ZAlertView class]])
		{
		ZAlertViewDismissBlock dismissBlock = ((ZAlertView*)alertView).dismissBlock;
		if (dismissBlock)
			dismissBlock((ZAlertView*)alertView, buttonIndex);
		alertView.delegate = nil;
		}
	}

@end