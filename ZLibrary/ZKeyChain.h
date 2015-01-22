//
//  ZKeyChain.h
//  Search
//
//  Created by Edward Smith on 4/24/14.
//  Copyright (c) 2014 Relcy, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface ZKeyChain : NSObject

+ (void) securePasswordValue:(id)password
			forPasswordKey:(NSString*)passwordKey
			service:(NSString*)service;

+ (id) securedPasswordValueForPasswordKey:(NSString*)passwordKey
			service:(NSString*)service;

@end
