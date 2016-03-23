//
//  APHotLabel.h
//  Blitz
//
//  Created by Edward Smith on 3/22/16.
//  Copyright © 2016 Blitz Here. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface APHotLabel : UILabel
- (void) setTouchUpTarget:(id)target action:(SEL)action;
@end
