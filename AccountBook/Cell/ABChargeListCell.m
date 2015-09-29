//
//  ABChargeListCell.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeListCell.h"

@interface ABChargeListCell ()

@property (nonatomic, readonly) UILabel *titleLabel;

@property (nonatomic, readonly) UILabel *moneyLabel;

@property (nonatomic, readonly) UILabel *startDateLabel;

@property (nonatomic, readonly) UILabel *endDateLabel;

@end

@implementation ABChargeListCell

@synthesize titleLabel = _titleLabel;
@synthesize moneyLabel = _moneyLabel;
@synthesize startDateLabel = _startDateLabel;
@synthesize endDateLabel = _endDateLabel;

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel
{
    if(!_moneyLabel)
    {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor redColor];
    }
    return _moneyLabel;
}

- (UILabel *)startDateLabel
{
    if(!_startDateLabel)
    {
        _startDateLabel = [[UILabel alloc] init];
    }
    return _startDateLabel;
}

- (UILabel *)endDateLabel
{
    if(!_endDateLabel)
    {
        _endDateLabel = [[UILabel alloc] init];
    }
    return _endDateLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.startDateLabel];
        [self.contentView addSubview:self.endDateLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = CGRectZero;
    rect.origin.x = 15;
    rect.origin.y = 10;
    rect.size.width = 100;
    rect.size.height = 20;
    self.titleLabel.frame = rect;
    
    rect = self.titleLabel.frame;
    rect.origin.y = CGRectGetMaxY(self.titleLabel.frame) + 10;
    self.moneyLabel.frame = rect;
}

- (void)reloadWithModel:(ABChargeModel *)model
{
    self.titleLabel.text = model.title;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf", model.money];
    self.startDateLabel.text = [ABUtils dateString:model.startTimeInterval];
    self.endDateLabel.text = [ABUtils dateString:model.endTimeInterval];
}

@end
