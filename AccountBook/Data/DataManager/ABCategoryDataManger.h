//
//  ABCategoryDataManger.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABDataManager.h"
#import "ABCategoryModel.h"

@class ABCategoryDataManger;

@protocol ABCategoryDataMangerDelegate <ABDataManagerTableCallBackDelegate>

@optional

///移动
- (void)categoryDataManger:(ABCategoryDataManger *)manger moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end

@interface ABCategoryDataManger : ABDataManager

///请求初始数据
- (void)requestInitData;

///请求添加
- (void)requestAddObjectWithText:(NSString *)text;

///请求删除
- (void)requestRemoveIndex:(NSInteger)index;

///请求重命名
- (void)requestRename:(NSString *)text atIndex:(NSInteger)index;

///请求移动
- (void)requestMoveItemAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex;

- (NSInteger)numberOfItem;

- (ABCategoryModel *)dataAtIndex:(NSInteger)index;

@end
