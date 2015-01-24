//
//  UITableViewCell+ZLibrary.h
//  Search
//
//  Created by Edward Smith on 12/5/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UITableViewCell (ZLibrary)

+ (id) cellWithNibName:(NSString*)name;
+ (id) cellForTableView:(UITableView*)tableView;

@end
