//
//  NSData+ZLibrary.m
//  ZLibrary
//
//  Created by Edward Smith on 11/15/15.
//  Copyright © 2015 Edward Smith. All rights reserved.
//


#import "NSData+ZLibrary.h"


@implementation NSData (ZLibrary)

- (NSString *) hexString
	{
    NSUInteger bytesCount = self.length;
	if (bytesCount <= 0) return @"";

	const char *hexChars = "0123456789ABCDEF";
	const unsigned char *dataBuffer = self.bytes;
	char *chars = malloc(sizeof(char) * (bytesCount * 2 + 1));
	if (!chars) return @"";
	char *s = chars;
	for (unsigned i = 0; i < bytesCount; ++i)
		{
		*s++ = hexChars[((*dataBuffer & 0xF0) >> 4)];
		*s++ = hexChars[(*dataBuffer & 0x0F)];
		dataBuffer++;
		}
	*s = '\0';

	NSString *hexString = [NSString stringWithUTF8String:chars];
	if (chars) free(chars);
	return hexString;
	}
	
@end
