//
//  ZMutableOrderedDictionary.h
//  Xprt
//
//  Created by Edward Smith on 5/23/16.
//  Copyright © 2016 Blitz Technologies. All rights reserved.
//


#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@interface ZMutableOrderedDictionary<KeyType, ObjectType> : NSMutableDictionary

- (NSUInteger) count;
- (void) removeObjectForKey:(KeyType)aKey;
- (void) setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey;
- (ObjectType) objectForKey:(KeyType)aKey;
- (NSEnumerator<KeyType> *)keyEnumerator;
- (ObjectType)objectAtIndex:(NSUInteger)index;
- (instancetype) init NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

- (void) removeObjectAtIndex:(NSUInteger)index;
- (void) removeLastObject;

- (nullable ObjectType) firstObject;
- (nullable ObjectType) lastObject;

@end
NS_ASSUME_NONNULL_END
