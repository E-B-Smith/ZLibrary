//
//  UIImage+ZLibrary.m
//  Search
//
//  Created by Edward Smith on 12/9/13.
//  Copyright (c) 2013 Relcy, Inc. All rights reserved.
//


#import <Accelerate/Accelerate.h>
#import "UIImage+ZLibrary.h"
#import "ZDebug.h"


@implementation UIImage (ZLibrary)

+ (UIImage*) imageWithColor:(UIColor*)color
	{
	UIImage *image = nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
	if (context)
		{
		CGContextSetFillColorWithColor(context, color.CGColor);
		CGContextFillRect(context, rect);
		image = UIGraphicsGetImageFromCurrentImageContext();
		}
    UIGraphicsEndImageContext();

    return image;
	}

- (CIImage*) makeCIImage
	{
	CIImage* cImage = self.CIImage;
	if (!cImage) cImage = [CIImage imageWithCGImage:self.CGImage];
	return cImage ?: (id)self.CGImage;
	}

/*
- (UIImage*) imageWithGaussianBlurOfRadius:(CGFloat)radius
	{
	CGRect bufferRect = CGRectMake(0.0f, 0.0f, self.size.width+2.0f*radius, self.size.height+2.0f*radius);
	
    UIGraphicsBeginImageContextWithOptions(bufferRect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, bufferRect);
	
	[self drawInRect:bufferRect];
	[self drawAtPoint:CGPointMake(radius, radius)];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:
		@"inputRadius", [NSNumber numberWithFloat:radius],
		@"inputImage",  image.makeCIImage,
		nil];
	CIImage* cImage = blurFilter.outputImage;
	if (!cImage) return self;

    CIVector *cropVector = [CIVector vectorWithX:radius*self.scale
                                               Y:radius*self.scale
                                               Z:(self.size.width  * self.scale)
                                               W:(self.size.height * self.scale)];

    CIFilter *cropFilter = [CIFilter filterWithName:@"CICrop" keysAndValues:
		@"inputRectangle",		cropVector,
		kCIInputImageKey,		cImage,
		nil];

	cImage = cropFilter.outputImage;
	if (!cImage) return self;

	UIImage *endImage = nil;
	CIContext *ciContext = [CIContext contextWithOptions:nil];
	CGImageRef imageRef = [ciContext createCGImage:cImage fromRect:cImage.extent];
	if (imageRef)
		{
		endImage = [UIImage imageWithCGImage:imageRef];
		CFRelease(imageRef);
		}

	return (endImage) ? endImage : self;
	}
*/

// ------------------------------------------------------------------------------------------

/*
- (UIImage*) imageWithGaussianBlurOfRadius:(CGFloat)radius
	{
	CGFloat scale = (self.scale > 0.0) ? self.scale : 1.0;
	CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width*scale, self.size.height*scale);
	CGRect bufferRect = CGRectMake(0.0f, 0.0f, imageRect.size.width+4.0f*radius, imageRect.size.height+4.0f*radius);
	
    UIGraphicsBeginImageContextWithOptions(bufferRect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, bufferRect);
	
	[self drawAtPoint:CGPointMake(radius*2.0f, radius*2.0f)];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:
		@"inputRadius", [NSNumber numberWithFloat:radius],
		@"inputImage",  image.makeCIImage,
		nil];
	CIImage* cImage = blurFilter.outputImage;
	if (!cImage) return self;

    CIVector *cropVector = [CIVector vectorWithX:radius*2.0f
                                               Y:radius*2.0f
                                               Z:imageRect.size.width
                                               W:imageRect.size.height];

    CIFilter *cropFilter = [CIFilter filterWithName:@"CICrop" keysAndValues:
		@"inputRectangle",		cropVector,
		kCIInputImageKey,		cImage,
		nil];

	cImage = cropFilter.outputImage;
	if (!cImage) return self;

	UIImage *endImage = nil;
	CIContext *ciContext = [CIContext contextWithOptions:nil];
	CGImageRef imageRef = [ciContext createCGImage:cImage fromRect:cImage.extent];
	if (imageRef)
		{
		endImage = [UIImage imageWithCGImage:imageRef];
		CFRelease(imageRef);
		}

	return (endImage) ? endImage : self;
	}
*/


// ------------------------------------------------------------------------------------------


- (UIImage*) imageWithGaussianBlurOfRadius:(CGFloat)blurRadius
	{
	blurRadius = MAX(blurRadius, 0.0);
	blurRadius = MIN(blurRadius, 200.0);
	
    int boxSize = rint(blurRadius);
	if ((boxSize % 2) == 0)
		++boxSize;
    
    CGImageRef rawImage = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(rawImage);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(rawImage);
    inBuffer.height = CGImageGetHeight(rawImage);
    inBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(rawImage) * CGImageGetHeight(rawImage));
        
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(rawImage);
    outBuffer.height = CGImageGetHeight(rawImage);
    outBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    
    error = vImageBoxConvolve_ARGB8888(
			&inBuffer, &outBuffer, NULL,
			0, 0, boxSize, boxSize, NULL,
			kvImageEdgeExtend);
			
    if (error)
		{
        ZLog(@"Error from convolution %ld", error);
    	}
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(
			outBuffer.data,
			outBuffer.width,
			outBuffer.height,
			8,
			outBuffer.rowBytes,
			colorSpace,
			CGImageGetBitmapInfo(self.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return result;
	}

+ (UIImage*) imageNamedR4:(NSString *)name;	//	Tries to load a retina 4 image first if available and appropriate.
	{
	if ([UIScreen mainScreen].bounds.size.height > 480.0)
		{
		NSString * s = name;
		s = [s stringByDeletingPathExtension];
		s = [s stringByAppendingString:@"-568h"];
		UIImage* image = [UIImage imageNamed:s];
		if (image) return image;
		}
	return [UIImage imageNamed:name];
	}

@end
