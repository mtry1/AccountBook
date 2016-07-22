//
//  ABCategoryModel.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABSyncProtocol.h"

@interface ABCategoryModel : NSObject<ABSyncProtocol, NSCopying>

@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *colorHexString;

@end
