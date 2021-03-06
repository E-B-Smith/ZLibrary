


//-----------------------------------------------------------------------------------------------
//
//																			  NSString+ZLibrary.m
//																					 	 ZLibrary
//
//								   				  NSString for transforming & formatting strings.
//																	  Edward Smith, November 2013
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "NSString+ZLibrary.h"
#import "NSScanner+ZLibrary.h"
#import "ZUtilities.h"


@implementation NSString (ZLibrary)

- (NSString*) stringByEncodingXMLCharacters
	{
	//	Escape the XML characters:
	//
	//	"   &quot;
	//	'   &apos;
	//	<   &lt;
	//	>   &gt;
	//	&   &amp;


//	NSMutableString* resultString = [[[NSMutableString alloc] init] autorelease];
//	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    NSMutableString* resultString = [NSMutableString new];

	NSScanner* scanner = [NSScanner scannerWithString:self];
	[scanner setCharactersToBeSkipped:nil];
	NSCharacterSet* xmlCharacters = [NSCharacterSet characterSetWithCharactersInString:@"\"'<>&"];
	
	while (!scanner.isAtEnd)
		{
		NSString* string = nil;
		[scanner scanUpToCharactersFromSet:xmlCharacters intoString:&string];
		if (string) [resultString appendString:string];
		
		NSString* escapeString = nil;
		[scanner scanCharactersFromSet:xmlCharacters intoString:&escapeString];
		for (int i = 0; i < escapeString.length; ++i)
			{
			switch ([escapeString characterAtIndex:i])
				{
				case '\"': [resultString appendString:@"&quote;"];	break;
				case '\'': [resultString appendString:@"&apos;"];	break;
				case '<':  [resultString appendString:@"&lt;"];		break;
				case '>':  [resultString appendString:@"&rt;"];		break;
				case '&':  [resultString appendString:@"&amp;"];	break;
				}
			}
		}
		
//	[pool release];
	return resultString;
	}
	
- (BOOL) isEqualInsensitive:(NSString*)string
	{
	return ([self localizedCaseInsensitiveCompare:string] == NSOrderedSame);
	}

- (BOOL) isLike:(NSString *)string
	{
	NSRange range = [self rangeOfString:string options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch];
	return (range.location != NSNotFound);
	}

#if 0
//	Deprecated 

- (NSString*) stringByEncodingWithPercentEscapes
	{
	NSString *newString = (__bridge_transfer NSString*)
        CFURLCreateStringByAddingPercentEscapes(
            kCFAllocatorDefault,
            (CFStringRef)self, 
            NULL, 
            CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`\n\t"), 
            kCFStringEncodingUTF8);
//	[newString autorelease];
	return newString;
	}
#else

- (NSString*) stringByEncodingWithPercentEscapes
	{
	return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	}

#endif 

- (NSString*) stringByDecodingPercentEscapes
	{
	NSString *string = (__bridge_transfer NSString*)
		CFURLCreateStringByReplacingPercentEscapes
			(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""));
//	[string autorelease];
	return string;
	}

- (NSString*) stringByStrippingCharactersInSet:(NSCharacterSet*)characterSet
	{
	NSMutableString* resultString = [NSMutableString stringWithCapacity:self.length];
	NSScanner* scanner = [NSScanner scannerWithString:self];
	
	while (!scanner.isAtEnd)
		{
		NSString* string = nil;
		[scanner scanUpToCharactersFromSet:characterSet intoString:&string];
		if (string) [resultString appendString:string];		
		[scanner scanCharactersFromSet:characterSet intoString:NULL];
		}
		
	return resultString;
	}
	
- (NSString*) stringByKeepingCharactersInSet:(NSCharacterSet*)characterSet
	{
	NSMutableString* resultString = [NSMutableString stringWithCapacity:self.length];
	NSScanner* scanner = [NSScanner scannerWithString:self];
	
	while (!scanner.isAtEnd)
		{
		NSString* string = nil;
		[scanner scanCharactersFromSet:characterSet intoString:&string];
		if (string) [resultString appendString:string];		
		[scanner scanUpToCharactersFromSet:characterSet intoString:NULL];
		}
		
	return resultString;
	}

- (NSString*) stringByTrimmingWhiteSpace
	{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}

- (NSString*) stringByLeftTrimmingWhiteSpace
	{
	NSRange r = [self rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (r.location == 0)
		return [self substringFromIndex:r.length];
	return self;
	}

- (NSString*) stringByEncodingJSONCharacters
	{
	NSCharacterSet* badCharacters = [NSCharacterSet characterSetWithCharactersInString:@"\n\t\r\b\"\'&\f\\"];
	NSScanner* scanner = [NSScanner scannerWithString:self];
	NSMutableString* newString = [NSMutableString string];
	
	while (!scanner.isAtEnd)
		{
		NSString* tempString = nil;
		[scanner scanUpToCharactersFromSet:badCharacters intoString:&tempString];
		[newString appendString:tempString];
		while (!scanner.isAtEnd && [badCharacters characterIsMember:scanner.currentCharacter])
			{
			switch (scanner.currentCharacter)
				{
				case '\n':	[newString appendString:@"\\n"];	break;
				case '\t':	[newString appendString:@"\\t"];	break;
				case '\r':	[newString appendString:@"\\r"];	break;
				case '\b':	[newString appendString:@"\\b"];	break;
				case '\"':	[newString appendString:@"\\\""];	break;
				case '\'':	[newString appendString:@"\\'"];	break;
				case '&':	[newString appendString:@"\\&"];	break;
				case '\f':	[newString appendString:@"\\f"];	break;
				case '\\':	[newString appendString:@"\\\\"];	break;
				default:    break;
				}
			[scanner setScanLocation:scanner.scanLocation+1];
			}
		}
		
	return newString;
	}

- (NSString*)stringByFormattingAsPhoneNumberAndDeletingCharacters:(BOOL)deleting
    {
    NSString* phoneString =
            [self stringByStrippingCharactersInSet:
                    [[NSCharacterSet decimalDigitCharacterSet] invertedSet]];

    //	Prefixed with an 1 or 0 ?

    if (phoneString.length >= 2)
        {
        NSString* firstChar = [phoneString substringToIndex:1];
        if ([firstChar isEqualToString:@"0"] ||
                [firstChar isEqualToString:@"1"])
            phoneString = [phoneString substringFromIndex:1];
        }

    if (phoneString.length < 3 || (phoneString.length <= 3 && deleting))
        {
        return phoneString;
        }
    else
    if (phoneString.length < 6 || (phoneString.length <= 6 && deleting))
        {
        NSString* newString =
                [NSString stringWithFormat:@"(%@) %@",
                                           [phoneString substringWithRange:NSMakeRange(0, 3)],
                                           [phoneString substringFromIndex:3]];
        return newString;
        }
    else
        {
        NSString* newString =
                [NSString stringWithFormat:@"(%@) %@-%@",
                                           [phoneString substringWithRange:NSMakeRange(0, 3)],
                                           [phoneString substringWithRange:NSMakeRange(3, 3)],
                                           [phoneString substringWithRange:NSMakeRange(6, MIN(4, phoneString.length-6))]];
        return newString;
        }
    }

- (NSString*) stringByDecodingStringEscapes
	{
	NSScanner *scanner = [NSScanner scannerWithString:self];
	scanner.charactersToBeSkipped = nil;
	
	NSMutableString *result = [NSMutableString new];
	NSString *s = nil;
	
	while (!scanner.isAtEnd)
		{
		[scanner scanUpToString:@"\\" intoString:&s];
		if (s) [result appendString:s];
		if (!scanner.isAtEnd)
			{
			NSString *t = nil;
			[scanner nextLocation];
			if (scanner.isAtEnd)
				[result appendString:@"\\"];
			else
				{
				switch (scanner.currentCharacter)
					{
					case 'a':	t = @"\a"; break;
					case 'b':	t = @"\b"; break;
					case 'e':	t = @"\e"; break;
					case 'f':	t = @"\f"; break;
					case 'n':	t = @"\n"; break;
					case 'r':	t = @"\f"; break;
					case 't':	t = @"\t"; break;
					case 'v':	t = @"\v"; break;
					
					case '\\':	t = @"\\"; break;
					case '\'':	t = @"\'"; break;
					case '"':	t = @"\""; break;
					case '?':	t = @"?"; break;
					default:	t = [NSString stringWithFormat:@"\\%C", scanner.currentCharacter];
					}
				if (t) [result appendString:t];
				if (!scanner.isAtEnd) [scanner nextLocation];
				}
			}
		}
	
	return result;
	}

- (NSString*) stringFormattedAsPhoneNumberWithBackspace:(BOOL)backspace
	{
	NSString* phoneString =
		[self stringByStrippingCharactersInSet:
			[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];

	//	Prefixed with an 1 or 0 ?

	if (phoneString.length >= 2)
		{
		NSString* firstChar = [phoneString substringToIndex:1];
		if ([firstChar isEqualToString:@"0"] || [firstChar isEqualToString:@"1"])
			phoneString = [phoneString substringFromIndex:1];
		}

	if (phoneString.length < 3 || (phoneString.length <= 3 && backspace))
		{}
	else
	if (phoneString.length < 6 || (phoneString.length <= 6 && backspace))
		{
		phoneString = [NSString stringWithFormat:@"(%@) %@",
			[phoneString substringWithRange:NSMakeRange(0, 3)],
			[phoneString substringFromIndex:3]];
		}
	else
		{
		phoneString =
			[NSString stringWithFormat:@"(%@) %@-%@",
				[phoneString substringWithRange:NSMakeRange(0, 3)],
				[phoneString substringWithRange:NSMakeRange(3, 3)],
				[phoneString substringWithRange:NSMakeRange(6, MIN(4, phoneString.length-6))]];
		}

	return phoneString;
	}

#if TARGET_OS_IOS

- (CGRect) drawingRectForRect:(CGRect)rect withFont:(UIFont*)font lines:(NSInteger)lines
	{
	CGRect r = [self boundingRectWithSize:rect.size
		options:NSStringDrawingUsesLineFragmentOrigin
		attributes:@{ NSFontAttributeName : font }
		context:nil];
	r = ZCenterRectOverRect(r, rect);
	r.origin.x = rect.origin.x;
	return r;
	}

/*
- (CGFloat) fontSizeFillingRect:(CGRect)rect withFont:(UIFont*)font lines:(NSInteger)lines
	{
	//	NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
	//	NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin

	NSAttributedString * as =
		[[NSAttributedString alloc]
			initWithString:self
			attributes:@{ NSFontAttributeName : font }];

	NSStringDrawingContext *context = [NSStringDrawingContext new];
	context.minimumScaleFactor = 0.10;

	CGRect r = [as boundingRectWithSize:rect.size
		options:NSStringDrawingUsesDeviceMetrics
		context:context];

	return floor(context.actualScaleFactor * font.pointSize);
	}
*/

- (CGFloat) fontPointSizeForSize:(CGSize)size font:(UIFont*)font lines:(NSInteger)lines
	{
	CGRect rect = CGRectZero;
	rect.size = size;
	UILabel * label = [[UILabel alloc] initWithFrame:rect];
	label.numberOfLines = lines;
	label.font = font;
	label.text = self;

	CGFloat fontSize = font.pointSize;
	while (fontSize > 8.0)
		{
		CGSize s = CGSizeMake(size.width, 5000.0);
		s = [label sizeThatFits:s];
		if (s.height <= size.height && s.width <= size.width)
			break;
		fontSize -= 1.0;
		label.font = [label.font fontWithSize:fontSize];
		}

	return label.font.pointSize;
	}

#endif

- (NSString*) stringByValidatingEmailAddress
	{
	NSString*email = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSError*error = nil;
	NSRegularExpression *regex =
		[NSRegularExpression regularExpressionWithPattern:@"^.+?@.+?\\..+$" options:0 error:&error];
		
	NSTextCheckingResult* result = [regex firstMatchInString:email options:0 range:NSMakeRange(0, email.length)];
	if (!result  || result.range.location == NSNotFound)
		return nil;
	return email;
	}

@end
