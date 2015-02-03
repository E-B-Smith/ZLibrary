


//-----------------------------------------------------------------------------------------------
//
//																				UIView+ZLibrary.m
//																					 ZLibrary-iOS
//
//								   										UIView utility categories
//																	   Edward Smith, January 2011
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "UIView+ZLibrary.h"


@implementation UIView (ZLibrary)

- (UIView*) findSubviewUsingPredicateBlock:(BOOL (^) (UIView* subview))predicateBlock
	{
	for (UIView* view in self.subviews)
		{
		if (predicateBlock(view))
			return view;
		else
			{
			UIView *foundView = [view findSubviewUsingPredicateBlock:predicateBlock];
			if (foundView) return foundView;
			}
		}
	return nil;
	}	

- (UIView*) firstResponder
	{
    if (self.isFirstResponder) return self;
    for (UIView *subView in self.subviews)
		{
		UIView *v = [subView firstResponder];
		if (v) return v;
		}
	return nil;
	}

- (BOOL) findAndResignFirstResponder
	{
	UIView *v = [self firstResponder];
	[v resignFirstResponder];
	return (v) ? YES : NO;
	}

- (void) subViewUserInteractionEnabled:(BOOL)isEnabled;
	{
	for (UIView* subView in self.subviews)
		{
		subView.userInteractionEnabled = isEnabled;
		}
	}
	
- (id) findSubviewOfClass:(Class)class
	{
	for (UIView* view in self.subviews)
		{
		if ([view isKindOfClass:class])
			return view;
		else
			{
			UIView *foundView = [view findSubviewOfClass:class];
			if (foundView) return foundView;
			}
		}
	return nil;
	}

- (id) findSuperviewOfClass:(Class)class
	{
	UIView* view = self.superview;
	while (view && ![view isKindOfClass:class])
		view = view.superview;
	return view;
	}

- (CGRect) currentWindowBounds
	{
	UIWindow *window = self.window ?: [[UIApplication sharedApplication] keyWindow];
	if (!window) window = [[[UIApplication sharedApplication] windows] firstObject];
	CGRect frame = window.bounds;
	
//	if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
//		{
//		if (![UIApplication sharedApplication].statusBarHidden)
//			frame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
//		}
			
	return frame;
	}

- (UIImage*) imageWithSubviews:(BOOL)includeSubviews
	{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();

	if (includeSubviews && [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
	else
        [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
	}

- (UIImage*) image
	{
	return [self imageWithSubviews:YES];
	}

- (void) applyBlockToSubviewHeirarchy:(void (^) (UIView* subview))block
	{
	block(self);
	for (UIView* view in self.subviews)
		[view applyBlockToSubviewHeirarchy:block];
	}

- (void) applyBlockToSuperviewHeirarchy:(void (^) (UIView* subview))block
	{
	UIView* view = self;
	while (view)
		{
		block(view);
		view = view.superview;
		}
	}

static BOOL globalViewFramesAreEnabled = NO;

void ZDebugGlobalEnableDebugViewFrames(BOOL enabled)
	{
	globalViewFramesAreEnabled = enabled;
	}

- (void) setShowSubviewDebugFrames:(BOOL)on
	{
	#if defined(ZDEBUG)
	
	if (!(on && globalViewFramesAreEnabled)) return;
	[self applyBlockToSubviewHeirarchy:
		^ (UIView *subview) { subview.showDebugFrame = YES; }];
	
	#endif
	}

- (UIColor*) nextDebugColor
	{
	static NSArray *colorArray = nil;
	static NSInteger nextColor = 0;
	
	if (!colorArray)
		{
		colorArray =
			@[
			[UIColor redColor],
			[UIColor blueColor],
			[UIColor greenColor],
			[UIColor purpleColor],
			[UIColor magentaColor]
			];
		}
	
	if (nextColor >= colorArray.count)
		nextColor = 0;

	return (UIColor*)colorArray[nextColor++];
	}

- (void) setShowDebugFrame:(BOOL)on
	{
	#if defined(ZDEBUG)
	
	if (!(on && globalViewFramesAreEnabled)) return;
	self.layer.borderColor = self.nextDebugColor.CGColor;
	self.layer.borderWidth = 1.0;

	#endif
	}

- (UIViewController*) viewController
	{
	if ([self isKindOfClass:[UIViewController class]])
		return (id) self;

	id object = [self nextResponder];
	while (object && object != self && ![object isKindOfClass:[UIViewController class]])
		object = [object nextResponder];
		
	return ([object isKindOfClass:[UIViewController class]]) ? object : nil;
	}

- (void) setBackgroundColorPatternNamed:(NSString*)patternImageName
	{
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:patternImageName]];
	}

- (void) removeAllSubviews
	{
	NSArray * sv = self.subviews.copy;
	for (UIView*v in sv) [v removeFromSuperview];
	}

@end
