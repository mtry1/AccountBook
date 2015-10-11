//
//  NSString+Category.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/11.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (NSString *)trim
{
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:characterSet];
}

@end
