//
//  ABMainDataManger.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABDataManager.h"
#import "ABCategoryModel.h"

@class ABMainDataManger;

@protocol ABMainDataMangerDelegate <ABDataManagerTableCallBackDelegate>


@end

@interface ABMainDataManger : ABDataManager

- (void)requestInitData;

- (NSInteger)numberOfItem;

- (ABCategoryModel *)dataAtIndex:(NSInteger)index;

@end
