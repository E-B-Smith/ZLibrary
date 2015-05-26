


//-----------------------------------------------------------------------------------------------
//
//																					  ZReadLine.m
//																					 ZLibrary-Mac
//
//							  A shim that read file chunks into whole new-lines delimited chunks.
//																	   Edward Smith, August 2009. 
//
//								 -©- Copyright © 1996-2010 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------



#import "ZReadLine.h"
#import "ZDebug.h"



NSString* const ZReadLineReadNotification	= @"ZReadLineReadNotification";
NSString* const ZReadLineEOFNotification	= @"ZReadLineEOFNotification";


@interface ZReadLine ()
- (void) readDataNote:(NSNotification*)n;
@end 


@implementation ZReadLine

- (instancetype) initWithSource:(id)pipeOrFile;
	{
	self = [super init];
	if (!self) return nil;
	
	inputSource = pipeOrFile;
	NSFileHandle* fh = [inputSource fileHandleForReading];
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	
	[nc addObserver:self 
		selector:@selector(readDataNote:)
		name:NSFileHandleReadCompletionNotification
		object:fh];

	return self;
	}
	
- (void) addObserver:(id)observer read:(SEL)readSelector eof:(SEL)eofSelector
	{	
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	
	[nc addObserver:observer
		selector:readSelector
		name:ZReadLineReadNotification
		object:self];

	[nc addObserver:observer
		selector:eofSelector
		name:ZReadLineEOFNotification
		object:self];
	}
	
- (void) startReading
	{
	NSFileHandle* fh = [inputSource fileHandleForReading];
	[fh readInBackgroundAndNotify];
	}
	
- (void) dealloc
	{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	inputSource = nil;
	}
	
- (void) setResultBuffer:(NSString*)string
	{
	resultBuffer = string;
	}
	
- (NSString*) getNextTaskLine
	{
	NSString* taskLine = nil;
	NSRange r = [resultBuffer rangeOfString:@"\n"];		
	if (r.location != NSNotFound)
		{
		//	Get the next full line -- 
		
		taskLine = [resultBuffer substringToIndex:r.location];
		NSString* temp = [resultBuffer substringFromIndex:(r.location + r.length)];
		[self setResultBuffer:temp];
		}
	return taskLine;
	}
	
- (void) readDataNote:(NSNotification*)n
	{
	ZDebug(@"--");
	NSDictionary* dict = [n userInfo];
	NSData* data = [dict valueForKey:NSFileHandleNotificationDataItem];
	if ([data length] == 0)
		{
		//	Zero length data indicates EOF.  Append a newline to make sure we process the last line --
		
		foundEOF = YES;
		ZDebug(@"Task pipe closed.");
		if (resultBuffer && [resultBuffer length])
			{
			//	Make sure the last line is \n terminated --
						
			unichar c = [resultBuffer characterAtIndex:([resultBuffer length]-1)];
			if (![[NSCharacterSet newlineCharacterSet] characterIsMember:c])

				{
				NSString* temp = [resultBuffer stringByAppendingString:@"\n"];
				[self setResultBuffer:temp];
				}
			}
		}
	else
		{
		//	Add the new data to our string -- 
		NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		ZDebug(@"Task got string %@", dataString);
		if (resultBuffer)
			{
			NSString* temp = [resultBuffer stringByAppendingString:dataString];
			[self setResultBuffer:temp];
			}
		else
			{
			[self setResultBuffer:dataString];
			}
		}
		
//	Check the error out of curiousity -- 
//	
//	NSNumber* error = [dict valueForKey:@"NSFileHandleError"];
//	zDebugMessage(@"Handle error: %@", error);
	
	// Process each full line of data -- 
	
	NSString* taskLine = [self getNextTaskLine];
	while (taskLine)
		{
		++lineCount;
		[[NSNotificationCenter defaultCenter]
			postNotificationName:ZReadLineReadNotification
			object:self
			userInfo:(id)taskLine];
		taskLine = [self getNextTaskLine];
		}
		
	//	Continue reading from pipe or quit -- 
	
	if (foundEOF)
		{
		if (!notifiedEOF)
			{
			[[NSNotificationCenter defaultCenter]
				postNotificationName:ZReadLineEOFNotification
				object:self
				userInfo:nil];
			notifiedEOF = true;
			}
		}
	else
		[[inputSource fileHandleForReading] readInBackgroundAndNotify];
	}
	
- (int) lineCount
	{
	return lineCount;
	}
	
@end
