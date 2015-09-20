//
//  ABDataManager.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABDataManager.h"

@interface ABDataManager()

@property (nonatomic, strong) NSHashTable *delegateHashTable;

@end

@implementation ABDataManager

- (NSHashTable *)delegateHashTable
{
    if(!_delegateHashTable)
    {
        _delegateHashTable = [NSHashTable weakObjectsHashTable];
    }
    return _delegateHashTable;
}

- (void)addDelegate:(id)delegate
{
    [self.delegateHashTable addObject:delegate];
}

- (void)callBackAction:(SEL)action
{
    for(id delegate in self.delegateHashTable.allObjects)
    {
        if([delegate respondsToSelector:action])
        {
            ABSendMessage0Param(delegate, action);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1
{
    for(id delegate in self.delegateHashTable.allObjects)
    {
        if([delegate respondsToSelector:action])
        {
            ABSendMessage1Param(delegate, action, object1);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2
{
    for(id delegate in self.delegateHashTable.allObjects)
    {
        if([delegate respondsToSelector:action])
        {
            ABSendMessage2Param(delegate, action, object1, object2);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2 object3:(id)object3
{
    for(id delegate in self.delegateHashTable.allObjects)
    {
        if([delegate respondsToSelector:action])
        {
            ABSendMessage3Param(delegate, action, object1, object2, object3);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2 object3:(id)object3 object4:(id)object4
{
    for(id delegate in self.delegateHashTable.allObjects)
    {
        if([delegate respondsToSelector:action])
        {
            ABSendMessage4Param(delegate, action, object1, object2, object3, object4);
        }
    }
}

- (void)dealloc
{
    [self.delegateHashTable removeAllObjects];
}

@end
