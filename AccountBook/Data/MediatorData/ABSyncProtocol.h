//
//  ABSyncProperty.h
//  AccountBook
//
//  Created by zhourongqing on 16/7/22.
//  Copyright © 2016年 mtry. All rights reserved.
//

@protocol ABSyncProtocol <NSObject>

- (NSString *)ID;
///是否已经删除
@property (nonatomic) BOOL isRemoved;
///是否在云端存在
@property (nonatomic) BOOL isExistCloud;
///创建时间
@property (nonatomic) NSTimeInterval createTime;
///修改时间
@property (nonatomic) NSTimeInterval modifyTime;

@end

