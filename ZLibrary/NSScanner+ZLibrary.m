//
//  ZUtilitiesIOS.m
//  ZLib-iPhone
//
//  Created by Edward Smith on 3/7/11.
//  Copyright 2011 Edward Smith, Inc. All rights reserved.
//


#import "NSScanner+ZLibrary.h"


@implementation NSScanner (ZLibrary)

- (BOOL) scanUpToOccurance:(NSInteger)occurance ofString:(NSString*)string intoString:(NSString* __autoreleasing *)result
	{
	NSInteger start = self.scanLocation;
	for (NSInteger i = 0; i < occurance && !self.isAtEnd; ++i)
		{
		self.scanLocation = self.scanLocation + 1;
		[self scanUpToString:string intoString:NULL];
		}
	if (result)
		*result = [self.string substringWithRange:NSMakeRange(start, self.scanLocation - start)];
	return (self.scanLocation > start);
	}

- (unichar) currentCharacter
	{
	return [self.string characterAtIndex:self.scanLocation];
	}

- (void) nextLocation
	{
	self.scanLocation = self.scanLocation + 1;
	}
	
@end
