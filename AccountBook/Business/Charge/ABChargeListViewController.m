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
#import "ABStatisticsView.h"

@interface ABChargeListViewController ()<UITableViewDelegate, UITableViewDataSource, ABChargeDataMangerDelegate, ABStatisticsViewDelegate>

@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic, readonly) ABStatisticsView *statisticsView;

@property (nonatomic, readonly) ABChargeDataManger *dataManager;

@end

@implementation ABChargeListViewController

@synthesize tableView = _tableView;
@synthesize statisticsView  = _statisticsView;
@synthesize dataManager = _dataManager;

- (UITableView *)tableView
{
    if(!_tableView)
    {
        CGRect rect = self.view.bounds;
        rect.origin.y = CGRectGetMaxY(self.statisticsView.frame);
        rect.size.height = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.statisticsView.frame);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = ABDefaultBackgroudColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (ABStatisticsView *)statisticsView
{
    if(!_statisticsView)
    {
        _statisticsView = [[ABStatisticsView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
        _statisticsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statisticsView.delegate = self;
    }
    return _statisticsView;
}

- (ABChargeDataManger *)dataManager
{
    if(!_dataManager)
    {
        _dataManager = [[ABChargeDataManger alloc] init];
        _dataManager.delegate = self;
    }
    return _dataManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.statisticsView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(touchUpInsideRightBarButtonItem:)];
    
    [self.dataManager requestChargeDataWithCategoryID:self.categoryID];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
        cell = [[ABChargeListCell alloc] initWithStyle:UITableViewCellStyleSubtitle
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
            UIAlertController *alertContoller = [UIAlertController alertControllerWithTitle:@"您确定要删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertContoller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertContoller addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.dataManager requestRemoveIndex:indexPath.row];
            }]];
            [self presentViewController:alertContoller animated:YES completion:nil];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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

#pragma mark - ABStatisticsViewDelegate

- (void)statisticsView:(ABStatisticsView *)statisticsView didSelectStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    [self.dataManager requestCalculateAmountWithStartDate:startDate endDate:endDate];
}

#pragma mark - 其他

- (void)touchUpInsideRightBarButtonItem:(id)sender
{
    ABChargeEditViewController *controller = [[ABChargeEditViewController alloc] init];
    controller.chargeDataManager = self.dataManager;
    controller.editIndex = -1;
    controller.title = @"添加";
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - 数据处理

- (void)chargeDataMangerReloadData:(ABChargeDataManger *)manager
{
    [self.tableView reloadData];
}

- (void)chargeDataManger:(ABChargeDataManger *)manager removeIndex:(NSInteger)index
{
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)chargeDataManger:(ABChargeDataManger *)manager updateIndex:(NSInteger)index
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)chargeDataManger:(ABChargeDataManger *)manager addIndex:(NSInteger)index
{
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)chargeDataManger:(ABChargeDataManger *)chargeDataManger didCalculateAmount:(NSNumber *)amount startDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    self.statisticsView.startDate = startDate;
    self.statisticsView.endDate = endDate;
    [self.statisticsView updateStatisticsAmount:[amount floatValue]];
}

- (void)chargeDataManger:(ABChargeDataManger *)manager errorMessage:(NSString *)message
{
    if(message.length)
    {
        [MTProgressHUD showErrorWithMessge:message];
    }
}

@end
