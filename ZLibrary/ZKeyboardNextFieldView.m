


//-----------------------------------------------------------------------------------------------
//
//																		 ZKeyboardNextFieldView.m
//																					 ZLibrary-iOS
//
//							  		  Adds next/previous/done buttons to the top of the keyboard.
//  												 Expanded from code by Bob Milani on 12/19/12
//																	  Edward Smith, December 2012
//
//								 -©- Copyright © 1996-2014 Edward Smith, all rights reserved. -©-
//
//-----------------------------------------------------------------------------------------------


#import "ZKeyboardNextFieldView.h"


static NSString * UIKitLocalizedString(NSString *string)	//	Not sure why this isn't already defined?
	{
	NSBundle *UIKitBundle = [NSBundle bundleForClass:[UIApplication class]];
	return UIKitBundle ? [UIKitBundle localizedStringForKey:string value:string table:nil] : string;
	}


#pragma mark


@implementation ZKeyboardNextFieldView
	{
	UIToolbar *_toolbar;
	}

+ (NSArray*) editableTextInputsInView:(UIView*)view
	{
	NSMutableArray *textInputs = [NSMutableArray new];
	for (UIView *subview in view.subviews)
		{
		BOOL isTextField = [subview isKindOfClass:[UITextField class]];
		BOOL isEditableTextView = [subview isKindOfClass:[UITextView class]] && [(UITextView *)subview isEditable];
		if (isTextField || isEditableTextView)
			[textInputs addObject:subview];
		else
			[textInputs addObjectsFromArray:[self editableTextInputsInView:subview]];
		}
	return textInputs;
	}

- (id) initWithFrame:(CGRect)frame
	{
	return [self initWithResponders:nil];
	}

- (id) initWithResponders:(NSArray *)responders
	{
	if (!(self = [super initWithFrame:CGRectZero]))
		return nil;
	
	_responders = responders;
	
	_toolbar = [[UIToolbar alloc] init];
	_toolbar.tintColor = nil;
	_toolbar.barStyle = UIBarStyleBlack;
	_toolbar.translucent = YES;
	_toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	UISegmentedControl *segmentedControl =
		[[UISegmentedControl alloc]
			initWithItems:@[ UIKitLocalizedString(@"Previous"), UIKitLocalizedString(@"Next") ]];
	[segmentedControl
		addTarget:self
		action:@selector(selectAdjacentResponder:)
		forControlEvents:UIControlEventValueChanged];
	segmentedControl.momentary = YES;

#ifndef __IPHONE_6_0
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
#endif
	
	UIBarButtonItem *segmentedControlBarButtonItem =
		[[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
		
	UIBarButtonItem *flexibleSpace =
		[[UIBarButtonItem alloc]
			initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
			target:nil
			action:nil];
	_toolbar.items = @[ segmentedControlBarButtonItem, flexibleSpace ];
	self.hasDoneButton = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
	
	[self addSubview:_toolbar];
	
	self.frame = _toolbar.frame = (CGRect){CGPointZero, [_toolbar sizeThatFits:CGSizeZero]};
	
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(textInputDidBeginEditing:)
		name:UITextFieldTextDidBeginEditingNotification
		object:nil];
		
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(textInputDidBeginEditing:)
		name:UITextViewTextDidBeginEditingNotification
		object:nil];
	
	return self;
	}

- (void) dealloc
	{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	}

- (void) updateSegmentedControl
	{
	NSArray *responders = self.responders;
	if ([responders count] == 0)
		return;
	
	UISegmentedControl *segmentedControl = (UISegmentedControl *)[_toolbar.items[0] customView];
	BOOL isFirst = [[responders objectAtIndex:0] isFirstResponder];
	BOOL isLast = [[responders lastObject] isFirstResponder];
	[segmentedControl setEnabled:!isFirst forSegmentAtIndex:0];
	[segmentedControl setEnabled:!isLast forSegmentAtIndex:1];
	segmentedControl.hidden = (self.responders.count <= 1);
	}

- (void) willMoveToWindow:(UIWindow *)window
	{
	if (window)
		[self updateSegmentedControl];
	}

- (void) textInputDidBeginEditing:(NSNotification *)notification
	{
	[self updateSegmentedControl];
	}

- (NSArray *) responders
	{
	if (_responders) return _responders;
	
	NSArray *textInputs = [self.class editableTextInputsInView:[[UIApplication sharedApplication] keyWindow]];
	return [textInputs sortedArrayUsingComparator:
	^ NSComparisonResult (UIView *textInput1, UIView *textInput2)
		{
		UIView *commonAncestorView = textInput1.superview;
		while (commonAncestorView && ![textInput2 isDescendantOfView:commonAncestorView])
			commonAncestorView = commonAncestorView.superview;
		
		CGRect frame1 = [textInput1 convertRect:textInput1.bounds toView:commonAncestorView];
		CGRect frame2 = [textInput2 convertRect:textInput2.bounds toView:commonAncestorView];
		return [@(CGRectGetMinY(frame1)) compare:@(CGRectGetMinY(frame2))];
		}];
	}

- (void) setHasDoneButton:(BOOL)hasDoneButton
	{
	[self setHasDoneButton:hasDoneButton animated:NO];
	}

- (void) setHasDoneButton:(BOOL)hasDoneButton animated:(BOOL)animated
	{
	if (_hasDoneButton == hasDoneButton)
		return;
	
	[self willChangeValueForKey:@"hasDoneButton"];
	_hasDoneButton = hasDoneButton;
	[self didChangeValueForKey:@"hasDoneButton"];
	
	NSArray *items;
	if (hasDoneButton)
		{
		items =
			[_toolbar.items arrayByAddingObject:
				[[UIBarButtonItem alloc]
					initWithBarButtonSystemItem:UIBarButtonSystemItemDone
					target:self
					action:@selector(done)]];
		}
	else
		items = [_toolbar.items subarrayWithRange:NSMakeRange(0, 2)];
	
	[_toolbar setItems:items animated:animated];
	}

- (void) updateResponders
	{
	self.responders = nil;
	[self updateSegmentedControl];
	}


#pragma mark - Actions


- (void) selectAdjacentResponder:(UISegmentedControl *)sender
	{
	NSArray *firstResponders = [self.responders filteredArrayUsingPredicate:
		[NSPredicate predicateWithBlock:
			^ BOOL(UIResponder *responder, NSDictionary *bindings)
				{
				return [responder isFirstResponder];
				}]];
	UIResponder *firstResponder = [firstResponders lastObject];
	NSInteger offset = sender.selectedSegmentIndex == 0 ? -1 : +1;
	NSInteger firstResponderIndex = [self.responders indexOfObject:firstResponder];
	NSInteger adjacentResponderIndex = firstResponderIndex != NSNotFound ? firstResponderIndex + offset : NSNotFound;
	UIResponder *adjacentResponder = nil;
	if (adjacentResponderIndex >= 0 && adjacentResponderIndex < (NSInteger)[self.responders count])
		adjacentResponder = [self.responders objectAtIndex:adjacentResponderIndex];
	
	[adjacentResponder becomeFirstResponder];
	}

- (void) done
	{
	[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
	}

@end
