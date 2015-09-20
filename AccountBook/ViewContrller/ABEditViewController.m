//
//  ABEditViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABEditViewController.h"

@interface ABEditViewController ()<UITableViewDelegate, UITableViewDataSource, ABMainDataMangerDelegate>

@property (nonatomic, readonly) UITableView *tableView;

@end

@implementation ABEditViewController

@synthesize tableView = _tableView;

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(touchUpInsideRightBarButtonItem:)];
    
    [self.view addSubview:self.tableView];
    
    [self.mainDataManager addDelegate:self];
    [self.tableView setEditing:YES animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainDataManager.numberOfItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"eidtIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ABCategoryModel *model = [self.mainDataManager dataAtIndex:indexPath.row];
    if(model)
    {
        cell.textLabel.text = model.name;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if(sourceIndexPath.row != destinationIndexPath.row)
    {
        [self.mainDataManager moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        ABCategoryModel *model = [self.mainDataManager dataAtIndex:indexPath.row];
        if(model)
        {
            ABAlertView *alertView = [[ABAlertView alloc] initWithTitle:@"您确定要删除"
                                                                message:model.name
                                                               delegate:nil
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            [alertView showUsingClickButtonBlock:^(UIAlertView *alertView, NSUInteger atIndex) {
                
                if(atIndex == alertView.cancelButtonIndex)
                {
                }
                else
                {
                    [self.mainDataManager removeIndex:indexPath.row];
                }
            }];
        }
    }
}

#pragma mark - 其它

- (void)touchUpInsideRightBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
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

@end
