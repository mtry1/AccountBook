//
//  ABCallBackUtils.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/29.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABCallBackUtils.h"
#import <objc/message.h>

void (* ABSendMessage0Param)(id,SEL) = (void (*)(id,SEL))objc_msgSend;
void (* ABSendMessage1Param)(id,SEL,id) = (void (*)(id,SEL,id))objc_msgSend;
void (* ABSendMessage2Param)(id,SEL,id,id) = (void (*)(id,SEL,id,id))objc_msgSend;
void (* ABSendMessage3Param)(id,SEL,id,id,id) = (void (*)(id,SEL,id,id,id))objc_msgSend;
void (* ABSendMessage4Param)(id,SEL,id,id,id,id) = (void (*)(id,SEL,id,id,id,id))objc_msgSend;

@interface ABCallBackUtils ()

@property (nonatomic, strong) NSHashTable *delegateHashTable;

@end

@implementation ABCallBackUtils

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
