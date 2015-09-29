//
//  ABChargeListViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeListViewController.h"
#import "ABChargeDataManger.h"
#import "ABChargeListCell.h"

@interface ABChargeListViewController ()<UITableViewDelegate, UITableViewDataSource, ABDataManagerTableCallBackDelegate>

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
    
    [self.view addSubview:self.tableView];
    
    [self.dataManger.callBackUtils addDelegate:self];
    [self.dataManger requestChargeDataWithID:self.categoryID];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"chargeListIdentifier";
    
    ABChargeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[ABChargeListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identifier];
    }
    
    return cell;
}

#pragma mark - 数据处理

- (void)dataManagerReloadData:(ABDataManager *)manager
{
    [self.tableView reloadData];
}

@end
