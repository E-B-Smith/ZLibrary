


//-----------------------------------------------------------------------------------------------
//
//																		 			   ZLibrary.h
//																					 ZLibrary-iOS
//
//										   Documentation and precompiled headers for ZLibrary-iOS
//																	  Edward Smith, December 2008
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------
//
//	Compile Time Switches
//	---------------------
//
//	* ZDEBUG
//
//	  Defined to enable debug information.
//	  
//	* ZAllowAppStoreNonCompliant
//
//	  APP_STORE_NON_COMPLIANT( )
//	  
//	  Allow code that is non-Apple app store compliant.
//	  
//-------------------------------------------------------------------------------------------------



#if defined(ZAllowAppStoreNonCompliant)
	#if !DEBUG || PRODUCTION || RELEASE_VERSION
		#warning Compiling production app with ZAllowAppStoreNonCompliant set.
	#endif
	#define APP_STORE_NON_COMPLIANT( x )	x
#else
	#define APP_STORE_NON_COMPLIANT( x )
#endif


#import "ZBuildInfo.h"
#import "ZDebug.h"
#import "ZDrawing.h"
#import "ZLine.h"
#import "ZMath.h"
#import "ZUtilities.h"
