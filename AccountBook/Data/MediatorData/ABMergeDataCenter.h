//
//  ABMergeDataCenter.h
//  AccountBook
//
//  Created by zhourongqing on 16/7/21.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCloudKit.h"

@interface ABMergeDataCenter : NSObject

+ (instancetype)sharedInstance;
- (void)mergeCouldDataSuccessedHandler:(void(^)(void))successedHandler
                          errorHandler:(void(^)(CKAccountStatus accountStatus, NSError *error))errorHandler;

@end
