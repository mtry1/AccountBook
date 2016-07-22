//
//  ABCategoryCoreDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 16/7/22.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCategoryModel.h"

@interface ABCategoryCoreDataManager : NSObject

//flag为YES彻底删除，NO时逻辑删除
+ (void)deleteCategoryCategoryID:(NSString *)categoryID flag:(BOOL)flag completeHandler:(void(^)(BOOL success))completeHandler;
+ (void)selectCategoryListData:(BOOL)loadDeleted completeHandler:(void(^)(NSArray<ABCategoryModel *> *array))completeHandler;
+ (void)insertCategoryModel:(ABCategoryModel *)model completeHandler:(void(^)(BOOL success))completeHandler;
+ (void)updateCategoryModel:(ABCategoryModel *)model completeHandler:(void(^)(BOOL success))completeHandler;

@end
