


//-----------------------------------------------------------------------------------------------
//
//																						 ZDebug.m
//																					 ZLibrary-Mac
//
//														  Simple debug message & assert functions
//																		 Edward Smith, March 2007 
//
//								 -©- Copyright © 1996-2013 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------



#import "ZDebug.h"
#import "NSScanner+ZLibrary.h"


//  Handle ARC --

#if __has_feature(objc_arc)
    #define retain_if_needed(x)			(x)
    #define release_if_needed(x)		(x)
	#define autorelease_if_needed(x)	(x)
#else
    #define retain_if_needed(x)			[x retain]
    #define release_if_needed(x)		[x release]
	#define autorelease_if_needed(x)	[x autorelease]
#endif


#if ZDEBUG

void ZDebugMessageHandlerOutputToLog(NSString* m)
	{
	NSString* text = [m stringByReplacingOccurrencesOfString:@"%" withString:@"%%"];
	NSLog(text, nil);
	}

static NSFileHandle *messageHandlerFile = nil;

void ZDebugMessageHandlerOutputToFile(NSString* m)
	{
	if (messageHandlerFile)
		[messageHandlerFile  writeData:[m dataUsingEncoding:NSUTF8StringEncoding]];
	}

void ZDebugMessageHandlerOutputToFileInitializeWithOutputURL(NSURL* url)
	{
	if (messageHandlerFile)
		{
		[messageHandlerFile closeFile];
		messageHandlerFile = nil;
		}
	if (url)
		{
		NSError *error = nil;
		messageHandlerFile = [NSFileHandle fileHandleForWritingToURL:url error:&error];
		if (error)
			{
			NSLog(@"Error opening debug output file: %@.", error);
			messageHandlerFile = nil;
			}
		}
	}


static ZDebugMessageHandlerProcedurePtr ZDebugMessageHandler = ZDebugMessageHandlerOutputToLog;
static bool ZDebugAssertEnabledBool = true;
static bool ZDebugIsInitialized = false;
bool ZDebugSetBoolean = false;
static NSMutableSet* ZDebugIncludeFiles = nil;
static NSMutableSet* ZDebugExcludeFiles = nil;

	
ZDebugMessageHandlerProcedurePtr ZDebugSetMessageHandler(ZDebugMessageHandlerProcedurePtr NewHandler)
	{
	ZDebugMessageHandlerProcedurePtr Old = ZDebugMessageHandler;
	ZDebugMessageHandler = NewHandler;
	return Old;
	}
	
bool ZDebugEnableAssert(bool Enable)
	{
	bool Last = ZDebugAssertEnabledBool;
	ZDebugAssertEnabledBool = Enable;
	return Last;
	}

bool ZDebugAssertEnabled()
	{
	return ZDebugAssertEnabledBool;
	}
	
bool ZDebugSet(bool OnOff)
	{
	bool last = ZDebugSetBoolean;
	if (OnOff)
		ZDebugSetBoolean = 1;
	else
		ZDebugSetBoolean = 0;
	return last;
	}
	
void ZDebugInitialize()
	{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken,
	^ 	{	
		ZDebugIsInitialized = true;
		ZDebugIncludeFiles = [[NSMutableSet alloc] init];
		ZDebugExcludeFiles = [[NSMutableSet alloc] init];
		NSString* debugOptionString = nil;

		char* p = getenv("ZDebug");
		if (p)
			{
			debugOptionString = [NSString stringWithCString:p encoding:NSMacOSRomanStringEncoding];
			ZDebugSetOptions(debugOptionString);
			}

		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		debugOptionString = [defaults stringForKey:@"ZDebug"];
		if (debugOptionString)
			ZDebugSetOptions(debugOptionString);
		});
	}
	
void ZDebugSetOptions(NSString* debugOptionString)
	{
	if (!ZDebugIsInitialized) ZDebugInitialize();

	@synchronized(ZDebugIncludeFiles) {
	
	NSCharacterSet* delims = [NSCharacterSet characterSetWithCharactersInString:@" ,\n\t\r"];
	NSScanner* scanner = [NSScanner scannerWithString:debugOptionString];
	NSString* token;

	BOOL plusOption = YES;

	while (![scanner isAtEnd])
		{
		[scanner scanCharactersFromSet:delims intoString:NULL];
		if ([scanner isAtEnd])
			break;
		else
		if (scanner.currentCharacter == '+')
			{
			plusOption = YES;
			[scanner nextLocation];
			}
		else
		if (scanner.currentCharacter == '-')
			{
			plusOption = NO;
			[scanner nextLocation];
			}
		else
			{
			[scanner scanUpToCharactersFromSet:delims intoString:&token];
			if (token.length)
				{
				if (NSOrderedSame == [token compare:@"alloff" options:NSCaseInsensitiveSearch])
					[ZDebugIncludeFiles removeAllObjects];
				else
				if (NSOrderedSame == [token compare:@"allon" options:NSCaseInsensitiveSearch])
					{
					[ZDebugIncludeFiles addObject:@"allon"];
					[ZDebugExcludeFiles removeAllObjects];
					}
				else
				if (plusOption)
					[ZDebugIncludeFiles addObject:[token lowercaseString]];
				else
					[ZDebugExcludeFiles addObject:[token lowercaseString]];
				}
			}
		}}
	}
	
void ZDebugMessageProcedure(int debugLevel, const char* file, int lineNumber, NSString* message, ...)
	{
	if (!ZDebugIsInitialized) ZDebugInitialize();
	ZDebugAssert(file && [message isKindOfClass:[NSString class]]);
	NSString* f = [[NSString stringWithCString:file encoding:NSMacOSRomanStringEncoding] lastPathComponent];
	NSString* fileLower = [f lowercaseString];
	if (debugLevel == ZDebugLevelAssert || debugLevel == ZDebugLevelOn)
		{}
	else
	if ([ZDebugIncludeFiles containsObject:@"allon"])
		{}
	else
	if ([ZDebugIncludeFiles containsObject:fileLower])
		{}
	else
		return;
	if ([ZDebugExcludeFiles containsObject:fileLower])
		return;
	va_list args;
	va_start(args, message);		
	NSString* m = autorelease_if_needed([[NSString alloc] initWithFormat:message arguments:args]);
	NSString* s = [NSString stringWithFormat:@"%@(%d): %@", f, lineNumber, m];
	ZDebugMessageHandler(s);
	va_end(args);
	}
	
BOOL ZDebugAssertProcedure(bool condition, const char* file, int lineNumber, const char* conditionString, NSString* messageString)
	{
	if (condition) return YES;
	NSString* s = nil;
	if (messageString)
		s = [NSString stringWithFormat:@"Assertion Failed: Assert that '%s'.\nMessage: %@.", conditionString, messageString];
	else
		s = [NSString stringWithFormat:@"Assertion Failed: Assert that '%s'.", conditionString];
	ZDebugMessageProcedure(ZDebugLevelAssert, file, lineNumber, s);
	return NO;
	}

#endif	//	ZDEBUG

void ZLogProcedure(const char* file, int lineNumber, NSString* message, ...)
	{
	NSString* f = [[NSString stringWithCString:file encoding:NSMacOSRomanStringEncoding] lastPathComponent];
	va_list args;
	va_start(args, message);		
	NSString* m = autorelease_if_needed([[NSString alloc] initWithFormat:message arguments:args]);
	NSString* s = [NSString stringWithFormat:@"%@(%d): %@", f, lineNumber, m];
	NSLog(s, nil);
	va_end(args);
	}
