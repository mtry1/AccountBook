//
//  ABSetViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/12.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABSetViewController.h"
#import "ABSetDataManager.h"
#import "ABMergeDataCenter.h"
#import "ABPasscodeHelper.h"

@interface ABSetViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) ABSetDataManager *setDataManager;

@end

@implementation ABSetViewController

@synthesize tableView = _tableView;
@synthesize setDataManager = _setDataManager;

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ABDefaultBackgroudColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (ABSetDataManager *)setDataManager
{
    if(!_setDataManager)
    {
        _setDataManager = [[ABSetDataManager alloc] init];
    }
    return _setDataManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"set", nil);
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.setDataManager.numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.setDataManager numberOfRowAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"reuseIdentifier"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.highlighted = NO;
    }
    
    NSString *title = [self.setDataManager titleAtIndexPath:indexPath];
    cell.textLabel.text = title;
    
    if([title isEqualToString:ABSetTitleiCloud] || [title isEqualToString:ABSetTitleGoAppraise])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.highlighted = NO;
        cell.accessoryView = [[UISwitch alloc] init];
        
        UISwitch *switchButton = (UISwitch *)cell.accessoryView;
        [switchButton addTarget:self
                         action:@selector(touchUpInsideSwitchButton:)
               forControlEvents:UIControlEventTouchUpInside];
        
        switchButton.on = [self.setDataManager boolForTitle:title];
        switchButton.tag = indexPath.section * 10 + indexPath.row;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell.textLabel.text isEqualToString:ABSetTitleiCloud])
    {
        [MTProgressHUD showLoadingWithMessage:NSLocalizedString(@"merging", nil)];
        [[ABMergeDataCenter sharedInstance] mergeCloudDataFinishedHandler:^(BOOL success, NSString *errorMessage) {
            [MTProgressHUD close];
            if(success)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ABMergeSuccessNotification object:nil];
            }
            else
            {
                if(errorMessage)
                {
                    [MTProgressHUD showErrorWithMessge:errorMessage];
                }
            }
        }];
    }
    else if([cell.textLabel.text isEqualToString:ABSetTitleGoAppraise])
    {
        [ABUtils openAppStoreAndEvaluate];
    }
}

#pragma mark - 点击事件

- (void)touchUpInsideSwitchButton:(UISwitch *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag % 10 inSection:sender.tag / 10];
    NSString *title = [self.setDataManager titleAtIndexPath:indexPath];
    if([title isEqualToString:ABSetTitleLock])
    {
        if(sender.on)
        {
            [ABPasscodeHelper setupPasscodeCompleteHandler:^(BOOL success) {
                if(!success)
                {
                    [sender setOn:!sender.isOn];
                }
            }];
        }
        else
        {
            [ABPasscodeHelper showPasscodeCompleteHandler:^(BOOL success) {
                if(!success)
                {
                    [sender setOn:!sender.isOn];
                }
            }];
        }
    }
    else if([title isEqualToString:ABSetTitleEndTimeRed])
    {
        [self.setDataManager requestUpdateSwitchStatus:sender.on title:title];
    }
}

@end
