//
//  ABDataManager.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABDataManager.h"

@interface ABDataManager()

@end

@implementation ABDataManager

@synthesize callBackUtils = _callBackUtils;

- (ABCallBackUtils *)callBackUtils
{
    if(!_callBackUtils)
    {
        _callBackUtils = [[ABCallBackUtils alloc] init];
    }
    return _callBackUtils;
}

@end
