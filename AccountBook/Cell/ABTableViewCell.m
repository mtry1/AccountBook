//
//  ABTableViewCell.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/30.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABTableViewCell.h"

@implementation ABTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithUInt:0xf4f4f4];
    }
    return self;
}

@end
