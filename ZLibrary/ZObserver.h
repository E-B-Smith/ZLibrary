//
//  ZObserver.h
//  ZLibrary
//
//  Created by Edward Smith on 5/9/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import <Foundation/Foundation.h>


@interface ZObserver : NSObject
- (void) observeKeyPath:(NSString*)keyPath ofObject:(id)object target:(id)target selector:(SEL)selector;
@end


#pragma mark - ZAutoremoveNotificationObserver


@interface ZAutoremoveNotificationObserver : NSObject

+ (void) observer:(id)object;
+ (void) cancelAutoremoveForObserver:(id)object;

@end
