//
//  ABChargeListViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeListViewController.h"
#import "ABChargeDataManger.h"

@interface ABChargeListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic, readonly) ABChargeDataManger *dataManger;

@end

@implementation ABChargeListViewController

@synthesize tableView = _tableView;
@synthesize dataManger = _dataManger;

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (ABChargeDataManger *)dataManger
{
    if(!_dataManger)
    {
        _dataManger = [[ABChargeDataManger alloc] init];
    }
    return _dataManger;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.dataManger addDelegate:self];
    
    NSLog(@"%@", self.categoryID);
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataManger.numberOfItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"chargeListIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

@end
