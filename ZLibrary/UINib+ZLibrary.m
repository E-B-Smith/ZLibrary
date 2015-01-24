//
//  UINib+ZLibrary.m
//  Control
//
//  Created by Edward Smith on 5/24/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import "UINib+ZLibrary.h"
#import "ZDebug.h"


@implementation UINib (ZLibrary)

+ (id) loadObjectOfClass:(Class)classin fromNibNamed:(NSString*)nibName bundle:(NSBundle*)bundle
	{
	ZDebugAssert(classin && nibName);
	UINib *nib = [UINib nibWithNibName:nibName bundle:bundle];
	NSArray *nibItems = [nib instantiateWithOwner:nil options:nil];
	for (id item in nibItems)
		{
		if ([item isKindOfClass:classin])
			return item;
		}
	return nil;
	}

+ (id) loadObjectOfClass:(Class)classin
	{
	return [UINib loadObjectOfClass:classin fromNibNamed:NSStringFromClass(classin) bundle:nil];
	}
	
@end
