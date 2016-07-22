//
//  ABCategoryModel.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABCategoryModel.h"
#import "MJExtension.h"

@implementation ABCategoryModel

@synthesize isRemoved = _isRemoved;
@synthesize isExistCloud = _isExistCloud;
@synthesize createTime = _createTime;
@synthesize modifyTime = _modifyTime;

- (id)copyWithZone:(nullable NSZone *)zone
{
    id selfCopy = [[[self class] alloc] init];
    NSDictionary *dict = self.mj_keyValues;
    if(dict)
    {
        selfCopy = [[self class] mj_objectWithKeyValues:dict];
    }
    return selfCopy;
}

@end
