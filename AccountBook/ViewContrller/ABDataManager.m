//
//  ABDataManager.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABDataManager.h"

@interface ABDataManager()

@property (nonatomic, strong) NSMutableSet *delegateSet;

@end

@implementation ABDataManager

- (NSMutableSet *)delegateSet
{
    if(!_delegateSet)
    {
        _delegateSet = [NSMutableSet set];
    }
    return _delegateSet;
}

- (void)addDelegate:(id)delegate
{
    __weak typeof(delegate) weakDelegate = delegate;
    [self.delegateSet addObject:weakDelegate];
}

- (void)removeDelegate:(id)delegate
{
    if([self.delegateSet containsObject:delegate])
    {
        [self.delegateSet removeObject:delegate];
    }
}

- (void)callBackAction:(SEL)action
{
    NSEnumerator *enumerator = [self.delegateSet objectEnumerator];
    for(id delegate in enumerator)
    {
        if([delegate respondsToSelector:action])
        {
            ABSendMessage0Param(delegate, action);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1
{
    NSEnumerator *enumerator = [self.delegateSet objectEnumerator];
    for(id delegate in enumerator)
    {
        if([delegate respondsToSelector:action])
        {
            ABSendMessage1Param(delegate, action, object1);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2
{
    NSEnumerator *enumerator = [self.delegateSet objectEnumerator];
    for(id delegate in enumerator)
    {
        if([delegate respondsToSelector:action])
        {
            ABSendMessage2Param(delegate, action, object1, object2);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2 object3:(id)object3
{
    NSEnumerator *enumerator = [self.delegateSet objectEnumerator];
    for(id delegate in enumerator)
    {
        if([delegate respondsToSelector:action])
        {
            ABSendMessage3Param(delegate, action, object1, object2, object3);
        }
    }
}

- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2 object3:(id)object3 object4:(id)object4
{
    NSEnumerator *enumerator = [self.delegateSet objectEnumerator];
    for(id delegate in enumerator)
    {
        if([delegate respondsToSelector:action])
        {
            ABSendMessage4Param(delegate, action, object1, object2, object3, object4);
        }
    }
}

- (void)dealloc
{
    [self.delegateSet removeAllObjects];
}

@end
