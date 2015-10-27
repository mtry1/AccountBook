//
//  ABSafeLockViewController.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/27.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABViewController.h"

typedef NS_ENUM(NSInteger, ABSafeLockOpenType)
{
    ///开启密码
    ABSafeLockOpenTypeStart,
    ///关闭密码
    ABSafeLockOpenTypeClose,
    ///验证密码
    ABSafeLockOpenTypeVerify,
};

typedef void(^ABSafeLockCompletedBlock)(BOOL isCompleted);

@interface ABSafeLockViewController : ABViewController

+ (void)showInViewController:(UIViewController *)inViewController
                    openType:(ABSafeLockOpenType)openType
                  completion:(ABSafeLockCompletedBlock)block;

@end
