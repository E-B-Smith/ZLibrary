


//-----------------------------------------------------------------------------------------------
//
//																			  NSString+ZLibrary.h
//																					 	 ZLibrary
//
//								   				  NSString for transforming & formatting strings.
//																	  Edward Smith, November 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>


@interface NSString (ZLibrary)

//  For encoding / decoding --

- (NSString*) stringByEncodingWithPercentEscapes;
- (NSString*) stringByDecodingPercentEscapes;

- (NSString*) stringByEncodingXMLCharacters;
- (NSString*) stringByEncodingJSONCharacters;

//- (NSString*) stringByEncodingStringEscapes;
- (NSString*) stringByDecodingStringEscapes;

- (BOOL) isEqualInsensitive:(NSString*)string;
- (BOOL) isLike:(NSString*)string;

- (NSString*) stringByStrippingCharactersInSet:(NSCharacterSet*)characterSet;
- (NSString*) stringByKeepingCharactersInSet:(NSCharacterSet*)characterSet;
- (NSString*) stringByFormattingAsPhoneNumberAndDeletingCharacters:(BOOL)deleting;
- (NSString*) stringByTrimmingWhiteSpace;

- (NSString*) stringFormattedAsPhoneNumberWithBackspace:(BOOL)backspace;

//	Measuring strings --

#if TARGET_OS_IOS
- (CGRect)  drawingRectForRect:(CGRect)rect withFont:(UIFont*)font lines:(NSInteger)lines;
- (CGFloat) fontPointSizeForSize:(CGSize)size font:(UIFont*)font lines:(NSInteger)lines;
#endif 

@end
