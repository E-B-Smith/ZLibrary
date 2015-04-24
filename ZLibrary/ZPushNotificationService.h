//
//  ZPushNotificationService.h
//  ZLibrary
//
//  Created by Edward Smith on 5/3/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import <Foundation/Foundation.h>


extern NSString * const ZPushServiceNotification;


typedef NS_ENUM(NSInteger, ZPushService)
	{
	ZPushServiceProduction	= 0,
	ZPushServiceDevelopment	= 1
	};


#pragma mark - ZPushNotificationMessage


@interface ZPushNotificationMessage : NSObject
@property (strong) NSString *bundleID;
@property (assign) ZPushService pushService;
@property (strong) NSString *deviceToken;
@property (assign) uint32_t notificationID;
@property (strong) NSString *messageText;
@end;


typedef NS_ENUM(NSInteger, ZPushResponseStatus)
	{
	ZPushResponseSuccess 			= 0,
	ZPushResponseProcessingError 	= 1,
	ZPushResponseMissingDeviceToken = 2,
	ZPushResponseMissingTopic		= 3,
	ZPushResponseMissingPayload	    = 4,
	ZPushResponseInvalidTokenSize	= 5,
	ZPushResponseInvalidTopicSize	= 6,
	ZPushResponseInvalidPayloadSize = 7,
	ZPushResponseInvalidToken		= 8,
	ZPushResponseServiceShutdown 	= 10,
	ZPushResponseUnkownError 		= 255
	};


#pragma mark - ZPushNotificationResponse


@interface ZPushNotificationResponse : NSObject
- (NSString*) statusString;
@property (assign) uint8_t	 			command;
@property (assign) ZPushResponseStatus 	status;
@property (assign) uint32_t				notificationID;
@property (strong) ZPushNotificationMessage *message;
@property (strong) NSError				*error;

+ (NSUInteger) rawMessageSizeBytes;
@end


#pragma mark - ZPushNotificationService


@interface ZPushNotificationService : NSObject

+ (ZPushNotificationService*) service;

@property (retain) dispatch_queue_t delegateQueue;							//	If not set then the main queue will be used.
//@property (assign) id<ZPushNotification> delegate;

- (void) sendMessage:(ZPushNotificationMessage*)message;
- (void) close;		//	Blocking: Makes sure all messages are sent.

- (NSInteger) sentMessageCount;
- (NSInteger) totalMessageCount;
- (NSInteger) totalErrorCount;

//	Over-rideable --

- (void) 	postResponse:(ZPushNotificationResponse*)response;				//	Default version sends a notification via default NSNotificationCenter.
- (NSData*) p12CertificateDataForBundleIDAndService:(NSString*)bundleID;	//	Default version reads the data from the main bundle.

@end
