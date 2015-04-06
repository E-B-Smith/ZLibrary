//
//  UINib+ZLibrary.h
//  ZLibrary
//
//  Created by Edward Smith on 5/24/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UINib (ZLibrary)
+ (id) loadObjectOfClass:(Class)classin fromNibNamed:(NSString*)nibName bundle:(NSBundle*)bundle;
+ (id) loadObjectOfClass:(Class)classin;
@end
