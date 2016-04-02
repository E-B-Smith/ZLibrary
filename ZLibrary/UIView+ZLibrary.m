


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
#import "CALayer+ZLibrary.h"


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

- (void) bringViewToFront
	{
	[self.superview bringSubviewToFront:self];
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

/*
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
*/

- (UIImage*) imageWithSubviews:(BOOL)includeSubviews
	{
	UIImage *image = nil;
	if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) return image;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();	
	if (context)
		{
		if (includeSubviews && [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
			[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
		else
			[self.layer renderInContext:context];
		image = UIGraphicsGetImageFromCurrentImageContext();
		}
	UIGraphicsEndImageContext();
    return image;
	}

- (UIImage*) image
	{
	return [self imageWithSubviews:YES];
	}

- (void) performBlockOnSubviews:(void (^) (UIView* subview))block
	{
	block(self);
	for (UIView* view in self.subviews)
		[view performBlockOnSubviews:block];
	}

- (void) performBlockOnSuperviews:(void (^) (UIView* subview))block
	{
	UIView* view = self;
	while (view)
		{
		block(view);
		view = view.superview;
		}
	}

static BOOL globalDebugViewFramesAreEnabled = NO;

void ZDebugGlobalEnableDebugViewFrames(BOOL enabled)
	{
	globalDebugViewFramesAreEnabled = enabled;
	}

- (void) setDebugShowFrames:(BOOL)on
	{
	#if defined(ZDEBUG)
	
	if (!(on && globalDebugViewFramesAreEnabled)) return;
	[self performBlockOnSubviews:
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
	
	if (!(on && globalDebugViewFramesAreEnabled)) return;
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
/*
- (UIColor*) apparentBackgroundColor
	{
	UIView *view = self;
	while (view)
		{
		UIColor *backgroundColor = view.backgroundColor;
		CGFloat r,g,b,a;
		[backgroundColor getRed:&r green:&g blue:&b alpha:&a];
		tr = ( (tr * ta) + (r * a) ) / 2.0
		if (a >= 1.0) break;
		view = view.superview;
		}
	return [UIColor whiteColor];
	}
*/

- (UIColor*) apparentBackgroundColor
	{
	UIColor * color = nil;
	UIView *view = self;
	while (view)
		{
		CGFloat r,g,b,a;
		color = view.backgroundColor;
		[color getRed:&r green:&g blue:&b alpha:&a];
		if (a >= 0.5) break;
		view = view.superview;
		}
	return color;
	}

- (void) addUnderlineWithColor:(UIColor*)color width:(CGFloat)width
	{
	ZBorderLayer *underline =
		[ZBorderLayer borderWithEdges:UIRectEdgeBottom
			color:color.CGColor
			width:width];
	[self.layer addSublayer:underline];
	[underline setNeedsLayout];
	}


#pragma mark - Find the next text input


- (NSArray<UIResponder*>*) editableTextInputsInView
	{
	NSMutableArray *textInputs = [NSMutableArray new];
	for (UIView *subview in self.subviews)
		{
		BOOL isTextField = [subview isKindOfClass:[UITextField class]];
		BOOL isEditableTextView = [subview isKindOfClass:[UITextView class]] && [(UITextView *)subview isEditable];
		if (isTextField || isEditableTextView)
			[textInputs addObject:subview];
		else
			[textInputs addObjectsFromArray:[subview editableTextInputsInView]];
		}
	return textInputs;
	}

- (NSArray<UIResponder*>*) textResponders
	{
	NSArray *textInputs = [[[UIApplication sharedApplication] keyWindow] editableTextInputsInView];
	return [textInputs sortedArrayUsingComparator:
	^ NSComparisonResult (UIView *textInput1, UIView *textInput2)
		{
		UIView *commonAncestorView = textInput1.superview;
		while (commonAncestorView && ![textInput2 isDescendantOfView:commonAncestorView])
			commonAncestorView = commonAncestorView.superview;
		
		CGRect frame1 = [textInput1 convertRect:textInput1.bounds toView:commonAncestorView];
		CGRect frame2 = [textInput2 convertRect:textInput2.bounds toView:commonAncestorView];
		NSComparisonResult result = [@(CGRectGetMinY(frame1)) compare:@(CGRectGetMinY(frame2))];
		if (result == NSOrderedSame)
			result = [@(CGRectGetMinX(frame1)) compare:@(CGRectGetMinX(frame2))];
		return result;
		}];
	}

- (UIResponder*) nextTextInputResponder
	{
	NSArray *_textResponders = self.textResponders;
	NSArray *firstResponders = [_textResponders filteredArrayUsingPredicate:
		[NSPredicate predicateWithBlock:
			^ BOOL(UIResponder *responder, NSDictionary *bindings)
				{
				return [responder isFirstResponder];
				}]];
	UIResponder *firstResponder = [firstResponders lastObject];
	NSInteger offset = 1;
	NSInteger firstResponderIndex = [_textResponders indexOfObject:firstResponder];
	NSInteger adjacentResponderIndex = firstResponderIndex != NSNotFound ? firstResponderIndex + offset : NSNotFound;
	UIResponder *adjacentResponder = nil;
	if (adjacentResponderIndex >= 0 && adjacentResponderIndex < (NSInteger)_textResponders.count)
		adjacentResponder = [_textResponders objectAtIndex:adjacentResponderIndex];

	return adjacentResponder;
	}

- (UIResponder*) firstTextInputResponder
	{
	NSArray *_textResponders = self.textResponders;
	return _textResponders.firstObject;
	}

@end
