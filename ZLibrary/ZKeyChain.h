


//-----------------------------------------------------------------------------------------------
//
//																		 			  ZKeyChain.h
//																					 ZLibrary-iOS
//
//								   				  					   A KeyChain helper methods.
//																	       Edward Smith, May 2010
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>


@interface ZKeyChain : NSObject

+ (BOOL) securePasswordValue:(id)password
			forPasswordKey:(NSString*)passwordKey
			service:(NSString*)service;

+ (id) securedPasswordValueForPasswordKey:(NSString*)passwordKey
			service:(NSString*)service;

+ (BOOL) deleteSecuredPasswordValueForPasswordKey:(NSString*)passwordKey 
			service:(NSString*)service;
			
@end
