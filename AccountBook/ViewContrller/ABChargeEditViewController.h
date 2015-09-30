//
//  ABChargeEditViewController.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/30.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABViewController.h"
#import "ABChargeDataManger.h"

@interface ABChargeEditViewController : ABViewController

@property (nonatomic, strong) ABChargeDataManger *dataManager;

///如果index为－1表示添加，否则认为修改
@property (nonatomic) NSInteger index;

@end
