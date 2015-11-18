//
//  ABCategoryModel.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABModel.h"

@interface ABCategoryModel : ABModel

@property (nonatomic, strong) NSString *categoryID;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *colorHexString;

///是否已经删除
@property (nonatomic) BOOL isRemoved;
///是否在云端存在
@property (nonatomic) BOOL isExistCloud;
///创建时间
@property (nonatomic) NSTimeInterval createTime;
///修改时间
@property (nonatomic) NSTimeInterval modifyTime;

@end
