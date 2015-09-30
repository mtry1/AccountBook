//
//  ABDatePicker.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/30.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABDatePicker.h"

@interface ABDatePicker ()

@property (nonatomic, readonly) UIView *contentView;

@property (nonatomic, readonly) UIButton *cancelButton;

@property (nonatomic, readonly) UIButton *confirmButton;

@end

@implementation ABDatePicker

@synthesize contentView = _contentView;
@synthesize datePicker = _datePicker;
@synthesize cancelButton = _cancelButton;
@synthesize confirmButton = _confirmButton;

- (UIView *)contentView
{
    if(!_contentView)
    {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.confirmButton];
        [self.contentView addSubview:self.datePicker];
    }
    return self;
}

- (void)show
{
    
}

- (void)close
{
    
}

@end
