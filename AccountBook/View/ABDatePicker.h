//
//  ABDatePicker.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/30.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABDatePicker;

@protocol ABDatePickerDeleage <NSObject>

- (void)datePicker:(ABDatePicker *)picker didConfirmDate:(NSDate *)date;

@optional

- (void)datePickerDidCancal:(ABDatePicker *)picker;

@end

@interface ABDatePicker : UIView

@property (nonatomic, weak) id<ABDatePickerDeleage>delegate;

@property (nonatomic, readonly) UIDatePicker *datePicker;

- (void)show;

- (void)close;

@end
