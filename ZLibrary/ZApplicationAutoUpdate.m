


//-----------------------------------------------------------------------------------------------
//
//																		 ZApplicationAutoUpdate.h
//																					 ZLibrary-iOS
//
//							  								Updates an iOS app from server files.
//																	    Edward Smith, August 2011
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZApplicationAutoUpdate.h"
#import "ZDebug.h"
#import "ZBuildInfo.h"
#import "ZAlertView.h"
#import "UIDevice+ZLibrary.h"


#if defined(ZAllowAppStoreNonCompliant)


static const NSInteger kRCAAlertTagID = 0xfeed;


@interface ZApplicationAutoUpdate ()

@property (nonatomic, assign) BOOL forcedUpdate;
@property (nonatomic, copy)	  void (^ askUpdateCompletionHandler) (BOOL willUpdate);
@property (nonatomic, strong) ZApplicationAutoUpdate *myself;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, copy)   void (^completionHandler) (ZApplicationAutoUpdate*);
@property (nonatomic, strong) UIAlertView *alert;

@end


@implementation ZApplicationAutoUpdate

@synthesize 
	 isDone
	,updateIsAvailable
	,request
	,completionHandler
	,updateVersion
	,updateTitle
	,updateManifestURL
	,myself
	,alert
	,error
	;

- (id) init
	{
	self = [super init];
	return self;
	}

- (void) dealloc
	{
	self.alert.delegate = nil;
	[self.alert dismissWithClickedButtonIndex:0 animated:NO];
	self.alert = nil;
	}

- (void) processPListResponse:(NSHTTPURLResponse*)response data:(NSData*)data error:(NSError*)error_
	{
	isDone = YES;
	updateIsAvailable = NO;

	if (!data || error_ || response.statusCode != 200)
		{
		self->error = error_;
		if (!self.error)
			{
			NSInteger code = response.statusCode;
			if (code == 0 || code == 200) code = 204;
 			self->error = [NSError errorWithDomain:NSURLErrorDomain code:code userInfo:nil];
			}
		ZDebug(@"Error checking for app updates: %@.", self.error);
		if (self.completionHandler)
			self.completionHandler(self);
		return;
		}
		
	error = nil;
	NSError* localError = nil;
	id plist = 
		[NSPropertyListSerialization 
			propertyListWithData:data
			options:NSPropertyListImmutable
			format:NULL 
			error:&localError];
	error = localError;
	
	NSDictionary* plistDict = (NSDictionary*) plist;
			
	if (plistDict && [plistDict isKindOfClass:[NSDictionary class]] && !error)
		{}
	else
		{
		ZLog(@"Error checking update plist. Error: %@\nPList: %@ ", error, plist);
		if (self.completionHandler)
			self.completionHandler(self);
		return;
		}
	
	NSDictionary* itemDict = [[plistDict objectForKey:@"items"] objectAtIndex:0];
	if (itemDict && [itemDict isKindOfClass:[NSDictionary class]])
		{}
	else
		{
		ZLog(@"Error checking for app updates. itemDict: %@.", itemDict);
		if (self.completionHandler)
			self.completionHandler(self);
		return;
		}
	
	NSDictionary* metadata = [itemDict objectForKey:@"metadata"];
	if (metadata && [metadata isKindOfClass:[NSDictionary class]])
		{}
	else
		{
		ZLog(@"Error checking for app updates. metadata: %@.", metadata);
		if (self.completionHandler)
			self.completionHandler(self);
		return;
		}
	
	self.updateTitle = [metadata objectForKey:@"title"];
	self.updateVersion = [metadata objectForKey:@"bundle-version"];
	NSString* oldVersion = [ZBuildInfo versionString];
		
	NSArray* assets = [itemDict objectForKey:@"assets"];
	for (NSDictionary* package in assets)
		{
		NSString* kind = [package objectForKey:@"kind"];
		if ([kind isEqualToString:@"software-package"])
			{
			NSString* urlString = [package objectForKey:@"url"];
			self.updateManifestURL =
				[[urlString stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"];
			ZDebug(@"Version %@ found update version %@ at URL %@.",
				oldVersion, self.updateVersion, self.updateManifestURL);
			if (urlString)
				{
				//	If the manifest has a URL for the new package and the
				//	new version is greater than this version, then update --

				NSInteger order =
					[ZBuildInfo compareVersionString:oldVersion withVersionString:self.updateVersion];
				if (order == NSOrderedAscending)
					{
					NSURL *url = [NSURL URLWithString:urlString];
					NSMutableURLRequest *testRequest =
						[NSMutableURLRequest requestWithURL:url
							cachePolicy:NSURLRequestReloadIgnoringCacheData
							timeoutInterval:5.0];
					testRequest.HTTPMethod = @"HEAD";

					ZDebug(@"Checking if server is available for URL %@",url);
					
					NSError *testError = nil;
					NSHTTPURLResponse *response = nil;
					[NSURLConnection sendSynchronousRequest:testRequest
						returningResponse:&response
						error:&testError];

					ZDebug(@"Got server response. Error: %@\nResponse: %@.", testError, response);
					
					if (!testError && response.statusCode == 200)
						{
						updateIsAvailable = YES;
						ZDebug(@"This version: %@, server version: %@. Update is %d.",
							oldVersion, self.updateVersion, updateIsAvailable);
						break;
						}
					}
				}
			}
		}

	if (self.completionHandler)
		self.completionHandler(self);
	}
	
- (void) checkForUpdatesAtURLString:(NSString*)urlString
			completionHandler:(void (^)(ZApplicationAutoUpdate*))handler
	{
	self.completionHandler = handler;
	
	isDone = NO;
	updateIsAvailable = NO;
	self.myself = self;
	
	ZDebug(@"Checking for app update at URL %@.", urlString);
	self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	self.request.cachePolicy =  NSURLRequestReloadIgnoringLocalCacheData;
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
	^ (NSURLResponse *response, NSData *data, NSError *blockError)
		{
		[self processPListResponse:(NSHTTPURLResponse*)response data:data error:blockError];
		self.myself = nil;			
		}];
	}

- (void) installUpdate
	{
	NSString* urlString = 
		[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", updateManifestURL];
	NSURL* url = [NSURL URLWithString:urlString];
	if ([[UIApplication sharedApplication] openURL:url])
		{
		ZAfterSecondsPerformBlock(2.5,
		^	{
			[ZAlertView showAlertWithTitle:nil
				message:@"Your app update is downloading to your home screen."
				dismissBlock:
				^ (ZAlertView *alertView, NSInteger dismissButtonIndex)
					{
					if ([[UIApplication sharedApplication] respondsToSelector:@selector(suspend)])
						{
						ZDebug(@"Suspending for install.");
						[[UIApplication sharedApplication] performSelector:@selector(suspend)];
						}
					else
						ZDebug(@"Suspend not supported!");
					}
				cancelButtonTitle:@"OK"
				otherButtonTitles:nil];
			
			});
		}
	else
		{
		[ZAlertView showAlertWithTitle:nil
			message:@"Sorry, your app can't be updated right now."
			dismissBlock:nil
			cancelButtonTitle:@"OK"
			otherButtonTitles:nil];
		}
	}

- (void) askInstallWithForceUpdate:(BOOL)forcedUpdate
			completion:(void (^) (BOOL willUpdate))askUpdateCompletionHandler;
	{
	self.alert.delegate = nil;
	[self.alert dismissWithClickedButtonIndex:0 animated:NO];
	self.alert = nil;
	
	if ([UIDevice currentDevice].isSimulator)
		{
		ZDebug(@"An update is available but ignored because app is running in the simulator.");
		return;
		}

	NSString *cancelTitle = @"Cancel";
	NSString *okTitle = @"OK";
	
	if (forcedUpdate)
		{
		okTitle = nil;
		cancelTitle = @"OK";
		}

	NSString * message =
		[NSString stringWithFormat:@"A new version of\n%@ is available.\nUpdate your application?",
			self.updateTitle];

	self.alert =
		[[UIAlertView alloc]
			initWithTitle:@"Application Update"
			message:message
			delegate:self 
			cancelButtonTitle:cancelTitle
			otherButtonTitles:okTitle, nil];

	self.myself = self;
	self.forcedUpdate = forcedUpdate;
	self.askUpdateCompletionHandler = askUpdateCompletionHandler;
	self.alert.tag = kRCAAlertTagID;
	[self.alert show];
	}
	
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
	{
	if (self.alert.tag != kRCAAlertTagID)
		return;
			
	if (self.forcedUpdate)
		{
		[self installUpdate];
		[self askInstallWithForceUpdate:YES completion:nil];
		if (self.askUpdateCompletionHandler)
			self.askUpdateCompletionHandler(YES);
		}
	else
		{
		BOOL willInstall = (alertView.cancelButtonIndex != buttonIndex);
		self.alert.delegate = nil;
		self.alert = nil;
		if (willInstall)
			[self installUpdate];
		else
			self.myself = nil;
		if (self.askUpdateCompletionHandler)
			self.askUpdateCompletionHandler(willInstall);
		}
	}

+ (void) checkForUpatesAtURLString:(NSString*)URLString
					   forceUpdate:(BOOL)forceUpdate
			            completion:(void (^) (BOOL willUpdate))completionHandler;
	{
	static ZApplicationAutoUpdate* globalApplicationUpdater = nil;

	dispatch_semaphore_t lock = dispatch_semaphore_create(1);
	dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);

	if (globalApplicationUpdater)
		{
		dispatch_semaphore_signal(lock);
		if (completionHandler)
			completionHandler(NO);
		return;
		}

	globalApplicationUpdater = [ZApplicationAutoUpdate new];
	dispatch_semaphore_signal(lock);

	[globalApplicationUpdater checkForUpdatesAtURLString:URLString completionHandler:
	^ (ZApplicationAutoUpdate* updater)
		{
		if (updater.updateIsAvailable)
			{
			[updater askInstallWithForceUpdate:forceUpdate completion:
			^ (BOOL willInstall)
				{
				if (completionHandler)
					completionHandler(willInstall);
				globalApplicationUpdater = nil;			
				}];
			}
		else
			{
			if (completionHandler)
				completionHandler(NO);
			globalApplicationUpdater = nil;
			}
		 }];
	}

@end


#else	//	! defined(ZAllowAppStoreNonCompliant)


@implementation ZApplicationAutoUpdate

- (instancetype) init
	{
	self = [super init];
	return self;
	}

- (BOOL) isDone					{ return YES; }
- (BOOL) updateIsAvailable		{ return NO; }

- (void) checkForUpdatesAtURLString:(NSString*)string
			      completionHandler:(void (^) (ZApplicationAutoUpdate*))completionHandler
	{
	if (completionHandler)
		completionHandler(self);
	}

- (void) askInstallWithForceUpdate:(BOOL)forcedUpdate
			            completion:(void (^) (BOOL willUpdate))completionHandler
	{
	if (completionHandler)
		completionHandler(NO);
	}


- (void) installUpdate
	{
	}

+ (void) checkForUpatesAtURLString:(NSString*)URLString
					   forceUpdate:(BOOL)forceUpdate
			            completion:(void (^) (BOOL willUpdate))completionHandler
	{
	if (completionHandler)
		completionHandler(NO);
	}

@end

#endif	//	defined(ZAllowAppStoreNonCompliant)

