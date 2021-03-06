


//-----------------------------------------------------------------------------------------------
//
//																		  NSDictionary+ZLibrary.m
//																					     ZLibrary
//
//								   										 NSDictionary extensions.
//																	  Edward Smith, November 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "NSDictionary+ZLibrary.h"
#import "ZDebug.h"


@implementation NSDictionary (ZLibrary)

- (id) objectOfClass:(Class)class forPath:(NSString*)format, ...
	{
	va_list args;
	va_start(args, format);
	NSString *path = [[NSString alloc] initWithFormat:format arguments:args];
	va_end(args);

	id result = self;
	NSString *node = nil;
	NSScanner *scanner = [NSScanner scannerWithString:path];
	NSCharacterSet *terminators = [NSCharacterSet characterSetWithCharactersInString:@".[]"];
	
	[scanner scanUpToCharactersFromSet:terminators intoString:&node];
	while (node && result)
		{
		if ([result isKindOfClass:[NSArray class]])
			{
			if (node.length == [node rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].length)
				{
				NSInteger index = node.integerValue;
				if (index >= 0 && index < [(NSArray*)result count])
					result = result[index];
				else
					result = nil;
				}
			else
				result = nil;
			}
		else
		if ([result isKindOfClass:[NSDictionary class]])
			{
			result = [result valueForKey:node];
			}
			
		node = nil;
		[scanner scanCharactersFromSet:terminators intoString:nil];
		[scanner scanUpToCharactersFromSet:terminators intoString:&node];
		}
	
	if (result)
		{
		if ([result isKindOfClass:class])
			{}
		else
			{
			ZDebug(@"Parsed %@ from dictionary but was expecting %@.", [result class], class);
			result = nil;
			}
		}
	else
		{
		ZDebug(@"Could not find dictionary entry for %@.", path);
		}
		
	return result;
	}

@end
