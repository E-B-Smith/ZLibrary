


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


#import <Foundation/Foundation.h>


@interface ZApplicationAutoUpdate : NSObject

@property (nonatomic, assign, readonly) BOOL isDone;
@property (nonatomic, assign, readonly) BOOL updateIsAvailable;

@property (nonatomic, strong, readonly) NSError* error;

@property (nonatomic, copy) NSString* updateTitle;
@property (nonatomic, copy) NSString* updateVersion;
@property (nonatomic, copy) NSString* updateManifestURL;

- (id)   init;
- (void) checkForUpdatesAtURLString:(NSString*)string
			completionHandler:(void (^) (ZApplicationAutoUpdate*))completionHandler;
- (void) askInstallWithForceUpdate:(BOOL)forcedUpdate
			completion:(void (^) (BOOL willUpdate))completionHandler;
- (void) installUpdate;

+ (void) checkForUpatesAtURLString:(NSString*)URLString forceUpdate:(BOOL)forceUpdate;

@end
