//
//  ZLabelControl.m
//  ZLibrary
//
//  Created by Edward Smith on 5/6/15.
//  Copyright (c) 2015 Edward Smith. All rights reserved.
//


#import "ZLabelControl.h"


@implementation ZLabelControl

- (instancetype) initWithCoder:(NSCoder *)aDecoder
	{
	self = [super initWithCoder:aDecoder];
	[self commonInit];
	return self;
	}

- (instancetype) initWithFrame:(CGRect)frame
	{
	self = [super initWithFrame:frame];
	[self commonInit];
	return self;
	}

- (void) commonInit
	{
	self.userInteractionEnabled = YES;
	}

- (UILabel*) label
	{
	if (!_label)
		{
		_label = [[UILabel alloc] initWithFrame:self.bounds];
		[self addSubview:_label];
		}
	return _label;
	}

- (void) layoutSubviews
	{
	if (_label)
		{
		_label.frame = self.bounds;
		_label.userInteractionEnabled = NO;
		[self addSubview:_label];
		}
	}

@end
