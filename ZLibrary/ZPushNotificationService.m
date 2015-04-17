//
//  ZPushNotificationService.m
//  ZLibrary
//
//  Created by Edward Smith on 5/3/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import "ZPushNotificationService.h"
#import "ZNetworkBuffer.h"
#import "ZDebug.h"
#import "GCDAsyncSocket.h"
#import "dispatch/object.h"


NSString * const ZPushResponseNotification = @"ZPushResponseNotification";
NSString * const ZPushErrorNotification	   = @"ZPushErrorNotification";


const NSTimeInterval kWriteTimeout  = 60.0;
const NSTimeInterval kReadTimeout 	= -1.0;


#pragma mark ZPushNotificationMessage


@implementation ZPushNotificationMessage

- (NSString*) description
	{
	return [NSString stringWithFormat:@"<%@ #%u %@ %@>",
		self.class,
		self.notificationID,
		self.bundleID,
		self.messageText];
	}

@end


#pragma mark - ZPushNotificationResponse


NSString * const ZPushResponseStatusString[11] =
	{
	 @"No errors encountered"// 0
	,@"Processing error"
	,@"Missing device token"
	,@"Missing topic"
	,@"Missing payload"
	,@"Invalid token size"	// 5
	,@"Invalid topic size"
	,@"Invalid payload size"
	,@"Invalid token"
	,@"Unknown error"
	,@"Service shutdown"	// 10
	};


@implementation ZPushNotificationResponse

+ (NSUInteger) rawMessageSizeBytes  { return 6; }

+ (ZPushNotificationResponse*) responseFromBuffer:(ZNetworkBuffer*)buffer
	{
	if (buffer.remaining < ZPushNotificationResponse.rawMessageSizeBytes) return nil;
	ZPushNotificationResponse * response = [ZPushNotificationResponse new];
	response.command = buffer.getUInt8;
	response.status  = buffer.getUInt8;
	response.notificationID = buffer.getUInt32;
	return response;
	}

- (NSString*) statusString
	{
	if (self.status > 10)
		return [NSString stringWithFormat:@"Unknown status %d", self.status];
	else
		return ZPushResponseStatusString[self.status];
	}

- (NSString*) description
	{
	return [NSString stringWithFormat:@"<%@ #%d Command %d. %d:%@ %@ %@>",
				self.class,
				self.notificationID,
				self.command,
				self.status,
				self.statusString,
				self.error,
				self.message];
	}

@end


#pragma mark - ZPushSocket


@interface ZPushSocket : NSObject
@property (strong) NSString *bundleID;
@property (assign) ZPushService service;
@property (strong) ZNetworkBuffer *responseBuffer;
@property (strong) GCDAsyncSocket *socket;
@property (strong) NSError *error;
@end

@implementation ZPushSocket
@end


#pragma mark - ZPushNotificationService


@interface ZPushNotificationService ()
	{
	uint32_t	lastNotificationID;
	NSInteger	sentMessageCount;
	NSInteger	totalMessageCount;
	NSInteger	totalErrorCount;

	NSMutableDictionary *sockets;	//	A dictionary of ZPushSockets, key is socket.
	NSMutableDictionary *messages;	//	ToDo: A dictionary can fill up with un-sent messages.
	}
@end


@implementation ZPushNotificationService

+ (ZPushNotificationService*) service
	{
    static id instance = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^ { instance = self.new; });
    return instance;
	}

- (NSInteger) sentMessageCount 	{ return sentMessageCount; }
- (NSInteger) totalMessageCount	{ return totalMessageCount; }
- (NSInteger) totalErrorCount	{ return totalErrorCount; }

- (void) sendMessage:(ZPushNotificationMessage*)message
	{
	++totalMessageCount;
	if (message.bundleID.length == 0 || message.deviceToken.length == 0)
		{
		ZPushNotificationResponse *response = ZPushNotificationResponse.new;
		response.status = ZPushResponseMissingDeviceToken;
		response.message = message;
		++totalErrorCount;
		[self postResponse:response];
		return;
		}
	
	ZPushSocket* pushSocket = [self socketForBundleID:message.bundleID service:message.pushService];
	if (!pushSocket || pushSocket.error)
		{
		ZPushNotificationResponse *response = ZPushNotificationResponse.new;
		response.status = ZPushResponseUnkownError;
		response.error = pushSocket.error;
		response.message = message;
		++totalErrorCount;
		[self postResponse:response];
		return;
		}
	NSMutableDictionary * payload = [NSMutableDictionary new];

	message.messageText = [message.messageText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (message.messageText.length > 0)
		[payload setObject:message.messageText forKey:@"alert"];

	[payload setObject:@"default" forKey:@"sound"];
	
//	if (badgeCount >= 0)
//		apsMap.put("badge", badgeCount);
//	if (soundName != null && soundName.length() > 0)
//		apsMap.put("sound", soundName);
//	if (contentIsAvailable)
//		apsMap.put("content-available", 1);
//
//	if (apsMap.size() == 0 && (appMap == null || appMap.size() == 0))
//		throw new APNException("No notification payload to send.");
//
//		Map<String, Object> messageMap = new HashMap<String, Object>();
//		messageMap.put("aps", apsMap);
//		if (appMap != null && appMap.size() != 0)
//			messageMap.put("app", appMap);

	NSError*error = nil;
	NSDictionary * dictionary = [NSDictionary dictionaryWithObject:payload forKey:@"aps"];
	NSData* messageBytes = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];

#if ZDEBUG
	NSString *messageString = [[NSString alloc] initWithData:messageBytes encoding:NSUTF8StringEncoding];
	ZDebug(@"APN Message: %@.", messageString);
#endif

	NSData * tokenBytes =
		[[NSData alloc] initWithBase64EncodedString:message.deviceToken options:NSDataBase64DecodingIgnoreUnknownCharacters];

	uint32_t length = (uint32_t) ((5 * 3) + tokenBytes.length + messageBytes.length + 4 + 4 + 1);

	uint32_t notificationID = message.notificationID;
	notificationID = notificationID ?: ++lastNotificationID;
	message.notificationID = notificationID;
	
	NSDate * expirationDate = nil;
	uint32_t epochTime =
		(expirationDate)
		? [expirationDate timeIntervalSince1970]
		: [[NSDate date] timeIntervalSince1970] + 12.0 * 60.0 * 60.0;	//	12 hours.

	ZNetworkBuffer * pushBuffer = [[ZNetworkBuffer alloc] initWithCapacity:300];

	[pushBuffer putUInt8:2];
	[pushBuffer putUInt32:length];

	[pushBuffer putUInt8:1];
	[pushBuffer putUInt16:tokenBytes.length];
	[pushBuffer putData:tokenBytes];
	
	[pushBuffer putUInt8:2];
	[pushBuffer putUInt16:messageBytes.length];
	[pushBuffer putData:messageBytes];
	
	[pushBuffer putUInt8:3];
	[pushBuffer putUInt16:4];
	[pushBuffer putUInt32:notificationID];
	
	[pushBuffer putUInt8:4];
	[pushBuffer putUInt16:4];
	[pushBuffer putUInt32:epochTime];

	[pushBuffer putUInt8:5];
	[pushBuffer putUInt16:1];
	[pushBuffer putUInt8:10];	//	Priority

	[pushBuffer prepareForWriteOperation];
	NSData*data = pushBuffer.dataCopy;

	if (!messages) messages = [NSMutableDictionary new];
	[messages setObject:message forKey:[NSNumber numberWithInteger:notificationID]];

	ZDebug(@"Sending #%d: %d bytes:\n%@.", notificationID, data.length, data);
	[pushSocket.socket writeData:data withTimeout:kWriteTimeout tag:notificationID];
	}


#pragma mark - Overridable


- (void) postResponse:(ZPushNotificationResponse*)response
	{
	//	Default version send notification via NSNotificationCenter --
	ZDebug(@"Posting response: %@.", response);
	[[NSNotificationCenter defaultCenter]
		postNotificationName:ZPushResponseNotification
		object:self
		userInfo:(id)response];
	}

- (NSData*) p12CertificateDataForBundleIDAndService:(NSString*)bundleIDAndService
	{
	//	Default version reads the data from the main bundle.

	NSURL* url = [[NSBundle mainBundle] URLForResource:bundleIDAndService withExtension:@"p12"];
	if (!url)
		{
		ZDebug(@"Can't locate p12 in main bundle.");
		return nil;
		}
	NSData* p12Data = [NSData dataWithContentsOfURL:url];
	if (!p12Data)
		{
		ZDebug(@"Can't open p12 from main bundle.");
		}
	return p12Data;
	}


#pragma mark - Socket


- (ZPushSocket*) socketForBundleID:(NSString*)bundleID service:(ZPushService)service
	{
	NSString * servicename = (service == ZPushServiceProduction) ? @"production" : @"development";
	NSString * keypath = [NSString stringWithFormat:@"%@.%@", bundleID, servicename];
	
	ZPushSocket *pushSocket = [sockets objectForKey:keypath];
	pushSocket.error = nil;
	
	if (pushSocket)
		{
		//	  1 1 => r (n/a)   1 0 => r  0 0 => r  0 1=> c
		if (pushSocket.socket && (pushSocket.socket.isConnected || (!pushSocket.socket.isConnected && !pushSocket.socket.isDisconnected)))
			return pushSocket;
			
		[pushSocket.socket disconnect];
		pushSocket.socket = nil;
		}
	else
		{
		pushSocket = [ZPushSocket new];
		pushSocket.bundleID = bundleID;
		pushSocket.service = service;
		pushSocket.responseBuffer = [[ZNetworkBuffer alloc] initWithCapacity:300];
		[sockets setObject:pushSocket forKey:keypath];
		}
	
	ZDebug(@"Attempting to connect to %@.", keypath);
	
	//	Get our certs for sslOptions in startTLS --
	//
	//	kCFStreamSSLCertificates
	//
	//	Security property key whose value is a CFArray of SecCertificateRefs except for the first element in the array, which is a SecIdentityRef.
	//	For more information, see SSLSetCertificate() in Security/SecureTransport.h.
	//	Available in iOS 2.0 and later.
	//	Declared in CFSocketStream.h.

	//	Create & set the error in case we need it --
	
	NSError * keyFileNotFoundError =
		[NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError
			userInfo:@{ NSFilePathErrorKey: [NSString stringWithFormat:@"%@.p12", keypath]} ];
	pushSocket.error = keyFileNotFoundError;

	NSString * p12Password = @"";
	NSData* p12Data = [self p12CertificateDataForBundleIDAndService:keypath];
	if (!p12Data) return pushSocket;

	NSMutableDictionary* options = [NSMutableDictionary new];
	if (!p12Password) p12Password = @"";
	[options setObject:p12Password forKey:(__bridge NSString*) kSecImportExportPassphrase];
	CFArrayRef importArray = NULL;
	OSStatus status = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef) options, &importArray);
	if (status != errSecSuccess || !importArray)
		{
		ZDebug(@"Can't import p12 file: %d.", status);
		return pushSocket;
		}
	if (CFArrayGetCount(importArray) == 0)
		{
		ZDebug(@"The p12 file was empty.");
		CFRelease(importArray);
		return pushSocket;
		}
	ZDebug(@"Imported %d items: %@.", CFArrayGetCount(importArray), importArray);
	pushSocket.error = nil;

	NSDictionary *importDict = CFArrayGetValueAtIndex(importArray, 0);

	SecIdentityRef identity = (__bridge SecIdentityRef)(importDict[(__bridge id)kSecImportItemIdentity]);
	CFArrayRef	  certChain = (__bridge CFArrayRef)(importDict[(__bridge id)kSecImportItemCertChain]);
	NSMutableArray *certificates = [NSMutableArray array];
	[certificates addObject:(__bridge id)(identity)];
	[certificates addObjectsFromArray:(__bridge NSArray *)(certChain)];

	//	Open the socket --
	
	NSError *error = nil;
	uint16_t  pushPort = 2195;
	NSString *pushHostname =
		(service == ZPushServiceDevelopment) ? @"gateway.sandbox.push.apple.com" : @"gateway.push.apple.com";

	if (self.delegateQueue == nil) self.delegateQueue = dispatch_get_main_queue();
	pushSocket.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.delegateQueue];
	pushSocket.socket.autoDisconnectOnClosedReadStream = NO;
	pushSocket.socket.userData = pushSocket;

	if ([pushSocket.socket connectToHost:pushHostname onPort:pushPort error:&error])
		ZDebug(@"Connecting to %@:%d.", pushHostname, pushPort);
	else
		{
		ZDebug(@"Error connecting: %@", error);
		pushSocket.error = error;
		return pushSocket;
		}

	//	Start the TLS negotiation --

	NSDictionary *sslOptions =
		@{
		GCDAsyncSocketManuallyEvaluateTrust:				@YES,
		(NSString*)kCFStreamSSLCertificates:				certificates
		};
	[pushSocket.socket startTLS:sslOptions];
	[self startReadingSocket:pushSocket];
	
	if (importArray) CFRelease(importArray);
	return pushSocket;
	}

- (void) startReadingSocket:(ZPushSocket*)pushSocket
	{
	[pushSocket.socket readDataWithTimeout:-1.0 tag:0];
	}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
	{
	ZDebug(@"Connected to %@:%d.", host, port);
	}

- (void)socket:(GCDAsyncSocket *)sock 
		didReceiveTrust:(SecTrustRef)trust
	  completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler;
	{
	if (completionHandler)
		completionHandler(YES);
	}
	
- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag
	{
	ZDebug(@"Read %d bytes.", data.length);
	ZPushSocket * pushSocket = socket.userData;
	[pushSocket.responseBuffer appendData:data];

	while (pushSocket.responseBuffer.remaining >= ZPushNotificationResponse.rawMessageSizeBytes)
		{
		ZPushNotificationResponse *response =
			[ZPushNotificationResponse responseFromBuffer:pushSocket.responseBuffer];
		response.message = [messages objectForKey:[NSNumber numberWithInteger:response.notificationID]];
		if (!response.message)
			ZDebug(@"No saved message for notificationID #%d.", response.notificationID);
		if (response)
			{
			if (response.status == ZPushResponseServiceShutdown)
				{
				response.status = ZPushResponseSuccess;
				[pushSocket.socket disconnect];
				}
			if (response.status != ZPushResponseSuccess)
				{
				++totalErrorCount;
				--sentMessageCount;
				}
			[self postResponse:response];
			}
		[messages removeObjectForKey:[NSNumber numberWithInteger:response.notificationID]];
		}
		
	[pushSocket.responseBuffer compact];
	[self startReadingSocket:pushSocket];
	}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
	{
	ZDebug(@"Wrote notification #%d.", tag);
	ZPushNotificationResponse *response = ZPushNotificationResponse.new;
	response.message = [messages objectForKey:[NSNumber numberWithInteger:tag]];
	response.notificationID = (uint32_t) tag;
	++sentMessageCount;
	[self postResponse:response];
	[messages removeObjectForKey:[NSNumber numberWithInteger:response.notificationID]];
	}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
	{
	ZDebug(@"Socket is secured.");
	}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error
	{
//	For debugging only --
//
//	BOOL available = NO;
//	NSNumber * offset = nil;
//
//
//	if (socket.readStream)
//		{
//		available = CFReadStreamHasBytesAvailable(socket.readStream);
//		offset = CFBridgingRelease(CFReadStreamCopyProperty(socket.readStream, kCFStreamPropertyFileCurrentOffset));
//		}
//	ZDebug(@"Socket disconnected: %@. Available: %d Offset: %@.", error, available, offset);
	}

#if 1 

- (void) close
	{
	sleep(2);	//	Works for now.
	}

#else

- (void) close	//	To do.
	{
	//	Send a bogus notification.  When we receive and error back we know all messages have sent.
	
	for (ZPushSocket* pushSocket in sockets.objectEnumerator)
		{
		if (pushSocket.socket.isConnected)
			{
			ZPushNotificationMessage *message = ZPushNotificationMessage.new;
			message.bundleID = pushSocket.bundleID;
			message.pushService = pushSocket.service;
			message.deviceToken = @"12345678=";
			message.notificationID = 12345678;
			message.messageText = @"Goodnight.";
			[self sendMessage:message];
			}
		}
	}

#endif 

@end


