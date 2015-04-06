//
//  UIWebView+ZLibrary.m
//  ZLibrary
//
//  Created by Edward Smith on 12/17/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


#import "UIWebView+ZLibrary.h"
#import "NSString+ZLibrary.h"
#import "ZDebug.h"


@implementation UIWebView (ZLibrary)

- (NSError*) loadHTMLFromMainBundleWithFileName:(NSString*)name
	{
	NSString* path = [[NSBundle mainBundle]
		pathForResource:name.stringByDeletingPathExtension
		ofType:name.pathExtension];
		
	NSError*error = nil;
	NSString*page = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	if (error)
		ZDebug(@"Error loading HTML from bundle: %@.", error);
	else
		[self loadHTMLString:page baseURL:[NSBundle mainBundle].resourceURL];
	return error;
	}

- (NSError*) loadHTMLFromLocalURL:(NSURL *)URL
	{
	NSError*error = nil;
	NSString*page = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
	if (error)
		ZDebug(@"Error loading HTML from bundle: %@.", error);
	else
		{
		NSURL *baseURL = [URL URLByDeletingLastPathComponent];
		[self loadHTMLString:page baseURL:baseURL];
		}
	return error;
	}

- (void) displayText:(NSString*)rawMessage
	{
	NSString* kBackupHTML =
		@"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">"
		"<html>"
		"<head>"
		"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8;\">"
		"<title>Message</title>"
		"</head>"
		"<body>"
		"<br><br>"
		"<p style=\"text-align:center\">%@</p>"
		"</body>"
		"</html>"
		;
	
	//	Clean the message for HTML --
	
	NSString *message = [rawMessage stringByEncodingXMLCharacters];
	message = [message stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
	
	NSError*  error = nil;
	NSString* page = nil;
	NSString* path = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"html"];
	if (path) page = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	if (!path || !page || error)
		{
		ZDebug(@"Error loading message HTML: %@.", error);
		page = kBackupHTML;
		}
		
	page = [NSString stringWithFormat:page, message];
	[self loadHTMLString:page baseURL:[NSBundle mainBundle].resourceURL];
	}

- (CGSize) documentSize
	{
	//	From JQuery:
	//	D = document;
	//	height = max(
	//		D.body.scrollHeight, D.documentElement.scrollHeight,
	//		D.body.offsetHeight, D.documentElement.offsetHeight,
	//		D.body.clientHeight, D.documentElement.clientHeight);
			
	CGRect f = self.frame;
	BOOL scaleToFit = self.scalesPageToFit;
	
	self.scalesPageToFit = NO;
	self.frame = CGRectMake(0.0, 0.0, 320.0, 1.0);
	
	CGSize size;
	size.height = [[self stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
	
	//	Width will usually return the max width allowed, in this case 320.0.
	//	To get the 'ideal' width, try steping through all elements and finding the right-most coordinate.
	
	//	If the body width is set, this works:
	
	size.width =
		[[self stringByEvaluatingJavaScriptFromString:@"document.body.clientWidth"] floatValue] 	 +
		[[self stringByEvaluatingJavaScriptFromString:@"document.body.style.marginLeftWidth"] floatValue] +
		[[self stringByEvaluatingJavaScriptFromString:@"document.body.style.marginRightWidth"] floatValue]+
		[[self stringByEvaluatingJavaScriptFromString:@"document.body.style.borderLeftWidth"] floatValue] +
		[[self stringByEvaluatingJavaScriptFromString:@"document.body.style.borderRightWidth"] floatValue];
		
	self.scalesPageToFit = scaleToFit;
	self.frame = f;
	
	return size;
	}

- (CGSize) contentSize
	{
	return self.scrollView.contentSize;	//	eDebug - Not reliable?
	}

@end
