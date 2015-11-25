//
//  ABChargeEditCell.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/7.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABChargeEditCell.h"

#define ABChargeEditCellDefaultFont [UIFont systemFontOfSize:16]

NSInteger const ABChargeEditCellDefaultHeight = 45;

@interface ABChargeEditCell ()

@property (nonatomic, readonly) UILabel *titleLabel;

@property (nonatomic, readonly) UILabel *descLabel;

@end

@implementation ABChargeEditCell
{
    NSMutableArray  *_constraints;
}

@synthesize titleLabel = _titleLabel;
@synthesize descLabel = _descLabel;

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ABChargeEditCellDefaultFont;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if(!_descLabel)
    {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = ABChargeEditCellDefaultFont;
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.numberOfLines = 0;
        _descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _descLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        
        _constraints = [NSMutableArray array];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    if(_constraints.count)
    {
        [self.contentView removeConstraints:_constraints];
        [_constraints removeAllObjects];
    }
    
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel(70)]-(>=0)-[_descLabel]-|"
                                                                              options:NSLayoutFormatAlignAllCenterY
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_titleLabel, _descLabel)]];
    
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_descLabel(>=_titleLabel)]-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_descLabel, _titleLabel)]];
    
    [self.contentView addConstraints:_constraints];
}

- (void)reloadWithModel:(ABChargeEditModel *)model isEdit:(BOOL)isEdit
{
    self.accessoryType = isEdit ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.descLabel.textColor = isEdit ? [UIColor blackColor] : [UIColor colorWithUInt:0x777777];;
    
    self.titleLabel.text = model.title;
    
    if([model.title isEqualToString:ABChargeEditStartDate] ||
       [model.title isEqualToString:ABChargeEditEndDate])
    {
        if(model.date)
        {
            self.descLabel.text = [ABUtils dateString:[model.date timeIntervalSince1970]];
        }
        else
        {
            self.descLabel.text = @"-";
        }
    }
    else if([model.title isEqualToString:ABChargeEditTitle] ||
            [model.title isEqualToString:ABChargeEditAmount])
    {
        NSMutableString *text = [NSMutableString string];
        if(model.desc.length)
        {
            [text appendString:model.desc];
        }
        [text appendString:isEdit ? @"（必填）": @""];
        self.descLabel.text = text;
    }
    else if([model.title isEqualToString:ABChargeEditNotes])
    {
        self.descLabel.text = model.desc;
    }
    
    [self setNeedsUpdateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

@end
