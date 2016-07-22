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

- (void)requestInitData;
- (void)requestAddObjectWithText:(NSString *)text;
- (void)requestRemoveIndex:(NSInteger)index;
- (void)requestRename:(NSString *)text atIndex:(NSInteger)index;

- (NSInteger)numberOfItem;
- (ABCategoryModel *)dataAtIndex:(NSInteger)index;

@end
