//
//  ABMainViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/12.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABMainViewController.h"
#import "ABCollectionViewController.h"
#import "ABSetViewController.h"

@interface ABMainViewController ()

@end

@implementation ABMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initViewControllers];
}

- (void)initViewControllers
{
    ABNavigationController *navigation1 = [[ABNavigationController alloc] initWithRootViewController:[[ABCollectionViewController alloc] init]];
    navigation1.tabBarItem.title = @"随身记";
    navigation1.topViewController.title = navigation1.tabBarItem.title;
    
    
    ABNavigationController *navigation2 = [[ABNavigationController alloc] initWithRootViewController:[[ABSetViewController alloc] init]];
    navigation2.tabBarItem.title = @"设置";
    navigation2.topViewController.title = navigation2.tabBarItem.title;
    
    self.viewControllers = @[navigation1,
                             navigation2];
    
    UIFont *titleFont = [UIFont systemFontOfSize:18];
    for(UIViewController *controller in self.viewControllers)
    {
        UITabBarItem *tabBarItem = controller.tabBarItem;
        [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:titleFont}
                                  forState:UIControlStateNormal];
        tabBarItem.titlePositionAdjustment = UIOffsetMake(0, (titleFont.lineHeight - CGRectGetHeight(self.tabBar.frame)) / 2);
    }
}

@end
