//
//  NSString+ZLibrary.h
//  Search
//
//  Created by Edward Smith on 11/6/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
//


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

- (NSString*) formatAsPhoneNumberWithBackspace:(BOOL)backspace;

//	Measuring strings --

#if TARGET_OS_IPHONE
- (CGRect) drawingRectForRect:(CGRect)rect withFont:(UIFont*)font lines:(NSInteger)lines;
#endif 

@end
