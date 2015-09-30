//
//  ABDatePicker.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/30.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABDatePicker : UIView

@property (nonatomic, readonly) UIDatePicker *datePicker;

- (void)show;

- (void)close;

@end
