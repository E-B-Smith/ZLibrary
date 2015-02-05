//
//  UIWebView+ZLibrary.h
//  Search
//
//  Created by Edward Smith on 12/17/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIWebView (ZLibrary)

- (NSError*) loadHTMLFromMainBundleWithFileName:(NSString*)name;
- (NSError*) loadHTMLFromLocalURL:(NSURL*)URL;
- (void) displayText:(NSString*)message;
- (CGSize) documentSize;
- (CGSize) contentSize;

@end