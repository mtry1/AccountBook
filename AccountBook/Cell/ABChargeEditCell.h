//
//  ABChargeEditCell.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/7.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABChargeEditDataManager.h"

extern NSInteger const ABChargeEditCellDefaultHeight;

@interface ABChargeEditCell : ABTableViewCell

- (void)reloadWithModel:(ABChargeEditModel *)model isEdit:(BOOL)isEdit;

+ (CGFloat)heightWithModel:(ABChargeEditModel *)model width:(CGFloat)width;

@end