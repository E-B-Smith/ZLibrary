//
//  NSException+ZLibrary.m
//  Search
//
//  Created by Edward Smith on 11/11/13.
//  Copyright (c) 2013 Relcy, Inc. All rights reserved.
//


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
