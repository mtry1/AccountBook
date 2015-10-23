//
//  ABCategoryViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/12.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABCategoryViewController.h"
#import "ABSetViewController.h"
#import "ABChargeListViewController.h"
#import "ABCategoryCell.h"
#import "ABCategoryDataManger.h"

CGFloat const ABCollectionViewCellSpace = 5.0f;
CGFloat const ABCollectionViewSpacingForSection = 10.0f;
CGFloat const ABCollectionViewSpacingForTop = 20.0f;
NSInteger const ABCollectionViewColNumber = 4;

static NSString *ABCollectionViewReuseIdentifier = @"ABCollectionViewReuseIdentifier";

@interface ABCategoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ABCategoryDataMangerDelegate, ABCategoryCellDelegate>

@property (nonatomic, readonly) UICollectionView *collectionView;

@property (nonatomic, readonly) ABCategoryDataManger *dataManger;

@end

@implementation ABCategoryViewController

@synthesize collectionView = _collectionView;
@synthesize dataManger = _dataManger;

- (UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithUInt:0xf4f4f4];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[ABCategoryCell class]
            forCellWithReuseIdentifier:ABCollectionViewReuseIdentifier];
    }
    return _collectionView;
}

- (ABCategoryDataManger *)dataManger
{
    if(!_dataManger)
    {
        _dataManger = [[ABCategoryDataManger alloc] init];
    }
    return _dataManger;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"随身记";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(touchUpInsideRightBarButtonItem:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(touchUpInsideLeftBarButtonItem:)];
    
    [self.view addSubview:self.collectionView];
    
    [self.dataManger.callBackUtils addDelegate:self];
    [self.dataManger requestInitData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataManger.numberOfItem;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ABCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ABCollectionViewReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    ABCategoryModel *model = [self.dataManger dataAtIndex:indexPath.row];
    if(model)
    {
        [cell reloadWithModel:model];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ABCategoryModel *model = [self.dataManger dataAtIndex:indexPath.row];
    if(model)
    {
        ABChargeListViewController *controller = [[ABChargeListViewController alloc] init];
        controller.title = model.name;
        controller.categoryID = model.categoryID;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    size.width = (CGRectGetWidth(self.view.frame) - (ABCollectionViewColNumber + 1) * ABCollectionViewCellSpace) / ABCollectionViewColNumber;
    size.height = size.width;
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(ABCollectionViewSpacingForTop, ABCollectionViewCellSpace, 0, ABCollectionViewCellSpace);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return ABCollectionViewSpacingForSection;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return ABCollectionViewCellSpace;
}

#pragma mark - ABCategoryCellDelegate

- (void)categoryCellDidLongPress:(ABCategoryCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if(indexPath)
    {
        ABCategoryModel *model = [self.dataManger dataAtIndex:indexPath.row];
        if(model)
        {
            NSString *title = [NSString stringWithFormat:@"修改“%@”", model.name];
            ABActionSheet *actionSheet = [[ABActionSheet alloc] initWithTitle:title
                                                                     delegate:nil
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:@"删除"
                                                            otherButtonTitles:@"重命名", nil];
            [actionSheet showInView:self.navigationController.view clickButtonBlock:^(UIActionSheet *actionSheet, NSUInteger buttonIndex) {
               
                if(buttonIndex == 0)
                {
                    NSString *title = [NSString stringWithFormat:@"重命名“%@”", model.name];
                    ABAlertView *alertView = [[ABAlertView alloc] initWithTitle:title
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"确定", nil];
                    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    [alertView showUsingClickButtonBlock:^(UIAlertView *alertView, NSUInteger atIndex) {
                        
                        if(atIndex != alertView.cancelButtonIndex)
                        {
                            UITextField *textField = [alertView textFieldAtIndex:0];
                            if(textField)
                            {
                                [self.dataManger requestRename:textField.text atIndex:indexPath.row];
                            }
                        }
                    }];
                }
                else if(buttonIndex == 1)
                {
                    ABAlertView *alertView = [[ABAlertView alloc] initWithTitle:@"您确定要删除"
                                                                        message:model.name
                                                                       delegate:nil
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"确定", nil];
                    [alertView showUsingClickButtonBlock:^(UIAlertView *alertView, NSUInteger atIndex) {
                        
                        if(atIndex != alertView.cancelButtonIndex)
                        {
                            [self.dataManger requestRemoveIndex:indexPath.row];
                        }
                    }];
                }
            }];
        }
    }
}

#pragma mark - 其它

- (void)touchUpInsideLeftBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    ABSetViewController *controller = [[ABSetViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)touchUpInsideRightBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    ABAlertView *alertView = [[ABAlertView alloc] initWithTitle:@"建议两个中文字哦"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView showUsingClickButtonBlock:^(UIAlertView *alertView, NSUInteger atIndex) {
        
        if(atIndex != alertView.cancelButtonIndex)
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            if(textField && textField.text.length)
            {
                [self.dataManger requestAddObjectWithText:textField.text];
            }
        }
    }];
}

#pragma mark - 数据处理

- (void)dataManagerReloadData:(ABDataManager *)manager
{
    [self.collectionView reloadData];
}

- (void)dataManager:(ABDataManager *)manager addIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (void)dataManager:(ABDataManager *)manager removeIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if(cell)
    {
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)dataManager:(ABDataManager *)manager updateIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)categoryDataManger:(ABCategoryDataManger *)manger moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
}

@end
