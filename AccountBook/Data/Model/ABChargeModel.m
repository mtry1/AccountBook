//
//  ABChargeModel.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeModel.h"

@implementation ABChargeModel

- (BOOL)isTimeOut
{
    if(self.endTimeInterval)
    {
        NSString *nowDateString = [ABUtils dateString:[[NSDate date] timeIntervalSince1970]];
        NSString *endDateString = [ABUtils dateString:self.endTimeInterval];
        
        if([nowDateString compare:endDateString] == NSOrderedDescending)
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
