//
//  ABStatisticsView.m
//  CocoaPodsDemo
//
//  Created by zhourongqing on 15/10/14.
//  Copyright © 2015年 duoyi. All rights reserved.
//

#import "ABStatisticsView.h"
#import "ABDatePicker.h"

#define ABStatisticsViewDefaultFont [UIFont systemFontOfSize:12]

@interface ABStatisticsView()<ABDatePickerDeleage>

@property (nonatomic, readonly) UILabel *timeLabel;

@property (nonatomic, readonly) UIButton *startButton;

@property (nonatomic, readonly) UIButton *endButton;

@property (nonatomic, readonly) UILabel *toLabel;

@property (nonatomic, readonly) UILabel *amountLabel;

@property (nonatomic, readonly) ABDatePicker *datePicker;

@end

@implementation ABStatisticsView
{
    NSDate *_startDate;
    NSDate *_endDate;
}

@synthesize timeLabel = _timeLabel;
@synthesize startButton = _startButton;
@synthesize endButton = _endButton;
@synthesize toLabel = _toLabel;
@synthesize amountLabel = _amountLabel;
@synthesize datePicker = _datePicker;

#pragma mark - 属性

- (UILabel *)timeLabel
{
    if(!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithUInt:0x666666];
        _timeLabel.font = ABStatisticsViewDefaultFont;
        _timeLabel.text = @"时间:";
    }
    return _timeLabel;
}

- (UILabel *)toLabel
{
    if(!_toLabel)
    {
        _toLabel = [[UILabel alloc] init];
        _toLabel.textColor = [UIColor colorWithUInt:0x666666];
        _toLabel.font = ABStatisticsViewDefaultFont;
        _toLabel.text = @"至";
        _toLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _toLabel;
}

- (UILabel *)amountLabel
{
    if(!_amountLabel)
    {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = [UIColor colorWithUInt:0x666666];
        _amountLabel.font = ABStatisticsViewDefaultFont;
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.text = @"合计:0元";
    }
    return _amountLabel;
}

- (UIButton *)startButton
{
    if(!_startButton)
    {
        _startButton = [[UIButton alloc] init];
        _startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _startButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _startButton.titleLabel.font = ABStatisticsViewDefaultFont;
        [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startButton setImage:[UIImage imageWithResourceName:@"chargeList_arrowDown"] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(touchUpInsideStartButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIButton *)endButton
{
    if(!_endButton)
    {
        _endButton = [[UIButton alloc] init];
        _endButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _endButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _endButton.titleLabel.font = ABStatisticsViewDefaultFont;
        [_endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_endButton setImage:[UIImage imageWithResourceName:@"chargeList_arrowDown"] forState:UIControlStateNormal];
        [_endButton addTarget:self action:@selector(touchUpInsideEndButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endButton;
}

- (ABDatePicker *)datePicker
{
    if(!_datePicker)
    {
        _datePicker = [[ABDatePicker alloc] init];
        _datePicker.delegate = self;
    }
    return _datePicker;
}

#pragma mark - 生命周期

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self addSubview:self.timeLabel];
        [self addSubview:self.startButton];
        [self addSubview:self.toLabel];
        [self addSubview:self.endButton];
        [self addSubview:self.amountLabel];
        
        self.backgroundColor = [UIColor whiteColor];
        _startDate = [NSDate date];
        _endDate = [NSDate date];
        
        [self.startButton setTitle:[ABUtils dateString:[self.startDate timeIntervalSince1970]] forState:UIControlStateNormal];
        [self.endButton setTitle:[ABUtils dateString:[self.endDate timeIntervalSince1970]] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.origin.x = 10;
    rect.size.width = [ABUtils calculateWidthForHeight:rect.size.height text:self.timeLabel.text font:self.timeLabel.font];
    self.timeLabel.frame = rect;
    
    rect.origin.x = CGRectGetMaxX(self.timeLabel.frame) + 3;
    rect.size.width = [ABUtils calculateWidthForHeight:rect.size.height text:self.startButton.titleLabel.text font:self.startButton.titleLabel.font] + CGRectGetWidth(self.startButton.imageView.frame);
    self.startButton.frame = rect;
    [self.startButton setTitleEdgeInsets:UIEdgeInsetsMake((CGRectGetHeight(self.startButton.frame) - self.startButton.titleLabel.font.lineHeight) / 2, (CGRectGetWidth(self.startButton.frame) - CGRectGetWidth(self.startButton.titleLabel.frame)) / 2 - CGRectGetWidth(self.startButton.imageView.frame), 0, 0)];
    [self.startButton setImageEdgeInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.startButton.titleLabel.frame) + 2, (self.startButton.frame.size.width - self.startButton.imageView.frame.size.width)/2, 0, 0)];
    
    rect.origin.x = CGRectGetMaxX(self.startButton.frame) + 3;
    rect.size.width = [ABUtils calculateWidthForHeight:rect.size.height text:self.toLabel.text font:self.toLabel.font];;
    self.toLabel.frame = rect;
    
    rect = self.startButton.frame;
    rect.origin.x = CGRectGetMaxX(self.toLabel.frame) + 3;
    rect.size.width = [ABUtils calculateWidthForHeight:rect.size.height text:self.endButton.titleLabel.text font:self.endButton.titleLabel.font] + CGRectGetWidth(self.startButton.imageView.frame);
    self.endButton.frame = rect;
    [self.endButton setTitleEdgeInsets:UIEdgeInsetsMake((CGRectGetHeight(self.endButton.frame) - self.endButton.titleLabel.font.lineHeight) / 2, (CGRectGetWidth(self.endButton.frame) - CGRectGetWidth(self.endButton.titleLabel.frame)) / 2 - CGRectGetWidth(self.endButton.imageView.frame), 0, 0)];
    [self.endButton setImageEdgeInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.endButton.titleLabel.frame) + 2, (self.endButton.frame.size.width - self.endButton.imageView.frame.size.width)/2, 0, 0)];
    
    rect.size.width = [ABUtils calculateWidthForHeight:rect.size.height text:self.amountLabel.text font:self.amountLabel.font];;
    rect.origin.x = CGRectGetWidth(self.frame) - rect.size.width - 10;
    self.amountLabel.frame = rect;
}

#pragma mark - 点击事件

- (void)touchUpInsideStartButton:(UIButton *)button
{
    button.selected = !button.selected;
    [self updateDateImageButton:button];
    [self.datePicker show];
}

- (void)touchUpInsideEndButton:(UIButton *)button
{
    button.selected = !button.selected;
    [self updateDateImageButton:button];
    [self.datePicker show];
}

#pragma mark - ABDatePickerDeleage

- (void)datePicker:(ABDatePicker *)picker didConfirmDate:(NSDate *)date
{
    NSString *dateString = [ABUtils dateString:[date timeIntervalSince1970]];
    if(self.startButton.selected)
    {
        self.startDate = date;
        self.startButton.selected = NO;
        [self.startButton setTitle:dateString forState:UIControlStateNormal];
        
        [self updateDateImageButton:self.startButton];
    }
    else if(self.endButton.selected)
    {
        self.endDate = date;
        self.endButton.selected = NO;
        [self.endButton setTitle:dateString forState:UIControlStateNormal];
        
        [self updateDateImageButton:self.endButton];
    }
    
    if([self.delegate respondsToSelector:@selector(statisticsView:didSelectStartDate:endDate:)])
    {
        [self.delegate statisticsView:self didSelectStartDate:self.startDate endDate:self.endDate];
    }
    
    [self setNeedsLayout];
}

- (void)datePickerDidCancal:(ABDatePicker *)picker
{
    if(self.startButton.selected)
    {
        self.startButton.selected = NO;
        [self updateDateImageButton:self.startButton];
    }
    else if(self.endButton.selected)
    {
        self.endButton.selected = NO;
        [self updateDateImageButton:self.endButton];
    }
}

#pragma mark - 其他

- (void)updateStatisticsAmount:(CGFloat)amount
{
    self.amountLabel.text = [NSString stringWithFormat:@"合计:%.lf元", amount];
    [self setNeedsLayout];
}

- (void)updateDateImageButton:(UIButton *)button
{
    NSString *imageName = button.selected ? @"chargeList_arrowUp" : @"chargeList_arrowDown";
    [button setImage:[UIImage imageWithResourceName:imageName] forState:UIControlStateNormal];
}

@end
