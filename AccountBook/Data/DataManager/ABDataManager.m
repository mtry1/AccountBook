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

@synthesize multiTargetCallBack = _multiTargetCallBack;

- (MTMultiTargetCallBack *)multiTargetCallBack
{
    if(!_multiTargetCallBack)
    {
        _multiTargetCallBack = [[MTMultiTargetCallBack alloc] init];
    }
    return _multiTargetCallBack;
}

@end
