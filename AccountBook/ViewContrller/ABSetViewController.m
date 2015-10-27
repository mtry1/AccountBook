//
//  ABSetViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/12.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABSetViewController.h"
#import "ABSafeLockViewController.h"
#import "ABSetDataManager.h"

@interface ABSetViewController ()<UITableViewDelegate, UITableViewDataSource, ABDataManagerTableCallBackDelegate>

@property (nonatomic, strong) ABTableView *tableView;

@property (nonatomic, readonly) ABSetDataManager *setDataManager;

@end

@implementation ABSetViewController

@synthesize tableView = _tableView;
@synthesize setDataManager = _setDataManager;

- (ABTableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[ABTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
    
    self.title = @"设置";
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    [self.setDataManager.callBackUtils addDelegate:self];
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
    
    if([title isEqualToString:ABSetTitleiCloud])
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
            [ABSafeLockViewController showInViewController:self openType:ABSafeLockOpenTypeStart completion:^(BOOL isCompleted) {
                
                if(!isCompleted)
                {
                    [sender setOn:!sender.on];
                }
                
                [self.setDataManager requestUpdateSwitchStatus:sender.on title:title];
            }];
        }
        else
        {
            [ABSafeLockViewController showInViewController:self openType:ABSafeLockOpenTypeClose completion:^(BOOL isCompleted) {
                
                if(!isCompleted)
                {
                    [sender setOn:!sender.on];
                }
                
                [self.setDataManager requestUpdateSwitchStatus:sender.on title:title];
            }];
        }
    }
}

#pragma mark - 数据刷新

- (void)dataManager:(ABDataManager *)manager updateIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
}

@end
