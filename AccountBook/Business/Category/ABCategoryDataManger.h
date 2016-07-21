//
//  ABCategoryDataManger.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABCategoryModel.h"

@class ABCategoryDataManger;

@protocol ABCategoryDataMangerDelegate<NSObject>

- (void)categoryDataMangerReloadData:(ABCategoryDataManger *)manager;
- (void)categoryDataManger:(ABCategoryDataManger *)manager addIndexPath:(NSIndexPath *)indexPath;
- (void)categoryDataManger:(ABCategoryDataManger *)manager removeIndexPath:(NSIndexPath *)indexPath;
- (void)categoryDataManger:(ABCategoryDataManger *)manager updateIndexPath:(NSIndexPath *)indexPath;

@end

@interface ABCategoryDataManger : NSObject

@property (nonatomic, weak) id<ABCategoryDataMangerDelegate>delegate;

///请求初始数据
- (void)requestInitData;

///请求添加
- (void)requestAddObjectWithText:(NSString *)text;

///请求删除
- (void)requestRemoveIndex:(NSInteger)index;

///请求重命名
- (void)requestRename:(NSString *)text atIndex:(NSInteger)index;

- (NSInteger)numberOfItem;

- (ABCategoryModel *)dataAtIndex:(NSInteger)index;

@end
