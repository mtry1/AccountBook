//
//  ABTableView.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/30.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABTableView.h"

@implementation ABTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithUInt:0xf4f4f4];
    }
    return self;
}

@end
