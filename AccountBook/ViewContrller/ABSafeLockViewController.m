//
//  ABSafeLockViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/27.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABSafeLockViewController.h"

@interface ABSafeLockViewController ()

@property (nonatomic) ABSafeLockOpenType openType;

@property (nonatomic, strong) ABSafeLockCompletedBlock completedBlock;

@end

@implementation ABSafeLockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(touchUpInsideLeftBarButtonItem:)];
}

- (UITextField *)buildTextField
{
    return nil;
}

- (void)touchUpInsideLeftBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(self.completedBlock)
    {
        self.completedBlock(NO);
    }
}

+ (void)showInViewController:(UIViewController *)inViewController
                    openType:(ABSafeLockOpenType)openType
                  completion:(ABSafeLockCompletedBlock)block
{
    ABSafeLockViewController *controller = [[ABSafeLockViewController alloc] init];
    controller.openType = openType;
    controller.completedBlock = block;
    
    if(openType == ABSafeLockOpenTypeStart)
    {
        controller.title = @"设置密码";
    }
    else if(openType == ABSafeLockOpenTypeClose)
    {
        controller.title = @"关闭密码";
    }
    else if(openType == ABSafeLockOpenTypeVerify)
    {
        controller.title = @"输入密码";
    }
    
    ABNavigationController *navigation = [[ABNavigationController alloc] initWithRootViewController:controller];
    [inViewController presentViewController:navigation animated:YES completion:nil];
}

@end
