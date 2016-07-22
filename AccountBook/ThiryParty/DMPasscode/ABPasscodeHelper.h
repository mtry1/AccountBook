//
//  ABPasscodeHelper.h
//  AccountBook
//
//  Created by zhourongqing on 16/7/21.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABPasscodeHelper : NSObject

+ (BOOL)isPasscodeSet;
+ (void)setupPasscodeCompleteHandler:(void(^)(BOOL success))completeHandler;
+ (void)showPasscodeCompleteHandler:(void(^)(BOOL success))completeHandler;

@end
