//
//  ABChargeCoreDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 16/7/22.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABChargeModel.h"

@interface ABChargeCoreDataManager : NSObject

+ (void)selectAllChargeListDataCompleteHandler:(void(^)(NSArray<ABChargeModel *> *array))completeHandler;
+ (void)selectChargeListDateWithCategoryID:(NSString *)categoryID completeHandler:(void(^)(NSArray<ABChargeModel *> *array))completeHandler;

//flag为YES彻底删除，NO时逻辑删除
+ (void)deleteChargeChargeID:(NSString *)chargeID flag:(BOOL)flag completeHandler:(void(^)(BOOL success))completeHandler;
+ (void)deleteChargeListDataWithCategoryID:(NSString *)categoryID completeHandler:(void(^)(BOOL success))completeHandler;
+ (void)insertChargeModel:(ABChargeModel *)model completeHandler:(void(^)(BOOL success))completeHandler;
+ (void)updateChargeModel:(ABChargeModel *)model completeHandler:(void(^)(BOOL success))completeHandler;

@end
