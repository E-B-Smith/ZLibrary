//
//  ZNetworkBuffer.m
//  Control
//
//  Created by Edward Smith on 5/3/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import "ZNetworkBuffer.h"
#import "ZDebug.h"


const NSUInteger kGrowBytes = 1024;


@interface ZNetworkBuffer ()
	{
	NSMutableData*	data;
	}
@end



@implementation ZNetworkBuffer

- (id) init
	{
	self = [super init];
	return self;
	}
	
- (id) initWithCapacity:(NSUInteger)capacity
	{
	self = [super init];
	if (!self) return self;
	data = [[NSMutableData alloc] initWithCapacity:capacity];
	[self clear];
	return self;
	}

- (id) initWithData:(NSData *)data_ copyData:(BOOL)makeCopy
	{
	self = [super init];
	if (!self) return self;
	if (makeCopy)
		data = [data_ copy];
	else
		data = (NSMutableData*) data_;
	[self clear];
	return self;
	}

- (NSUInteger) remaining
	{
	@synchronized(self)
		{
		return self.limit - self.position;
		}
	}

- (void) prepareForWriteOperation
	{
	self.limit = self.position;
	self.position = 0;
	}

- (void) clear
	{
	self.position = 0;
	self.limit = data.length;
	}

- (NSData*) dataCopy
	{
	return [NSData dataWithBytes:data.bytes+self.position  length:self.remaining];
	}

- (NSData*) data
	{
	return [NSData dataWithBytesNoCopy:data.mutableBytes+self.position length:self.remaining freeWhenDone:NO];
	}

- (void) appendData:(NSData*)appendData
	{
	if (!data)
		{
		data = [[NSMutableData alloc] initWithCapacity:appendData.length+kGrowBytes];
		[self clear];
		}
	else
	if (![data isKindOfClass:[NSMutableData class]])
		ZDebugAssertWithMessage([data isKindOfClass:[NSMutableData class]], @"Mutable data required for append!");
	else
	if (data.length < (self.limit + appendData.length))
		[data increaseLengthBy:(appendData.length + kGrowBytes)];

	memcpy(data.mutableBytes+self.limit, appendData.bytes, appendData.length);
	self.limit += appendData.length;
	}

- (void) compact
	{
	if (!data) return;
	ZDebugAssertWithMessage([data isKindOfClass:[NSMutableData class]], @"Compact unmutable data!");
	memcpy(data.mutableBytes, data.bytes+self.position, self.remaining);
	self.limit = self.remaining;
	self.position = 0;
	}

#pragma mark - Put


- (void) putBytes:(const void*)bytes forLength:(NSUInteger)length
	{
	if (!data)
		{
		data = [[NSMutableData alloc] initWithCapacity:length+kGrowBytes];
		[self clear];
		}
	else
	if (![data isKindOfClass:[NSMutableData class]])
		{
		ZDebugAssertWithMessage([data isKindOfClass:[NSMutableData class]], @"Mutable data required for put!");
		}
	else
	if (data.length < (self.position + length))
		{
		[data increaseLengthBy:(length + kGrowBytes)];
		self.limit = data.length;
		}
	memcpy(data.mutableBytes+self.position, bytes, length);
	self.position += length;
	}

- (void) putUInt8:(uint8_t)v
	{
	[self putBytes:&v forLength:1];
	}

- (void) putUInt16:(uint16_t)v
	{
	uint16_t n = htons(v);
	[self putBytes:&n forLength:sizeof(n)];
	}

- (void) putUInt32:(uint32_t)v
	{
	uint32_t n = htonl(v);
	[self putBytes:&n forLength:sizeof(n)];
	}

- (void) putData:(NSData*)dataIn
	{
	[self putBytes:dataIn.bytes forLength:dataIn.length];
	}


#pragma mark - Get


- (NSUInteger) getBytes:(void*)bytes forMaxLength:(NSUInteger)maxLength
	{
	NSUInteger length = MIN(maxLength, self.remaining);
	memcpy(bytes, data.bytes+self.position, length);
	self.position = self.position + length;
	return length;
	}

- (uint8_t) getUInt8
	{
	uint8_t v = 0;
	[self getBytes:&v forMaxLength:1];
	return v;
	}

- (uint16_t) getUInt16
	{
	uint16_t v = 0;
	[self getBytes:&v forMaxLength:2];
	return ntohs(v);
	}

- (uint32_t) getUInt32
	{
	uint32_t v = 0;
	[self getBytes:&v forMaxLength:4];
	return ntohl(v);
	}

- (NSData*) getDataForMaxLength:(NSUInteger)maxLength
	{
	NSUInteger length = MIN(maxLength, self.remaining);
	NSData * result = [NSData dataWithBytes:data.bytes+self.position length:length];
	self.position = self.position + length;
	return result;
	}

@end
