//
//  ZAlertView.m
//  ZLibrary-iOS
//
//  Created by Edward Smith on 11/29/13.
//  Copyright (c) 2013 Edward Smith, Inc. All rights reserved.
//


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
	return [ZAlertView showAlertWithTitle:title message:[NSString stringWithFormat:@"%@", error]];
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