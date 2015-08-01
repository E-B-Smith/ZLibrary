


//-----------------------------------------------------------------------------------------------
//
//																		   NSException+ZLibrary.m
//																					     ZLibrary
//
//								   										  NSException extensions.
//																	  Edward Smith, November 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "NSException+ZLibrary.h"


@implementation NSException (ZLibrary)

- (NSError*) error
	{
	return [NSError errorWithDomain:NSCocoaErrorDomain code:1 userInfo:
		@{
		NSLocalizedDescriptionKey : self.reason,
		NSUnderlyingErrorKey : self.name,
		NSLocalizedFailureReasonErrorKey : self.description
		}];
	}

@end
