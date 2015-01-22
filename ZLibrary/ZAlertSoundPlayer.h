


//-----------------------------------------------------------------------------------------------
//
//																			  ZAlertSoundPlayer.h
//																					 ZLibrary-iOS
//
//							  								   Plays an async system alert sound.
//																	    Edward Smith, August 2012
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface ZAlertSoundPlayer : NSObject

//	If filename is nil, the phone will vibrate.
+ (ZAlertSoundPlayer*) alertSoundWithBundleFile:(NSString*)filename;
- (BOOL) play;

@end
