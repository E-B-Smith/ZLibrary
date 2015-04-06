//
//  NSAttributedString+ZLibrary.m
//  ZLibrary
//
//  Created by Edward Smith on 12/24/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


#import <MobileCoreServices/MobileCoreServices.h>
#import "NSAttributedString+ZLibrary.h"


@implementation NSAttributedString (ZLibrary)

+ (NSAttributedString*) stringWithImage:(UIImage*)image
	{
	NSData *imageData = UIImagePNGRepresentation(image);
	NSTextAttachment* a = [[NSTextAttachment alloc] initWithData:imageData ofType:(__bridge NSString*)kUTTypePNG];
	a.image = image;
//	a.bounds = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
	a.bounds = CGRectMake(-6.0, -2.0, 17.0, 17.0);
	
	NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:a];
	return string;
	}

+ (NSAttributedString*) stringWithString:(NSString *)string
	{
	return [[NSAttributedString alloc] initWithString:string];
	}

+ (NSAttributedString*) stringByAppendingStrings:(NSAttributedString*)string, ...
	{
	va_list list;
	va_start(list, string);
	
	NSMutableAttributedString *result = [NSMutableAttributedString new];
	while (string)
		{
		[result appendAttributedString:string];
		string = va_arg(list, NSAttributedString*);
		}
	
	va_end(list);
	return result;
	}

@end
