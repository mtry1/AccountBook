//
//  ABChargeListViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeListViewController.h"
#import "ABChargeEditViewController.h"
#import "ABChargeDataManger.h"
#import "ABChargeListCell.h"

@interface ABChargeListViewController ()<UITableViewDelegate, UITableViewDataSource, ABDataManagerTableCallBackDelegate>

@property (nonatomic, readonly) ABTableView *tableView;

@property (nonatomic, readonly) ABChargeDataManger *dataManager;

@end

@implementation ABChargeListViewController

@synthesize tableView = _tableView;
@synthesize dataManager = _dataManager;

- (ABTableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[ABTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (ABChargeDataManger *)dataManager
{
    if(!_dataManager)
    {
        _dataManager = [[ABChargeDataManger alloc] init];
    }
    return _dataManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(touchUpInsideRightBarButtonItem:)];
    
    [self.dataManager.callBackUtils addDelegate:self];
    [self.dataManager requestChargeDataWithID:self.categoryID];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.tableView setEditing:NO animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataManager.numberOfItem;
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ABChargeModel *model = [self.dataManager dataAtIndex:indexPath.row];
    if(model)
    {
        [cell reloadWithModel:model];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        ABChargeModel *model = [self.dataManager dataAtIndex:indexPath.row];
        if(model)
        {
            ABAlertView *alertView = [[ABAlertView alloc] initWithTitle:@"您确定要删除"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            [alertView showUsingClickButtonBlock:^(UIAlertView *alertView, NSUInteger atIndex) {
                
                if(atIndex != alertView.cancelButtonIndex)
                {
                    [self.dataManager requestRemoveIndex:indexPath.row];
                }
            }];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ABChargeEditViewController *controller = [[ABChargeEditViewController alloc] init];
    controller.chargeDataManager = self.dataManager;
    controller.editIndex = indexPath.row;
    controller.title = @"详情";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 其他

- (void)touchUpInsideRightBarButtonItem:(id)sender
{
    ABChargeEditViewController *controller = [[ABChargeEditViewController alloc] init];
    controller.chargeDataManager = self.dataManager;
    controller.editIndex = -1;
    controller.title = @"添加";
    
    ABNavigationController *navigation = [[ABNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - 数据处理

- (void)dataManagerReloadData:(ABDataManager *)manager
{
    [self.tableView reloadData];
}

- (void)dataManager:(ABDataManager *)manager removeIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)dataManager:(ABDataManager *)manager updateIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)dataManager:(ABDataManager *)manager addIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

@end
