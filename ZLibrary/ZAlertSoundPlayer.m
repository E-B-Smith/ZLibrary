


//-----------------------------------------------------------------------------------------------
//
//																			  ZAlertSoundPlayer.m
//																					 ZLibrary-iOS
//
//							  								   Plays an async system alert sound.
//																	    Edward Smith, August 2012
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZAlertSoundPlayer.h"
#import "ZDebug.h"


@interface ZAlertSoundPlayer ()
	{
	SystemSoundID soundID;
	}
- (void) alertSoundFinished:(SystemSoundID)soundID;
@property(nonatomic, strong) ZAlertSoundPlayer *keepAlive;
@end


void alertSoundCompletionProcedure(SystemSoundID soundID, void* alertSoundPlayer)
	{
	if (alertSoundPlayer)
		{
		AudioServicesRemoveSystemSoundCompletion(soundID);
		[(__bridge ZAlertSoundPlayer*)alertSoundPlayer alertSoundFinished:soundID];
		}
	}


@implementation ZAlertSoundPlayer

- (id) initWithContentsOfURL:(NSURL*)url
	{
	self = [super init];
	if (!self) return self;
	
	OSStatus error = 0;
	
	if (url == nil)
		soundID = kSystemSoundID_Vibrate;
	else
		{
		error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
		if (error)
			{
			ZLog(@"Error %d while creating system sound ID for %@.", error, url);
			soundID = 0;
			return self;
			}
		}

	return self;
	}

- (void) dealloc
	{
	if (soundID != kSystemSoundID_Vibrate)
		AudioServicesDisposeSystemSoundID(soundID);
	}

+ (ZAlertSoundPlayer*) alertSoundWithBundleResourceName:(NSString *)filename
	{
	NSURL* url = nil;
	if (filename)
		{
		NSString* filePart = [filename stringByDeletingPathExtension];
		NSString* extPart  = [filename pathExtension];
		url = [[NSBundle mainBundle] URLForResource:filePart withExtension:extPart];
		if (!url) 
			{
			ZLog(@"Couldn't find resource %@.", filename);
			return nil;
			}
		}
	ZAlertSoundPlayer* player =
		[[ZAlertSoundPlayer alloc] initWithContentsOfURL:url];
		
	return player;
	}

- (BOOL) play
	{
	if (soundID)
		{
		OSStatus error = AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, alertSoundCompletionProcedure, (__bridge void *)(self));
		if (error)
			ZLog(@"Error setting sound completion: %d.", error);
		else
			{
	        self.keepAlive = self;
			AudioServicesPlayAlertSound(soundID);
			return YES;
			}
		}
	return NO;
	}

- (void) alertSoundFinished:(SystemSoundID)soundID_
	{
	if (soundID == soundID_)
		{
		ZDebug(@"Callback happened: releasing.");
        self.keepAlive = nil;
		}
	}

@end
