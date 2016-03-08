//
//  MTMultiTargetCallBack.m
//  MTMultiTargetCallBackDemo
//
//  Created by zhourongqing on 16/1/27.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import "MTMultiTargetCallBack.h"
#import <objc/message.h>

void (* MTSendMessage0Param)(id,SEL) = (void (*)(id,SEL))objc_msgSend;
void (* MTSendMessage1Param)(id,SEL,id) = (void (*)(id,SEL,id))objc_msgSend;
void (* MTSendMessage2Param)(id,SEL,id,id) = (void (*)(id,SEL,id,id))objc_msgSend;
void (* MTSendMessage3Param)(id,SEL,id,id,id) = (void (*)(id,SEL,id,id,id))objc_msgSend;
void (* MTSendMessage4Param)(id,SEL,id,id,id,id) = (void (*)(id,SEL,id,id,id,id))objc_msgSend;


@interface MTMultiTargetCallBack ()

@property (nonatomic, strong) NSHashTable *targetHashTable;

@end

@implementation MTMultiTargetCallBack

- (NSHashTable *)targetHashTable
{
    if(!_targetHashTable)
    {
        _targetHashTable = [NSHashTable weakObjectsHashTable];
    }
    return _targetHashTable;
}

- (void)addTarget:(id)target
{
    [self.targetHashTable addObject:target];
}

- (void)callBackAction:(SEL)action
{
    for(id target in self.targetHashTable.allObjects)
    {
        if([target respondsToSelector:action])
        {
            MTSendMessage0Param(target, action);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1
{
    for(id target in self.targetHashTable.allObjects)
    {
        if([target respondsToSelector:action])
        {
            MTSendMessage1Param(target, action, object1);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2
{
    for(id target in self.targetHashTable.allObjects)
    {
        if([target respondsToSelector:action])
        {
            MTSendMessage2Param(target, action, object1, object2);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2 object3:(id)object3
{
    for(id target in self.targetHashTable.allObjects)
    {
        if([target respondsToSelector:action])
        {
            MTSendMessage3Param(target, action, object1, object2, object3);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2 object3:(id)object3 object4:(id)object4
{
    for(id target in self.targetHashTable.allObjects)
    {
        if([target respondsToSelector:action])
        {
            MTSendMessage4Param(target, action, object1, object2, object3, object4);
        }
    }
}

- (void)dealloc
{
    [self.targetHashTable removeAllObjects];
}


@end
