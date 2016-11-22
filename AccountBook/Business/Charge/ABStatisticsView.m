//
//  ABStatisticsView.m
//  CocoaPodsDemo
//
//  Created by zhourongqing on 15/10/14.
//  Copyright © 2015年 duoyi. All rights reserved.
//

#import "ABStatisticsView.h"
#import "ABDatePicker.h"
#import "UIButton+MTEdgeInsets.h"

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
        _startButton.titleLabel.font = ABStatisticsViewDefaultFont;
        [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startButton setImage:[UIImage imageNamed:@"PDF_ArrowDown"] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(touchUpInsideStartButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIButton *)endButton
{
    if(!_endButton)
    {
        _endButton = [[UIButton alloc] init];
        _endButton.titleLabel.font = ABStatisticsViewDefaultFont;
        [_endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_endButton setImage:[UIImage imageNamed:@"PDF_ArrowDown"] forState:UIControlStateNormal];
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

- (void)setStartDate:(NSDate *)startDate
{
    if(![_startDate isEqualToDate:startDate])
    {
        _startDate = startDate;
        [self.startButton setTitle:[ABUtils dateString:[startDate timeIntervalSince1970]] forState:UIControlStateNormal];
    }
}

- (void)setEndDate:(NSDate *)endDate
{
    if(![_endDate isEqualToDate:endDate])
    {
        _endDate = endDate;
        [self.endButton setTitle:[ABUtils dateString:[endDate timeIntervalSince1970]] forState:UIControlStateNormal];
    }
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
        self.startDate = [NSDate date];
        self.endDate = [NSDate date];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.origin.x = 5;
    rect.size.width = [ABUtils calculateWidthForHeight:rect.size.height text:self.timeLabel.text font:self.timeLabel.font];
    self.timeLabel.frame = rect;
    
    rect.origin.x = CGRectGetMaxX(self.timeLabel.frame);
    rect.origin.y = 3.0f;
    rect.size.width = [ABUtils calculateWidthForHeight:rect.size.height text:self.startButton.titleLabel.text font:self.startButton.titleLabel.font] + CGRectGetWidth(self.startButton.imageView.frame);
    self.startButton.frame = rect;
    [self.startButton centerLabelTopAndImageBottomSpacing:2];
    
    rect = self.timeLabel.bounds;
    rect.origin.x = CGRectGetMaxX(self.startButton.frame);
    rect.size.width = [ABUtils calculateWidthForHeight:rect.size.height text:self.toLabel.text font:self.toLabel.font];;
    self.toLabel.frame = rect;
    
    rect = self.startButton.frame;
    rect.origin.x = CGRectGetMaxX(self.toLabel.frame);
    rect.size.width = [ABUtils calculateWidthForHeight:rect.size.height text:self.endButton.titleLabel.text font:self.endButton.titleLabel.font] + CGRectGetWidth(self.startButton.imageView.frame);
    self.endButton.frame = rect;
    [self.endButton centerLabelTopAndImageBottomSpacing:2];
    
    rect = self.toLabel.bounds;
    rect.size.width = [ABUtils calculateWidthForHeight:rect.size.height text:self.amountLabel.text font:self.amountLabel.font];;
    rect.origin.x = CGRectGetWidth(self.frame) - rect.size.width - 5;
    self.amountLabel.frame = rect;
}

#pragma mark - 点击事件

- (void)touchUpInsideStartButton:(UIButton *)button
{
    button.selected = !button.selected;
    [self updateDateImageButton:button];
    [self.datePicker show];
    
    if(self.endDate)
    {
        self.datePicker.datePicker.maximumDate = self.endDate;
    }
    self.datePicker.datePicker.minimumDate = nil;
    
    if(self.startDate)
    {
        self.datePicker.datePicker.date = self.startDate;
    }
}

- (void)touchUpInsideEndButton:(UIButton *)button
{
    button.selected = !button.selected;
    [self updateDateImageButton:button];
    [self.datePicker show];
    
    if(self.startDate)
    {
        self.datePicker.datePicker.minimumDate = self.startDate;
    }
    self.datePicker.datePicker.maximumDate = nil;
    
    if(self.endDate)
    {
        self.datePicker.datePicker.date = self.endDate;
    }
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
    self.amountLabel.text = [NSString stringWithFormat:@"合计:%.lf元",  amount];
    [self setNeedsLayout];
}

- (void)updateDateImageButton:(UIButton *)button
{
    NSString *imageName = button.selected ? @"PDF_ArrowUp" : @"PDF_ArrowDown";
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
