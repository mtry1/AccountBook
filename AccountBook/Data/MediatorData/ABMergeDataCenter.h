//
//  ABMergeDataCenter.h
//  AccountBook
//
//  Created by zhourongqing on 16/7/21.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABMergeDataCenter : NSObject

+ (instancetype)sharedInstance;
- (void)mergeCloudDataFinishedHandler:(void(^)(BOOL success, NSString *errorMessage))finishedHandler;

@end
