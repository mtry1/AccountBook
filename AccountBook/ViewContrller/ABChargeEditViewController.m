//
//  ABChargeEditViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/30.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeEditViewController.h"

NSString *const ABChargeEditStartDate = @"开始日期";
NSString *const ABChargeEditEndDate = @"结束日期";
NSString *const ABChargeEditTitle = @"名称";
NSString *const ABChargeEditAmount = @"额度";
NSString *const ABChargeEditNotes = @"备注";


@interface ABChargeEditViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) ABTableView *tableView;

///是否是添加模式
@property (nonatomic) BOOL isAddMode;

///是否是编辑模式
@property (nonatomic) BOOL isEditMode;

@property (nonatomic, strong) ABChargeModel *model;

@end

@implementation ABChargeEditViewController

@synthesize tableView = _tableView;

- (ABTableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[ABTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 10;
        _tableView.sectionFooterHeight = 0;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 10)];
    }
    return _tableView;
}

- (NSArray *)listItem
{
    return @[@[ABChargeEditStartDate, ABChargeEditEndDate],
             @[ABChargeEditTitle],
             @[ABChargeEditAmount],
             @[ABChargeEditNotes]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isAddMode = self.index >= 0 ? NO : YES;
    if(self.isAddMode)
    {
        self.isEditMode = YES;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(touchLeftBarButtonItem:)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(touchRightBarButtonItem:)];
    }
    else
    {
        self.isEditMode = NO;
        
        self.model = [self.dataManager dataAtIndex:self.index];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(touchRightBarButtonItem:)];
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self listItem].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self listItem][section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self listItem][indexPath.section][indexPath.row];
    if([title isEqualToString:ABChargeEditNotes])
    {
        return 100;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(!cell)
    {
        cell = [[ABTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSString *title = [self listItem][indexPath.section][indexPath.row];
    cell.textLabel.text = title;
    
    if([title isEqualToString:ABChargeEditStartDate])
    {
        cell.accessoryType = self.isEditMode ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    }
    else if([title isEqualToString:ABChargeEditEndDate])
    {
        cell.accessoryType = self.isEditMode ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    }
    else if([title isEqualToString:ABChargeEditTitle])
    {
        
    }
    else if([title isEqualToString:ABChargeEditAmount])
    {
        
    }
    else if([title isEqualToString:ABChargeEditNotes])
    {
        
    }
    
    return cell;
}

#pragma mark - 点击事件

- (void)touchLeftBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if(self.isAddMode)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)touchRightBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if(self.isAddMode)
    {
        [self.dataManager requestAddModel:self.model];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        self.isEditMode = !self.isEditMode;
        
        if(self.isEditMode)
        {
            self.navigationItem.rightBarButtonItem.title = @"完成";
        }
        else
        {
            self.navigationItem.rightBarButtonItem.title = @"编辑";
        }
        
        [self.tableView reloadData];
    }
}

@end
