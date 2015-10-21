//
//  ABCategoryCell.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABCategoryModel.h"

@class ABCategoryCell;

@protocol ABCategoryCellDelegate <NSObject>

- (void)categoryCellDidLongPress:(ABCategoryCell *)cell;

@end

@interface ABCategoryCell : UICollectionViewCell

@property (nonatomic, weak) id<ABCategoryCellDelegate>delegate;

- (void)reloadWithModel:(ABCategoryModel *)model;

@end
