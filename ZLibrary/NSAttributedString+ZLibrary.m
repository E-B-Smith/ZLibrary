


//-----------------------------------------------------------------------------------------------
//
//																	NSAttributedString+ZLibrary.m
//																					     ZLibrary
//
//								   				 Categories for working with NSAttributedStrings.
//																	  Edward Smith, December 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <MobileCoreServices/MobileCoreServices.h>
#import "NSAttributedString+ZLibrary.h"


@implementation NSAttributedString (ZLibrary)

+ (NSAttributedString*) stringWithImage:(UIImage*)image
	{
	NSData *imageData = UIImagePNGRepresentation(image);
	NSTextAttachment* a = [[NSTextAttachment alloc] initWithData:imageData ofType:(__bridge NSString*)kUTTypePNG];
	a.image = image;
	a.bounds = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
//	a.bounds = CGRectMake(-6.0, -2.0, 17.0, 17.0);
	
	NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:a];
	return string;
	}

+ (NSAttributedString*) stringWithString:(NSString *)string
	{
	return (string) ? [[NSAttributedString alloc] initWithString:string] : [[NSAttributedString alloc] init];
	}

+ (NSAttributedString*) stringByAppendingStrings:(NSAttributedString*)string, ...
	{
	va_list list;
	va_start(list, string);
	
	NSMutableAttributedString *result = [NSMutableAttributedString new];
	while (string)
		{
		if ([string isKindOfClass:NSAttributedString.class])
			[result appendAttributedString:string];
		else
		if ([string isKindOfClass:NSString.class])		
			[result appendAttributedString:[[NSAttributedString alloc] initWithString:(NSString*)string]];
		else
			[result appendAttributedString:string];
		string = va_arg(list, NSAttributedString*);
		}
	
	va_end(list);
	return result;
	}

@end
