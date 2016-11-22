//
//  MTMultiTargetCallBack.m
//  MTMultiTargetCallBackDemo
//
//  Created by zhourongqing on 16/1/27.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import "MTMultiTargetCallBack.h"

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

- (NSArray *)targets
{
    return self.targetHashTable.allObjects;
}

- (void)addTarget:(id)target
{
    [self.targetHashTable addObject:target];
}

- (void)removeTarget:(id)target
{
    [self.targetHashTable removeObject:target];
}

- (void)removeAllTargets
{
    [self.targetHashTable removeAllObjects];
}

- (BOOL)containsTarget:(id)target
{
    return [self.targetHashTable containsObject:target];
}

- (void)callBackSelector:(SEL)selector params:(id)param, ...
{
    @synchronized (self) {
        for(id target in self.targetHashTable.allObjects)
        {
            va_list params;
            va_start(params, param);
            [self executingTarget:target selector:selector params:params startParam:param];
            va_end(params);
        }
    }
}

- (void)callBackIfExistSelector:(SEL)selector params:(id)param, ...
{
    @synchronized (self) {
        for(id target in self.targetHashTable.allObjects)
        {
            if([target respondsToSelector:selector])
            {
                va_list params;
                va_start(params, param);
                [self executingTarget:target selector:selector params:params startParam:param];
                va_end(params);
            }
        }
    }
}

- (void)callBackSelector:(SEL)selector
{
    [self callBackSelector:selector params:nil];
}

- (void)callBackIfExistSelector:(SEL)selector
{
    [self callBackIfExistSelector:selector params:nil];
}

- (void)executingTarget:(id)target selector:(SEL)selector params:(va_list)params startParam:(id)startParam
{
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = target;
    invocation.selector = selector;
    
    if(methodSignature.numberOfArguments > 2)
    {
        [invocation setArgument:&startParam atIndex:2];
    }
    
    for(NSInteger index = 3; index < methodSignature.numberOfArguments; index++)
    {
        const char *type = [methodSignature getArgumentTypeAtIndex:index];
        if(strcmp(type, "@") == 0)
        {
            id otherParam = va_arg(params, id);
            [invocation setArgument:&otherParam atIndex:index];
        }
        else if(strcmp(type, "i") == 0 ||
                strcmp(type, "s") == 0 ||
                strcmp(type, "B") == 0)
        {
            int otherParam = va_arg(params, int);
            [invocation setArgument:&otherParam atIndex:index];
        }
        else if(strcmp(type, "l") == 0)
        {
            long otherParam = va_arg(params, long);
            [invocation setArgument:&otherParam atIndex:index];
        }
        else if(strcmp(type, "q") == 0)
        {
            long long otherParam = va_arg(params, long long);
            [invocation setArgument:&otherParam atIndex:index];
        }
        else if(strcmp(type, "I") == 0 ||
                strcmp(type, "S") == 0)
        {
            unsigned int otherParam = va_arg(params, unsigned int);
            [invocation setArgument:&otherParam atIndex:index];
        }
        else if(strcmp(type, "L") == 0)
        {
            unsigned long otherParam = va_arg(params, unsigned long);
            [invocation setArgument:&otherParam atIndex:index];
        }
        else if(strcmp(type, "Q") == 0)
        {
            unsigned long long otherParam = va_arg(params, unsigned long long);
            [invocation setArgument:&otherParam atIndex:index];
        }
        else if(strcmp(type, "f") == 0 ||
                strcmp(type, "d") == 0)
        {
            double otherParam = va_arg(params, double);
            [invocation setArgument:&otherParam atIndex:index];
        }
    }
    
    [invocation retainArguments];
    [invocation invoke];
}

- (void)dealloc
{
    [self.targetHashTable removeAllObjects];
}

@end
