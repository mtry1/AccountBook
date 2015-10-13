//
//  ABDatePicker.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/30.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABDatePicker.h"

@interface ABDatePicker ()

@property (nonatomic, readonly) UIView *backgroundView;

@property (nonatomic, readonly) UIView *contentView;

@property (nonatomic, readonly) UIButton *cancelButton;

@property (nonatomic, readonly) UIButton *confirmButton;

@end

@implementation ABDatePicker

@synthesize backgroundView = _backgroundView;
@synthesize contentView = _contentView;
@synthesize datePicker = _datePicker;
@synthesize cancelButton = _cancelButton;
@synthesize confirmButton = _confirmButton;

- (UIView *)backgroundView
{
    if(!_backgroundView)
    {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _backgroundView.backgroundColor = [UIColor colorWithUInt:0x888888 alpha:0.5];
    }
    return _backgroundView;
}

- (UIView *)contentView
{
    if(!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 250)];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIDatePicker *)datePicker
{
    if(!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 34, CGRectGetWidth(self.frame), 216)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePicker;
}

- (UIButton *)cancelButton
{
    if(!_cancelButton)
    {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        [_cancelButton setTitleColor:[UIColor colorWithUInt:0x007aff] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton
{
    if(!_confirmButton)
    {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 50, 0, 50, 44)];
        [_confirmButton setTitleColor:[UIColor colorWithUInt:0x007aff] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(touchUpInsideConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = [UIScreen mainScreen].bounds;
    
    self = [super initWithFrame:frame];
    if(self)
    {
        [self addSubview:self.backgroundView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.confirmButton];
        [self.contentView addSubview:self.datePicker];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.backgroundView.alpha = 0;
    
    CGRect startRect = self.contentView.bounds;
    startRect.origin.y = CGRectGetHeight(self.frame);
    self.contentView.frame = startRect;
    [UIView animateWithDuration:0.35 animations:^{
        
        self.backgroundView.alpha = 0.5;
        
        CGRect endRect = self.contentView.bounds;
        endRect.origin.y = CGRectGetHeight(self.frame) - endRect.size.height;
        self.contentView.frame = endRect;
    }];
}

- (void)close
{
    self.backgroundView.alpha = 0.5;
    
    CGRect startRect = self.contentView.bounds;
    startRect.origin.y = CGRectGetHeight(self.frame) - startRect.size.height;
    self.contentView.frame = startRect;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backgroundView.alpha = 0;
        
        CGRect endRect = self.contentView.bounds;
        endRect.origin.y = CGRectGetHeight(self.frame);
        self.contentView.frame = endRect;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)touchUpInsideConfirmButton:(UIButton *)button
{
    [self close];
    
    if([self.delegate respondsToSelector:@selector(datePicker:didConfirmDate:)])
    {
        [self.delegate datePicker:self didConfirmDate:self.datePicker.date];
    }
}

@end
