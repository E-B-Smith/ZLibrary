

//-----------------------------------------------------------------------------------------------
//
//																						 ZDebug.m
//																					 ZLibrary-Mac
//
//														  Simple debug message & assert functions
//																		 Edward Smith, March 2007 
//
//								 -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZDebug.h"
#import "NSScanner+ZLibrary.h"
#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>
#import <objc/runtime.h>


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

void ZDebugMessageHandlerOutputToLog(ZDebugLevel debugLevel, NSString* m)
	{
	if (debugLevel < ZDebugLevelLog)
		{
		NSString* text = [m stringByReplacingOccurrencesOfString:@"%" withString:@"%%"];
		NSLog(text, nil);
		}
	}

static NSFileHandle *messageHandlerFile = nil;

void ZDebugMessageHandlerOutputToFile(ZDebugLevel debugLevel, NSString* m)
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
	
bool ZDebugSetBreakOnAssertEnabled(bool Enable)
	{
	bool Last = ZDebugAssertEnabledBool;
	ZDebugAssertEnabledBool = Enable;
	return Last;
	}

bool ZDebugBreakOnAssertIsEnabled()
	{
	return ZDebugAssertEnabledBool;
	}
	
bool ZDebugSetEnabled(bool OnOff)
	{
	bool last = ZDebugSetBoolean;
	if (OnOff)
		ZDebugSetBoolean = 1;
	else
		ZDebugSetBoolean = 0;
	return last;
	}

bool ZDebugIsEnabled()
	{
	return ZDebugSetBoolean;
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
	
void ZDebugMessageProcedure(ZDebugLevel debugLevel, const char* file, int lineNumber, NSString* message, ...)
	{
	if (!ZDebugIsInitialized) ZDebugInitialize();
	ZDebugAssert(file && [message isKindOfClass:[NSString class]]);
	NSString* f = [[NSString stringWithCString:file encoding:NSMacOSRomanStringEncoding] lastPathComponent];
	NSString* fileLower = [f lowercaseString];
	if (debugLevel == ZDebugLevelAssert || debugLevel > ZDebugLevelNone)
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
	if (ZDebugMessageHandler) ZDebugMessageHandler(debugLevel, s);
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

#else	//	else ! ZDEBUG

static ZDebugMessageHandlerProcedurePtr ZDebugMessageHandler = NULL;

#endif	//	ZDEBUG


void ZLogProcedure(const char* file, int lineNumber, NSString* message, ...)
	{
	NSString* f = [[NSString stringWithCString:file encoding:NSMacOSRomanStringEncoding] lastPathComponent];
	va_list args;
	va_start(args, message);		
	NSString* m = autorelease_if_needed([[NSString alloc] initWithFormat:message arguments:args]);
	NSString* s = [NSString stringWithFormat:@"%@(%d): %@", f, lineNumber, m];
	if (ZDebugMessageHandler) ZDebugMessageHandler(ZDebugLevelLog, s);
	NSLog(s, nil);
	va_end(args);
	}


bool ZDebugDebuggerIsAttached()
	{
	//	From an Apple tech note that I've lost --EB Smith

    //	Returns true if the current process is being debugged (either
    //	running under the debugger or has a debugger attached post facto).

    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;

    //	Initialize the flags so that, if sysctl fails for some bizarre
    //	reason, we get a predictable result.

    info.kp_proc.p_flag = 0;

    //	Initialize mib, which tells sysctl the info we want, in this case
    // 	we're looking for information about a specific process ID.

    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();

    //	Call sysctl.

    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);

    //	We're being debugged if the P_TRACED flag is set.

    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
	}


void ZLogClassDescription(Class class)
	{
	//	Dump the class --

	if (!class)
		{
		ZLog(@"Class Dump: Class is nil.");
		return;
		}

	const char* superclassname = "nil";
	Class superclass = class_getSuperclass(class);
	if (superclass) superclassname = class_getName(superclass);
	if (!superclassname) superclassname = "<nil>";

	ZLog(@"Class '%s' of class '%s':", class_getName(class), superclassname);

	uint count = 0;
	Method *methods = class_copyMethodList(object_getClass(class), &count);
	for (int i = 0; i < count; ++i)
		ZLog(@"Class method name: '%s'", sel_getName(method_getName(methods[i])));
	if (methods) free(methods);

	count = 0;
	methods = class_copyMethodList(class, &count);
	for (int i = 0; i < count; ++i)
		ZLog(@"Method name: '%s'", sel_getName(method_getName(methods[i])));
	if (methods) free(methods);

	count = 0;
	Ivar *ivars = class_copyIvarList(class, &count);
	for (int i = 0; i < count; ++i)
		ZLog(@"Ivar name: '%s'.", ivar_getName(ivars[i]));
	if (ivars) free(ivars);

	count = 0;
	objc_property_t *properties = class_copyPropertyList(class, &count);
	for (int i = 0; i < count; ++i)
		ZLog(@"Property name: '%s'.", property_getName(properties[i]));
	if (properties) free(properties);
	}

/*
void ZLogInstance(id<NSObject> instance)
	{
	//	Dump the class --

	if (!instance)
		{
		ZLog(@"ZLogInstance: Instance is nil.");
		return;
		}

	const char* superclassname = "nil";
	Class class = instance.class;	
	Class superclass = class_getSuperclass(class);
	if (superclass) superclassname = class_getName(superclass);
	if (!superclassname) superclassname = "<nil>";

	ZLog(@"Object %p is class '%s' of class '%s':", instance, class_getName(class), superclassname);


	uint count = 0;
	Method *methods = class_copyMethodList(object_getClass(class), &count);
	for (int i = 0; i < count; ++i)
		ZLog(@"Class method name: '%s'", sel_getName(method_getName(methods[i])));
	if (methods) free(methods);

	count = 0;
	methods = class_copyMethodList(class, &count);
	for (int i = 0; i < count; ++i)
		ZLog(@"Method name: '%s'", sel_getName(method_getName(methods[i])));
	if (methods) free(methods);

	#define isTypeOf(encoding, type)   (strncmp(encoding, @encode(type), strlen(encoding)) == 0)

	count = 0;
	Ivar *ivars = class_copyIvarList(class, &count);
	for (int i = 0; i < count; ++i)
		{
		const char* encoding = ivar_getTypeEncoding(ivars[i]);
		if (isTypeOf(encoding, id))
			ZLog(@"Ivar '%s' value %@.", ivar_getName(ivars[i]), object_getIvar(instance, ivars[i]));
		else
		if (isTypeOf(encoding, float) || isTypeOf(encoding, double))
			ZLog(@"Ivar '%s' value %f.", ivar_getName(ivars[i]), ((double*) object_getIvar(instance, ivars[i])));
		else
		if (*encoding == @encode(<#type-name#>))
		}
	if (ivars) free(ivars);

	count = 0;
	objc_property_t *properties = class_copyPropertyList(class, &count);
	for (int i = 0; i < count; ++i)
		ZLog(@"Property name: '%s'.", property_getName(properties[i]));
	if (properties) free(properties);
	}	
*/
