//
//  ABCollectionViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/12.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABCollectionViewController.h"

@interface ABCollectionViewController ()

@end

@implementation ABCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(touchUpInsideRightBarButtonItem:)];
}

- (void)touchUpInsideRightBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
}

@end
