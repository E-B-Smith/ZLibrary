//
//  ZImageColors.m
//  Search
//
//  Created by Edward Smith on 2/13/14.
//  Copyright (c) 2014 Edward Smith, All rights reserved.
//


#import "ZImageColors.h"
#import "UIColor+ZLibrary.h"
#import "ZUtilities.h"
#import "ZDebug.h"


static inline uint32_t moveBits(uint32_t value, int bit, int length, int dest)
	{
	uint32_t mask = ((1 << length) - 1) << (bit - length + 1);
	uint32_t result = (dest < bit) ? (value & mask) >> (bit-dest) : (value & mask) << (dest-bit);
	return result;
	}
/*
static inline uint32_t extractBits(uint32_t value, int bit, int length)
	{
	return moveBits(value, bit, length, length-1);
	}
*/

static int compareFunction(const void*a, const void*b)
	{
	return *(uint32_t*)b - *(uint32_t*)a;
	}


@interface ZImageColors ()
	{
	NSArray *colors;
	}
@end


@implementation ZImageColors

+ (ZImageColors*) imageColorsForImage:(UIImage*)image
	{
	ZImageColors* imageColors = [ZImageColors new];
	imageColors->colors = [self colorsForImage:image];
	return imageColors;
	}

- (NSArray*) topColors
	{
	return colors;
	}

- (NSArray*) closestColors:(UIColor*)color
	{
	NSArray* array = [colors sortedArrayUsingComparator:
		^ NSComparisonResult (id obj1, id obj2)
			{
			CGFloat d1 = [color distanceFromColor:(UIColor*)obj1];
			CGFloat d2 = [color distanceFromColor:(UIColor*)obj2];
			NSComparisonResult result = (d1 < d2) ? NSOrderedAscending : (d1 > d2) ? NSOrderedDescending : NSOrderedSame;
			return result;
			}];
	return array;
	}

+ (NSArray*) colorsForImage:(UIImage*)image
	{
	if (!image) return nil;
	CGSize size = image.size;

	//	Draw the image in the bitmap --

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
	
	UIGraphicsPushContext(context);
	[image drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
	UIGraphicsPopContext();
	
	//	Do a nasty k-mean search for the most used color --
	
	uint32_t* bitmap = CGBitmapContextGetData(context);
	
	#define kBucketCount (1<<12)
		
	uint32_t *wp, p;
	uint32_t buckets[kBucketCount*2];
	
	uint32_t rowWidth = (uint32_t) CGBitmapContextGetBytesPerRow(context);
	ZDebugAssert(rowWidth % sizeof(*wp) == 0);
	rowWidth /= sizeof(*wp);

	//	Number the buckets so we can remember which is which after the sort -- 
	
	memset(buckets, 0, kBucketCount*sizeof(uint32_t)*2);
	for (int i = 0; i < kBucketCount; ++i)
		{
		buckets[i*2+1] = i;
		}
	
	CGPoint kEdge = CGPointMake(5.0, 5.0);

	//	Count up the colors around the edges -- 
	
	for (int i = 0; i < size.height && i < kEdge.y; ++i)
		{
		wp = bitmap + (i * rowWidth);
		for (int j = 0; j < size.width; j+=3)
			{
			p = *wp++;
			if (i > (size.height - kEdge.y) ||
				j < kEdge.x || j > (size.width - kEdge.x))
				{
				int index = moveBits(p, 31, 4, 11) | moveBits(p, 23, 4, 7) | moveBits(p, 15, 4, 3);
				buckets[index*2]++;
				}
			}
		}

/*
	for (int i = 0; i < size.height && i < kEdge.y; ++i)
		{
		wp = bitmap + (i * rowWidth);
		for (int j = 0; j < size.width; j+=3)
			{
			p = *wp++;
			if (i < kEdge.y || i > (size.height - kEdge.y) ||
				j < kEdge.x || j > (size.width - kEdge.x))
				{
				int index = moveBits(p, 31, 4, 11) | moveBits(p, 23, 4, 7) | moveBits(p, 15, 4, 3);
				buckets[index*2]++;
				}
			}
		}

    for (int i = size.height - 1; i > size.height - kEdge.y - 1 && i > 0; --i)
		{
      wp = bitmap + (i * rowWidth);
      for (int j = 0; j < size.width; j+=3)
			{
        p = *wp++;
        if (i < kEdge.y || i > (size.height - kEdge.y) ||
            j < kEdge.x || j > (size.width - kEdge.x))
				{
          int index = moveBits(p, 31, 4, 11) | moveBits(p, 23, 4, 7) | moveBits(p, 15, 4, 3);
          buckets[index*2]++;
				}
			}
		}

    for (int i = 0; i < size.height; i+=3)
		{
      wp = bitmap + (i * rowWidth);
      for (int j = 0; j < size.width && j < kEdge.x; ++j)
			{
        p = *wp++;
        if (i < kEdge.y || i > (size.height - kEdge.y) ||
            j < kEdge.x || j > (size.width - kEdge.x))
				{
          int index = moveBits(p, 31, 4, 11) | moveBits(p, 23, 4, 7) | moveBits(p, 15, 4, 3);
          buckets[index*2]++;
				}
			}
		}

    for (int i = 0; i < size.height; i+=3)
		{
      wp = bitmap + (i * rowWidth);
      for (int j = size.width - 1; j > size.width - kEdge.x - 1 && j > 0; --j)
			{
        p = *wp++;
        if (i < kEdge.y || i > (size.height - kEdge.y) ||
            j < kEdge.x || j > (size.width - kEdge.x))
				{
          int index = moveBits(p, 31, 4, 11) | moveBits(p, 23, 4, 7) | moveBits(p, 15, 4, 3);
          buckets[index*2]++;
				}
			}
		}
*/

/*	uint32_t (^findBestBucket)(uint32_t buckets[]) =
	^ uint32_t (uint32_t buckets[])
		{
		uint32_t *wp = buckets, p;
		int bestBucket = 0, bestBucketCount = 0;
		int length = kBucketCount;
		while (length--)
			{
			p = *wp++;
			if (p > bestBucketCount)
				{
				bestBucketCount = p;
				bestBucket = kBucketCount - length - 1;
				}
			}
		return bestBucket;
		};
*/

	//	Sort by frequency -- 
	
	int s = sizeof(buckets[0])*2;
	qsort(buckets, kBucketCount, s, compareFunction);
	
//	uint32_t hiValue = findBestBucket(buckets);

//	uint32_t hiValue = buckets[1];
//	hiValue =
//		moveBits(hiValue, 11, 4, 31) |
//		moveBits(hiValue,  7, 4, 23) |
//		moveBits(hiValue,  3, 4, 15) ;

	//	Get the top ten -- 
	
	NSMutableArray* array = [NSMutableArray array];
	uint32_t *bp = buckets;
	uint32_t tenpct = size.height * size.width * 0.01;
	for (int i = 0; i < 10; ++i)
		{
		uint32_t p = *(bp+1);
		CGFloat r = (CGFloat) (moveBits(p,  3, 4, 7) + 15) / 255.0;
		CGFloat g = (CGFloat) (moveBits(p,  7, 4, 7) + 15) / 255.0;
		CGFloat b = (CGFloat) (moveBits(p, 11, 4, 7) + 15) / 255.0;
		UIColor* color = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
		ZDebug(@"Top color %d: %d %@.", i, buckets[2*i], color);
		[array addObject:color];
		bp += 2;
		if (*bp < tenpct)
			break;
		}
/*
	memset(buckets, 0, kBucketCount*sizeof(uint32_t));
	for (int i = 0; i < size.height; ++i)
		{
		wp = bitmap + (i * rowWidth);
		for (int j = 0; j < size.width; ++j)
			{
			if ((p & 0xF0F0F000) == hiValue)
				{
				int index = moveBits(p, 27, 4, 11) | moveBits(p, 19, 4, 7) | moveBits(p, 11, 4, 3);
				buckets[index]++;
				}
			}
		}
		
	uint32_t loValue = findBestBucket(buckets);
	loValue =
		moveBits(loValue, 11, 4, 27) |
		moveBits(loValue,  7, 4, 19) |
		moveBits(loValue,  3, 4, 11) ;
	
	uint32_t value = hiValue | loValue;
	

	UIColor* color = [UIColor
		colorWithRed:(CGFloat)extractBits(value, 15, 8)/255.0
		green:(CGFloat)extractBits(value, 23, 8)/255.0
		blue:(CGFloat)extractBits(value, 31, 8)/255.0
		alpha:1.0];
		
	[array setObject:color atIndexedSubscript:0];
*/
	//	Clean up --
	
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
	
	return array;
	}

@end
