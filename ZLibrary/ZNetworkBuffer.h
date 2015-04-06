//
//  ZNetworkBuffer.h
//  ZLibrary
//
//  Created by Edward Smith on 5/3/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import <Foundation/Foundation.h>


@interface ZNetworkBuffer : NSObject

- (id) init;
- (id) initWithCapacity:(NSUInteger)capacity;
- (id) initWithData:(NSData*)data copyData:(BOOL)makeCopy;

- (void) putBytes:(const void*)bytes forLength:(NSUInteger)length;
- (void) putUInt8:(uint8_t)v;
- (void) putUInt16:(uint16_t)v;
- (void) putUInt32:(uint32_t)v;
- (void) putData:(NSData*)data;

- (uint8_t)  getUInt8;
- (uint16_t) getUInt16;
- (uint32_t) getUInt32;
- (NSData*)  getDataForMaxLength:(NSUInteger)maxLength;

- (NSData*) data;	//	Reference to raw buffer.  Modify at your peril.
- (NSData*) dataCopy;

- (void) 	appendData:(NSData*)data;

- (void) prepareForWriteOperation;
- (void) compact;
- (void) clear;

@property (assign) NSUInteger limit;
@property (assign) NSUInteger position;
@property (assign, readonly) NSUInteger remaining;
@end
