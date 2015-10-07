//
//  ABChargeEditViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/30.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeEditViewController.h"
#import "ABDatePicker.h"
#import "ABChargeEditCell.h"

NSString *const ABChargeEditStartDate = @"开始日期";
NSString *const ABChargeEditEndDate = @"结束日期";
NSString *const ABChargeEditTitle = @"名称";
NSString *const ABChargeEditAmount = @"额度";
NSString *const ABChargeEditNotes = @"备注";


@interface ABChargeEditViewController ()<UITableViewDelegate, UITableViewDataSource, ABDatePickerDeleage>

@property (nonatomic, readonly) ABTableView *tableView;

@property (nonatomic, readonly) ABDatePicker *datePicker;

///是否是添加模式
@property (nonatomic) BOOL isAddMode;

///是否是编辑模式
@property (nonatomic) BOOL isEditMode;

@property (nonatomic, strong) ABChargeModel *model;

@end

@implementation ABChargeEditViewController
{
    NSIndexPath *_currentSelectedIndexPath;
}

@synthesize tableView = _tableView;
@synthesize datePicker = _datePicker;

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

- (ABDatePicker *)datePicker
{
    if(!_datePicker)
    {
        _datePicker = [[ABDatePicker alloc] init];
        _datePicker.delegate = self;
    }
    return _datePicker;
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
        
        self.model = [[ABChargeModel alloc] init];
        
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
    ABChargeEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(!cell)
    {
        cell = [[ABChargeEditCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.numberOfLines = 5;
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    NSString *title = [self listItem][indexPath.section][indexPath.row];
    cell.textLabel.text = title;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if([title isEqualToString:ABChargeEditStartDate])
    {
        cell.accessoryType = self.isEditMode ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [ABUtils dateString:self.model.startTimeInterval];
    }
    else if([title isEqualToString:ABChargeEditEndDate])
    {
        cell.accessoryType = self.isEditMode ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [ABUtils dateString:self.model.startTimeInterval];
    }
    else if([title isEqualToString:ABChargeEditTitle])
    {
        cell.detailTextLabel.text = self.model.title;
    }
    else if([title isEqualToString:ABChargeEditAmount])
    {
        if(self.model.amount > 0)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2lf", self.model.amount];
        }
    }
    else if([title isEqualToString:ABChargeEditNotes])
    {
        cell.detailTextLabel.text = self.model.notes;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.isEditMode)
    {
        return;
    }
    
    _currentSelectedIndexPath = indexPath;
    
    NSString *title = [self listItem][indexPath.section][indexPath.row];
    if([title isEqualToString:ABChargeEditStartDate])
    {
        [self.datePicker show];
    }
    else if([title isEqualToString:ABChargeEditEndDate])
    {
        [self.datePicker show];
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
}

#pragma mark - ABDatePickerDeleage

- (void)datePicker:(ABDatePicker *)picker didConfirmDate:(NSDate *)date
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentSelectedIndexPath];
    cell.detailTextLabel.text = [ABUtils localDateString:date];
    
    NSString *title = [self listItem][_currentSelectedIndexPath.section][_currentSelectedIndexPath.row];
    if([title isEqualToString:ABChargeEditStartDate])
    {
        self.model.startTimeInterval = [date timeIntervalSince1970];
    }
    else if([title isEqualToString:ABChargeEditEndDate])
    {
        self.model.endTimeInterval = [date timeIntervalSince1970];
    }
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
