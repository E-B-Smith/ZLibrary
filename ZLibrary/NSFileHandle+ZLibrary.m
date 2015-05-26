


//-----------------------------------------------------------------------------------------------
//
//																		  NSFileHandle+ZLibrary.m
//																					 ZLibrary-Mac
//
//								   										 NSFileHandle extensions.
//																	       Edward Smith, May 2015
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "NSFileHandle+ZLibrary.h"


@implementation NSFileHandle (ZLibrary)

+ (NSFileHandle*) handleForTemporaryFile
	{
	char *templateCString = NULL;
	NSFileHandle *tempHandle = nil;

	NSString *template = [NSTemporaryDirectory() stringByAppendingPathComponent:@"violent.blue.XXXXXXXX"];
	const char *constTemplateCString = [template fileSystemRepresentation];

	templateCString = (char*) malloc(strlen(constTemplateCString) + 1);
	if (!templateCString) goto exit;

	int fileDescriptor = mkstemp(templateCString);
	if (fileDescriptor == -1) goto exit;

	tempHandle = [[NSFileHandle alloc] initWithFileDescriptor:fileDescriptor closeOnDealloc:NO];

exit:
	if (templateCString) free(templateCString);
	return tempHandle;
	}

- (NSString*) pathname
	{
	NSString *name = nil;
	char filePath[PATH_MAX];
	if (self.fileDescriptor != -1 && fcntl(self.fileDescriptor, F_GETPATH, filePath) != -1)
		name = [[NSString alloc] initWithCString:filePath encoding:NSUTF8StringEncoding];
	return name;
	}

@end

