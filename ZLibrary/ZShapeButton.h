//
//  ZShapeButton.h
//  Search
//
//  Created by Edward Smith on 1/16/14.
//  Copyright (c) 2014 Relcy, Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface ZShapeButton : UIButton


- (id) initWithCoder:(NSCoder *)aDecoder;
- (id) initWithFrame:(CGRect)frame;

@property (nonatomic, weak) UIBezierPath *backgroundShape;
@end
