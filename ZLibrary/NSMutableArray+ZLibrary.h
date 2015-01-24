//
//  NSMutableArray+ZLibrary.h
//  Search
//
//  Created by Edward Smith on 5/20/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSMutableArray (ZLibrary)
- (NSUInteger) addUniqueObject:(id)object;						//	Returns the index of the object found or added.
@end
