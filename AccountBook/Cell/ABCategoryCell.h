//
//  ABCategoryCell.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABCategoryModel.h"

@interface ABCategoryCell : UICollectionViewCell

- (void)reloadWithModel:(ABCategoryModel *)model;

@end
