//
//  ABChargeListCell.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABChargeModel.h"

@interface ABChargeListCell : ABTableViewCell

- (void)reloadWithModel:(ABChargeModel *)model;

@end
