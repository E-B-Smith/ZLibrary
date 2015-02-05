//
//  UIImage+ZLibrary.m
//  Search
//
//  Created by Edward Smith on 12/9/13.
//  Copyright (c) 2013 Edward Smith, All rights reserved.
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
        ZLog(@"Error from convolution: %ld", error);
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

- (UIImage*) imageSliceAtIndex:(NSInteger)index size:(CGSize)size inset:(CGSize)inset
	{
	CGFloat columns = self.size.width  / size.width;

	CGRect copyRect;
	copyRect.size.width = size.width * self.scale;
	copyRect.size.height = size.height * self.scale;
	inset.height *= self.scale;
	inset.width  *= self.scale;

	copyRect.origin.x = (index % (NSInteger) columns) * copyRect.size.width;
	copyRect.origin.y = (index / (NSInteger) columns) * copyRect.size.height;

	copyRect = CGRectInset(copyRect, inset.width, inset.height);

	CGImageRef cgImage = CGImageCreateWithImageInRect(self.CGImage, copyRect);
	UIImage * imageSlice = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);

	return imageSlice;
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

/*
- (UIImage*) imageTintedWithColor:(UIColor *)color
	{
	UIImage *image = nil;
	CGColorSpaceRef colorSpace = NULL;
	CGContextRef context = NULL;
	
	CGSize size = self.size;
	size.height *= self.scale;
	size.width *= self.scale;
	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
	colorSpace = CGColorSpaceCreateDeviceRGB();
	if (!colorSpace) goto cleanup;
	context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
	if (!context) goto cleanup;
	
//	CGContextScaleCTM(context, 1, -1);
//	CGContextTranslateCTM(context, 0, -size.height);
	CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
	CGContextFillRect(context, rect);
	CGContextSetBlendMode(context, kCGBlendModeOverlay);
	CGContextDrawImage(context, rect, self.CGImage);

	UIGraphicsPushContext(context);	
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsPopContext();
	
cleanup:
	if (colorSpace) CGColorSpaceRelease(colorSpace);
	if (context) CGContextRelease(context);
	return image;
	}
*/

- (UIImage*) imageTintedWithColor:(UIColor *)color
	{
	CGRect rect = CGRectMake(0.0, 0.0, self.size.width*self.scale, self.size.height*self.scale);
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (!context) return nil;
	
	//	Orient the image correctly -- 
	CGContextScaleCTM(context, 1, -1);
	CGContextTranslateCTM(context, 0, -rect.size.height);
	
	//	Set the color -- 
	CGContextSetFillColorWithColor(context, color.CGColor);	
	CGContextFillRect(context, rect);
	
	//	Blend the image -- 
	CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
	CGContextDrawImage(context, rect, self.CGImage);

	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
	}

- (UIImage*) imageWithSize:(CGSize)size
	{
	CGRect rect = CGRectMake(0.0, 0.0, size.width*self.scale, size.height*self.scale);
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (!context) return nil;
	
	//	Orient the image correctly -- 
	CGContextScaleCTM(context, 1, -1);
	CGContextTranslateCTM(context, 0, -rect.size.height);
	
	//	Set the color -- 
	CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
	CGContextFillRect(context, rect);
	CGContextDrawImage(context, rect, self.CGImage);

	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
	}
	
@end