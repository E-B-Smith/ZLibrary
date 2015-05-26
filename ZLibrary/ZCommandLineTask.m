


//-----------------------------------------------------------------------------------------------
//
//																			   ZCommandLineTask.m
//																					 ZLibrary-Mac
//
//				 A helper class for Cocoa programs that run command line tasks in the background.
//																		Edward Smith, March 2009. 
//
//								 -©- Copyright © 1996-2010 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#if !defined(TARGET_OS_IPHONE)
#import "ZCommandLineTask.h"
#import "ZDebug.h"
#import "ZReadLine.h"



@interface ZCommandLineTask ()
- (void) stdRead:(NSNotification*)n;
- (void) errRead:(NSNotification*)n;
- (void) pipeEOF:(NSNotification*)n;
- (void) taskTerminatedNote:(NSNotification*)n;
- (void) processTaskLine:(NSString*)taskLine;	
- (void) processErrorLine:(NSString*)errorLine;
- (void) taskTerminated:(int)status;
@end



@implementation ZCommandLineTask

@synthesize 
	 delegate
	;
	
- (id) initWithCommandPath:(NSString*)commandLine
			standardInput:(id)inputPipeOrFileHandle
			delegate:(id<ZCommandLineTaskDelegate>)delegate_
	{
	if (!(self = [super init])) return nil;
		
	ZDebug(@"CommandLineTask: %@ Command: %@", self, commandLine);
	ZDebugAssert([NSThread isMainThread]);	//	Must be started on main thread to get notifications.
	
	self.delegate = delegate_;
	
	//	Get the command option array -- 
	
	NSArray* argumentsArray = [ZCommandLineTask splitColumns:commandLine];
	if ([argumentsArray count] == 0)
		{
		ZLog(@"initWithCommand called with empty command line.");
		return nil;
		}
	NSMutableArray* arguments = [NSMutableArray arrayWithArray:argumentsArray];
	NSString* command = [arguments objectAtIndex:0];
	[arguments removeObjectAtIndex:0];
	
	//	Set up the task -- 

	notifiedTaskTerminated = NO;
	task = [[NSTask alloc] init];
	[task setLaunchPath:command];
	[task setArguments:arguments];
	
	//	Add the standard input -- 
	
	if (inputPipeOrFileHandle)
		task.standardInput = inputPipeOrFileHandle;
	
	//	Create a read pipe -- 
	
	stdPipe = [[NSPipe alloc] init];
	[task setStandardOutput:stdPipe];	
	stdLine = [[ZReadLine alloc] initWithSource:(id)stdPipe];
	[stdLine addObserver:self read:@selector(stdRead:) eof:@selector(pipeEOF:)];
	[stdLine startReading];
	
	//	Create a error pipe -- 
	
	errPipe = [[NSPipe alloc] init];
	[task setStandardError:errPipe];
	errLine = [[ZReadLine alloc] initWithSource:(id)errPipe];
	[errLine addObserver:self read:@selector(errRead:) eof:@selector(pipeEOF:)];
	[errLine startReading];
	
	//	Add observer -- 
	
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(taskTerminatedNote:)
		name:NSTaskDidTerminateNotification
		object:task];

	//	Launch -- 
	
	[task launch];
	
	return self;
	}

- (void) dealloc
	{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[terminationTimer invalidate];
	terminationTimer = nil;
	}
	
- (void) stdRead:(NSNotification*)n
	{
	[self processTaskLine:(NSString*)[n userInfo]];
	}
	
- (void) errRead:(NSNotification*)n
	{
	[self processErrorLine:(NSString*)[n userInfo]];
	}
	
- (void) pipeEOF:(NSNotification*)n
	{
	ZReadLine* p = [n object];
	if (p == stdLine)
		stdPipeEOF = true;
	else
	if (p == errLine)
		errPipeEOF = true;
	else
		{
		ZLog(@"Recieved EOF on unknown pipe.");
		}
	[self taskTerminatedNote:nil];
	}
	
- (void) taskTerminatedNote:(NSNotification*)n
	{
	ZDebug(@"Task terminated notification.");
	if (notifiedTaskTerminated)
		{
		[terminationTimer invalidate];
		terminationTimer = nil;
		}
	else
		{
		if ([task isRunning])
			{
			//	Set a call back timer to poll until task terminates.
			//	Needed because 'Task terminated notification' doesn't always work.
			if (!terminationTimer)
				{
				terminationTimer = 
					[NSTimer scheduledTimerWithTimeInterval:0.5 
						target:self 
						selector:@selector(taskTerminatedNote:)
						userInfo:nil
						repeats:YES];
				}
			}
		else
		if (errPipeEOF && stdPipeEOF)
			{
			notifiedTaskTerminated = YES;
			terminationStatusValue = [task terminationStatus];
			[self taskTerminated:terminationStatusValue];
			}
		}
	}
	
- (void) terminateTask
	{
	[task terminate];
	}


//-----------------------------------------------------------------------------------------------
//
//																		 Calling Delegate Methods
//
//-----------------------------------------------------------------------------------------------


- (void) processTaskLine:(NSString*)taskLine
	{
	//	Gets called for each line of output the task sends to stdout --
	ZDebug(@"Task line: %@", taskLine);
	if ([delegate respondsToSelector:@selector(commandLineTask:receivedStandardOutputLine:)])
		[delegate commandLineTask:self receivedStandardOutputLine:taskLine];
	}
	
- (void) processErrorLine:(NSString*)errorLine 
	{
	//	Gets called for each line of output the task sends to stderr --
	ZDebug(@"Error line: %@", errorLine);
	if ([delegate respondsToSelector:@selector(commandLineTask:receivedStandardErrorLine:)])
		[delegate commandLineTask:self receivedStandardErrorLine:errorLine];
	}
	
- (void) taskTerminated:(int)status 
	{
	//	Gets called when task terminates --
	ZDebug(@"Task terminated, status: %d", status);
	if ([delegate respondsToSelector:@selector(commandLineTaskTerminated:)])
		[delegate commandLineTaskTerminated:self];
	}

	
//-----------------------------------------------------------------------------------------------
//
//																				   Data Accessors
//
//-----------------------------------------------------------------------------------------------
	
	
- (int) terminationStatus
	{
	return terminationStatusValue;
	}
	
- (BOOL) isRunning
	{
	return (task && [task isRunning]) ? YES : NO;
	}
	
- (int) lineCount
	{
	return [stdLine lineCount];
	}
	
- (int) errorLineCount
	{
	return [errLine lineCount];
	}
	
+ (NSArray*) splitColumns:(NSString*)line
	{
	NSScanner* scan = [NSScanner scannerWithString:line];
	NSMutableArray* components = [NSMutableArray array];
	NSString* str;
	
	while (![scan isAtEnd])
		{
		[scan scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:NULL];
		[scan scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&str];
		if (str && [str length]) [components addObject:str];
		}
			
	return components;
	}
	
@end
#endif

