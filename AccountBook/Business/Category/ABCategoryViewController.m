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

#define ABCollectionViewColNumber (ABIPad ? 6 : 4)

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
        _dataManger.delegate = self;
    }
    return _dataManger;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"qmemo", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"add", nil) style:UIBarButtonItemStylePlain target:self action:@selector(touchUpInsideRightBarButtonItem:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"set", nil) style:UIBarButtonItemStylePlain target:self action:@selector(touchUpInsideLeftBarButtonItem:)];
    
    [self.view addSubview:self.collectionView];
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
            NSMutableString *title = [NSMutableString string];
            [title appendString:NSLocalizedString(@"edit", nil)];
            [title appendFormat:@" %@", model.name];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *renameAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"rename", nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action)
            {
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"rename", nil)
                                                                                    message:model.name
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                [controller addTextFieldWithConfigurationHandler:nil];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action)
                {
                    UITextField *textField = [[controller textFields] firstObject];
                    if(textField)
                    {
                        [self.dataManger requestRename:textField.text atIndex:indexPath.row];
                    }
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:nil];
                [controller addAction:okAction];
                [controller addAction:cancelAction];
                [self presentViewController:controller animated:YES completion:nil];
            }];
            
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"del", nil)
                                                                   style:UIAlertActionStyleDestructive
                                                                 handler:^(UIAlertAction * _Nonnull action)
            {
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"you_want_to_delete", nil) message:model.name preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action)
                {
                    [self.dataManger requestRemoveIndex:indexPath.row];
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:nil];
                
                [controller addAction:okAction];
                [controller addAction:cancelAction];
                [self presentViewController:controller animated:YES completion:nil];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
            
            [alertController addAction:renameAction];
            [alertController addAction:deleteAction];
            [alertController addAction:cancelAction];
            
            if(ABIPad)
            {
                UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
                popPresenter.sourceView = cell;
                popPresenter.sourceRect = cell.bounds;
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                [self presentViewController:alertController animated:YES completion:nil];
            }
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
    UIAlertController *alertContoller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"crete_title", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertContoller addTextFieldWithConfigurationHandler:nil];
    [alertContoller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
    [alertContoller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = [[alertContoller textFields] firstObject];
        if(textField && textField.text.length)
        {
            [self.dataManger requestAddObjectWithText:textField.text];
        }
    }]];
    [self presentViewController:alertContoller animated:YES completion:nil];
}

#pragma mark - 数据处理

- (void)categoryDataMangerReloadData:(ABCategoryDataManger *)manager
{
    [self.collectionView reloadData];
}

- (void)categoryDataManger:(ABCategoryDataManger *)manager addIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (void)categoryDataManger:(ABCategoryDataManger *)manager removeIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if(cell)
    {
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)categoryDataManger:(ABCategoryDataManger *)manager updateIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)categoryDataManger:(ABCategoryDataManger *)manger moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
}

@end
