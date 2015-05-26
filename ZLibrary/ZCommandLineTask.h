


//-----------------------------------------------------------------------------------------------
//
//																			   ZCommandLineTask.h
//																					 ZLibrary-Mac
//
//				 A helper class for Cocoa programs that run command line tasks in the background.
//																		Edward Smith, March 2009. 
//
//								 -©- Copyright © 1996-2010 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------
//                                                                    
//											ZCommandLineTask                                
//                                                                    
//		 A helper class for Cocoa programs that run command line tasks in the background.
//
//-----------------------------------------------------------------------------------------------


#if !defined(TARGET_OS_IPHONE)
#import <Foundation/Foundation.h>
@class ZReadLine;


@class ZCommandLineTask;
@protocol ZCommandLineTaskDelegate <NSObject>
- (void) commandLineTask:(ZCommandLineTask*)task receivedStandardOutputLine:(NSString*)line;
- (void) commandLineTask:(ZCommandLineTask*)task receivedStandardErrorLine:(NSString*)line;
- (void) commandLineTaskTerminated:(ZCommandLineTask*)task;
@end


@interface ZCommandLineTask : NSObject 
	{
	NSTask* task;
	BOOL notifiedTaskTerminated;
	int terminationStatusValue;
	NSTimer* terminationTimer;
	
	BOOL stdPipeEOF;
	NSPipe* stdPipe;
	ZReadLine* stdLine;
	
	BOOL errPipeEOF;
	NSPipe* errPipe;
	ZReadLine* errLine;
	}

@property (assign) id<ZCommandLineTaskDelegate> delegate;

- (id) initWithCommandPath:(NSString*)command
			standardInput:(id)pipeOrFileHandle
			delegate:(id<ZCommandLineTaskDelegate>)delegate;

- (int) lineCount;					//	Current line count of stdout.
- (int) errorLineCount;				//	Current line count of stderr.
- (int) terminationStatus;
- (BOOL) isRunning;
- (void) terminateTask;

+ (NSArray*) splitColumns:(NSString*)line;	//	Utility function to split output lines.

@end
#endif 
