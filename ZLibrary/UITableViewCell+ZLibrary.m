//
//  UITableViewCell+ZLibrary.m
//  Search
//
//  Created by Edward Smith on 12/5/13.
//  Copyright (c) 2013 Relcy, Inc. All rights reserved.
//


#import "UITableViewCell+ZLibrary.h"
#import "ZDebug.h"


@implementation UITableViewCell (ZLibrary)

- (void) commonInit
	{
	}

+ (UITableViewCell*) cellWithNibName:(NSString*)name
	{
	UINib *nib = [UINib nibWithNibName:name bundle:nil];
	NSArray *nibItems = [nib instantiateWithOwner:nil options:nil];
	for (UITableViewCell *cell in nibItems)
		{
		if ([cell isKindOfClass:[UITableViewCell class]] &&
			[cell.reuseIdentifier isEqualToString:name])
			{
			if ([cell respondsToSelector:@selector(commonInit)])
				[cell commonInit];
			return cell;
			}
		}
	ZDebugAssertWithMessage(NO, @"Cell not found in nib.");
	return nil;
	}

+ (UITableViewCell*) cellForTableView:(UITableView*)tableView
	{
    NSString *cellIdentifier = NSStringFromClass(self);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) cell = [UITableViewCell cellWithNibName:cellIdentifier];
	return cell;
	}

@end
