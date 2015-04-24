//
//  ZKeyValueObserver.m
//  ZLibrary
//
//  Created by Edward Smith on 5/9/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import "ZObserver.h"
#import "ZDebug.h"


typedef NS_ENUM(int32_t, ZObserverType)
	{
	 ZObserverTypeKeyValue	   = 1
	,ZObserverTypeNotification = 2
	};


@interface ZObserverClient : NSObject
@property (atomic, retain) id  observeObject;
@property (atomic, retain) NSString* keyPathOrName;
@property (atomic, retain) id  target;
@property (atomic, assign) SEL selector;
@property (atomic, assign) ZObserverType observerType;
@end


@implementation ZObserverClient
@end


#pragma mark -


@interface ZObserver ()
	{
	NSMutableDictionary *clients;
	}
@end


@implementation ZObserver

- (void) dealloc
	{
	for (ZObserverClient* client in clients)
		{
		if (client.observerType == ZObserverTypeKeyValue)
			[client.observeObject removeObserver:self forKeyPath:client.keyPathOrName];
		else
		if (client.observerType == ZObserverTypeNotification)
			[[NSNotificationCenter defaultCenter] removeObserver:self name:client.keyPathOrName object:nil];
		else
			ZDebugBreakPointMessage(@"Invalid value '%d' for observer client %@.", client.observerType, self);
		}
	}

- (void) observeKeyPath:(NSString*)keyPath ofObject:(id)object target:(id)target selector:(SEL)selector
	{
	ZObserverClient *client = [ZObserverClient new];
	client.observerType = ZObserverTypeKeyValue;
	client.observeObject = object;
	client.keyPathOrName = keyPath;
	client.target = target;
	client.selector = selector;
	if (!clients) clients = [NSMutableDictionary new];
	[clients setObject:client forKey:client.keyPathOrName];
	[object addObserver:self forKeyPath:keyPath options:0 context:(void*)client.keyPathOrName];
	}

- (void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
	{
	ZObserverClient *client = [clients objectForKey:(__bridge NSString*)context];
	if (!client) return;

	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	[client.target performSelector:client.selector];
	#pragma clang diagnostic pop
	}

@end
