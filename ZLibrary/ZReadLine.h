


//-----------------------------------------------------------------------------------------------
//
//																					  ZReadLine.h
//																					 ZLibrary-Mac
//
//							  A shim that read file chunks into whole new-lines delimited chunks.
//																	   Edward Smith, August 2009. 
//
//								 -©- Copyright © 1996-2010 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------
//                                                                    
//											ZReadLine                                
//                                                                    
//				A shim that read file chunks into whole new-lines delimited chunks.
//					Notifies the observer of each new-line chunck that arrives.
//							Notifies the observer of end-of-file.
//								Works for files and for pipes.
//
//-----------------------------------------------------------------------------------------------



#import <Foundation/Foundation.h>



extern NSString* const ZReadLineReadNotification;
extern NSString* const ZReadLineEOFNotification;



@interface ZReadLine : NSObject
	{
	int lineCount;
	BOOL foundEOF;
	BOOL notifiedEOF;
	NSString* resultBuffer;
	id inputSource;
	}

- (instancetype) initWithSource:(id)pipeOrFile;
- (void) addObserver:(id)observer read:(SEL)readSelector eof:(SEL)eofSelector;
- (void) startReading;
- (int)  lineCount;

@end
