//
//  ABChargeEditCell.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/7.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABChargeEditCell.h"

#define ABChargeEditCellDefaultFont [UIFont systemFontOfSize:16]

NSInteger const ABChargeEditCellDefaultHeight = 50;

@implementation ABChargeEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.font = ABChargeEditCellDefaultFont;
        self.textLabel.font = ABChargeEditCellDefaultFont;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.textLabel.frame;
    rect.origin.y = (CGRectGetHeight(self.contentView.frame) - rect.size.height) / 2;
    self.textLabel.frame = rect;
}

- (void)reloadWithModel:(ABChargeEditModel *)model isEdit:(BOOL)isEdit
{
    self.accessoryType = isEdit ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.detailTextLabel.textColor = isEdit ? [UIColor blackColor] : [UIColor colorWithUInt:0x777777];;
    self.detailTextLabel.numberOfLines = 1;
    
    self.textLabel.text = model.title;
    
    if([model.title isEqualToString:ABChargeEditStartDate] ||
       [model.title isEqualToString:ABChargeEditEndDate])
    {
        self.detailTextLabel.text = [ABUtils dateString:[model.date timeIntervalSince1970]];
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
        self.detailTextLabel.text = text;
    }
    else if([model.title isEqualToString:ABChargeEditNotes])
    {
        self.detailTextLabel.numberOfLines = 2;
        self.detailTextLabel.text = model.desc;
    }
    
}

+ (CGFloat)heightWithModel:(ABChargeEditModel *)model width:(CGFloat)width
{
    if(model && [model.title isEqualToString:ABChargeEditNotes])
    {
        return 70;
    }
    return ABChargeEditCellDefaultHeight;
}

@end
