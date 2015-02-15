//
//  ZKeyChain.h
//  ZLibrary
//
//  Created by Edward Smith on 4/24/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


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
