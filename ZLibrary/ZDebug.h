


//-----------------------------------------------------------------------------------------------
//
//																						 ZDebug.h
//																					 ZLibrary-Mac
//
//														  Simple debug message & assert functions
//																		 Edward Smith, March 2007
//
//								 -©- Copyright © 1996-2015 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------
//
//											ZDebug.h
//
//
//	To use the ZDebug facility in your code:
//
//		- Include ZDebug.h and ZDebug.m in your project.
//
//		- Define the compile time ZDEBUG in the compiler settings.
//
//			If ZDEBUG is defined in the compiler settings, debug code is included.
//
//			If ZDEBUG is not defined, all the debug code is stripped from the compiled
//			program.  Useful for removing all debug code from the final product.
//
//	To use the ZDebug facility once it's in your code:
//
//		- Use the ZDebugMessage, ZDebugAssert, ZDebugBreakPoint defines as needed.
//
//	By default, no debug messages are emitted until they are enabled.  They can be
//	enabled by:
//
//		- Programatically, by using the ZDebugSet(true) function.
//
//		- Setting the ZDebug environmental variable.
//
//		- Setting the ZDebug key in the user preferences property list.
//
//		- Using the ZDebugSetOptions() function at run time.
//
//	The priority is:
//
//	ZDebugSet(true) turns all debug messages on until ZDebugSet(false) is called.
//	ZDebugSetOptions() at run time overrides ZDebug set in the preferences
//	overides ZDebug set in the environmental varible.
//
//	Debug option lists:
//
//	The function ZDebugSetOptions, the ZDebug preference variable, and the
//	ZDebug environment variable all take a debug option list as a value.
//
//	The values in the list can be 'AllOn', 'AllOff', or the name of the
//	source file that you want to observe debug messages from.
//
//		- To turn on all debugging information at run time:
//			Set environmental variable 'ZDebug' to 'AllOn', e.g.: ZDebug=AllOn
//			or ZDebugSetOptions(@"AllOn");
//
//		- To turn off all debugging information at run time:
//			Set environmental variable 'ZDebug' to 'AllOff', e.g.: ZDebug=AllOff
//			or ZDebugSetOptions(@"AllOff");
//
//		- To turn on file level debugging at run time:
//			Set environmental varible 'ZDebug' to a list of files,
//			e.g.:  ZDebug=Controller.m,FileView.m
//			or ZDebugSetOptions(@"Controller.m,FileView.m");
//
//	Bugs:
//
//		Leaks an NSSet object at end of task.
//
//	Useful run time debugging environmental variables --
//
//	Set DYLD_IMAGE_SUFFIX to _debug to load debug versions of dynamic libraries.
//	Set NSDebugEnabled to YES to enable obj-c debug checks.
//	Set NSZombieEnabled to YES to enable zombies to help catch the referencing of released objects.
//	Set NSAutoreleaseFreedObjectCheckEnabled to YES to catch autorelease problems.
//	Set MallocStackLoggingNoCompact to YES to track and save all memory allocations. Memory intensive.
//
//	Check NSDebug.h for more debug switches.  Check Technical Note TN2124 and TN2239 for more info.
//
//	Good exception breakpoints to set:
//
//		objc_exception_throw
//		NSInternalInconsistencyException
//
//
//	May be helpful for iPhone Simulator: GTM_DISABLE_IPHONE_LAUNCH_DAEMONS 1
//
//	Useful lldb macros (Works after Xcode 5.0):
//
//	   command script import lldb.macosx.heap
//
//	Search the heap for all references to the pointer 0x0000000116e13920:
//
//	   ptr_refs -m 0x0000000116e13920
//
//-----------------------------------------------------------------------------------------------



#import <Foundation/Foundation.h>



#ifdef __cplusplus
extern "C" {
#endif


typedef NS_ENUM(int32_t, ZDebugLevel)
	{
	 ZDebugLevelNone = 0
	,ZDebugLevelDebug
	,ZDebugLevelAssert
	,ZDebugLevelLog
	,ZDebugLevelWarning
	,ZDebugLevelError
	};


extern void ZLogClassDescription(Class class);
//extern void ZLogInstance(id instance);

typedef void (*ZDebugMessageHandlerProcedurePtr)(ZDebugLevel level, NSString* debugString);



#ifdef ZDEBUG	// -------------------------------------------------------------------------------


extern void ZDebugMessageProcedure(ZDebugLevel debugLevel, const char* file, int lineNumber, NSString* message, ...);
extern BOOL ZDebugAssertProcedure(bool assertCondition, const char* file, int lineNumber, const char* conditionString, NSString* messageString);

//	Default log message handlers --
extern void ZDebugMessageHandlerOutputToLog(ZDebugLevel debugLevel, NSString* m);
extern void ZDebugMessageHandlerOutputToFile(ZDebugLevel debugLevel, NSString* m);
extern void ZDebugMessageHandlerOutputToFileInitializeWithOutputURL(NSURL* url);

extern bool ZDebugDebuggerIsAttached();

//	Returns the previous handler.
extern ZDebugMessageHandlerProcedurePtr ZDebugSetMessageHandler(ZDebugMessageHandlerProcedurePtr newHandler);

extern bool ZDebugSetBreakOnAssertEnabled(bool enable);								//	Returns previous enabled value.
extern bool ZDebugBreakOnAssertIsEnabled();

//extern bool ZDebugIsEnabled();
//extern bool ZDebugSetEnabled(bool onOff);											//	Returns previous state of ZDebugIsEnabled().
extern void ZDebugSetOptions(NSString* debugOptions);								//	Set file level debug messages on or off.


#define ZDebug(...)									do  { ZDebugMessageProcedure(ZDebugLevelDebug, __FILE__, __LINE__, __VA_ARGS__); } while (0)

#define ZDebugLogMethodName()						ZDebug(@"%@",  NSStringFromSelector(_cmd))

#define ZDebugLogError(error)						ZDebug(@"Error: %@",  error)

#define ZDebugAssert(condition)						do  { BOOL b = ZDebugAssertProcedure((condition), __FILE__, __LINE__, #condition, nil); \
														if (!b && ZDebugBreakOnAssertIsEnabled()) { ZDebugBreakPoint(); } \
														} while (0)

#define ZDebugAssertWithMessage(condition, message)	do  { BOOL b = ZDebugAssertProcedure((condition), __FILE__, __LINE__, #condition, message); \
														if (!b && ZDebugBreakOnAssertIsEnabled()) { ZDebugBreakPoint(); } \
														} while (0)

#define ZDebugLogFunctionName() 					ZDebug(@"%s", __FUNCTION__)


#define ZDebugBreakPointMessage(...)				do  { ZDebugMessageProcedure(ZDebugLevelError, __FILE__, __LINE__, __VA_ARGS__); \
														ZDebugBreakPoint(); \
														} while (0)

#define ZDebugBreakPoint()							do  { if (ZDebugDebuggerIsAttached()) { ZDebugFlushMessages(); raise(SIGINT); } \
														} while (0)

#define ZDebugFlushMessages()						do {} while (0)


#else	//	not ZDEBUG ---------------------------------------------------------------------------


#define ZDebugMessageProcedure(debugLevel, file, lineNumber, message, ...)		do {} while (0)
#define ZDebugAssertProcedure(condition, file, lineNumber, conditionString)		do {} while (0)

#define ZDebugSetMessageHandler(NewHandler)			NULL
#define ZDebugSetAssertEnabled(Enable)				false

#define ZDebugIsEnabled()							false
#define ZDebugSetEnabled(OnOff)						false
#define ZDebugSetOptions(debugOptions)				/*true*/

#define ZDebug(...)									do {} while (0)
#define ZDebugLogMethodName()							do {} while (0)
#define ZDebugLogError(error)						do {} while (0)
#define ZDebugLogFunctionName()						do {} while (0)
#define ZDebugAssert(Condition)						do {} while (0)
#define ZDebugAssertWithMessage(condition, message)	do {} while (0)
#define ZDebugBreakPointMessage(...)				do {} while (0)
#define ZDebugBreakPoint()							do {} while (0)
#define ZDebugFlushMessages()						do {} while (0)

#endif	//	ZDEBUG --------------------------------------------------------------------------------



extern void ZLogProcedure(const char* file, int lineNumber, NSString* message, ...);
#define ZLog(...)								ZLogProcedure(__FILE__, __LINE__, __VA_ARGS__)



#ifdef __cplusplus
}
#endif
