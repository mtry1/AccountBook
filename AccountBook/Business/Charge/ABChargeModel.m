//
//  ABChargeModel.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeModel.h"
#import "MJExtension.h"

@implementation ABChargeModel

@synthesize isRemoved = _isRemoved;
@synthesize isExistCloud = _isExistCloud;
@synthesize createTime = _createTime;
@synthesize modifyTime = _modifyTime;

- (id)copyWithZone:(nullable NSZone *)zone
{
    id selfCopy = [[[self class] alloc] init];
    NSMutableDictionary *dict = self.mj_keyValues;
    if(dict)
    {
        [dict removeObjectForKey:@"isTimeOut"];
        selfCopy = [[self class] mj_objectWithKeyValues:dict];
    }
    return selfCopy;
}

- (NSString *)ID
{
    return self.chargeID;
}

- (BOOL)isTimeOut
{
    if(self.endTimeInterval)
    {
        NSString *nowDateString = [ABUtils dateString:[[NSDate date] timeIntervalSince1970]];
        NSString *endDateString = [ABUtils dateString:self.endTimeInterval];
        
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultKeyOutEndTimeRed] boolValue] &&
           [nowDateString compare:endDateString] == NSOrderedDescending)
        {
            return YES;
        }
    }
    
    return NO;
}

- (NSTimeInterval)startTimeInterval
{
    if(!_startTimeInterval)
    {
        _startTimeInterval = [[NSDate date] timeIntervalSince1970];
    }
    return _startTimeInterval;
}

@end
