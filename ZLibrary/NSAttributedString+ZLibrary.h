//
//  NSAttributedString+ZLibrary.h
//  Search
//
//  Created by Edward Smith on 12/24/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSAttributedString (ZLibrary)
+ (NSAttributedString*) stringWithImage:(UIImage*)image;
+ (NSAttributedString*) stringWithString:(NSString*)string;
+ (NSAttributedString*) stringByAppendingStrings:(NSAttributedString*)string, ...;
@end
