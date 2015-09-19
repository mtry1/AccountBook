//
//  ABMainViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/12.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABMainViewController.h"
#import "ABSetViewController.h"
#import "ABDetailsViewController.h"
#import "ABMainCollectionViewCell.h"
#import "ABMainDataManger.h"

CGFloat const ABMainCollectionViewCellSpace = 5.0f;
NSInteger const ABMainCollectionViewMaxColNumber = 4;

static NSString *ABMainCollectionViewReuseIdentifier = @"ABMainCollectionViewReuseIdentifier";

@interface ABMainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ABMainDataMangerDelegate>

@property (nonatomic, readonly) UICollectionView *collectionView;

@property (nonatomic, readonly) ABMainDataManger *mainDataManger;

@end

@implementation ABMainViewController

@synthesize collectionView = _collectionView;
@synthesize mainDataManger = _mainDataManger;

- (UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[ABMainCollectionViewCell class]
            forCellWithReuseIdentifier:ABMainCollectionViewReuseIdentifier];
    }
    return _collectionView;
}

- (ABMainDataManger *)mainDataManger
{
    if(!_mainDataManger)
    {
        _mainDataManger = [[ABMainDataManger alloc] init];
    }
    return _mainDataManger;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"随身记";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(touchUpInsideRightBarButtonItem:)];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    
    [self.mainDataManger requestInitData];
    
    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for(indFamily=0;indFamily<[familyNames count];++indFamily)
        
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        
        for(indFont=0; indFont<[fontNames count]; ++indFont)
            
        {
            NSLog(@"Font name: %@",[fontNames objectAtIndex:indFont]);
            
        }
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mainDataManger.numberOfItem;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ABMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ABMainCollectionViewReuseIdentifier forIndexPath:indexPath];
    
    ABCategoryModel *model = [self.mainDataManger dataAtIndex:indexPath.row];
    if(model)
    {
        [cell reloadWithModel:model];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
    if(indexPath.row < self.mainDataManger.numberOfItem - 1)
    {
        ABCategoryModel *model = [self.mainDataManger dataAtIndex:indexPath.row];
        if(model)
        {
            ABDetailsViewController *controller = [[ABDetailsViewController alloc] init];
            controller.title = model.name;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    size.width = (CGRectGetWidth(self.view.frame) - (ABMainCollectionViewMaxColNumber + 1) * ABMainCollectionViewCellSpace) / ABMainCollectionViewMaxColNumber;
    size.height = size.width;
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, ABMainCollectionViewCellSpace, 0, ABMainCollectionViewCellSpace);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return ABMainCollectionViewCellSpace * 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return ABMainCollectionViewCellSpace;
}

#pragma mark - 其它

- (void)touchUpInsideRightBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    ABSetViewController *controller = [[ABSetViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 数据处理

- (void)dataManagerReloadData:(ABDataManager *)manager
{
    [self.collectionView reloadData];
}

@end
