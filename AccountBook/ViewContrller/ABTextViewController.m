//
//  ABTextViewController.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/11.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABTextViewController.h"

#import <AddressBook/AddressBook.h>

@interface ABTextViewController ()

@end

@implementation ABTextViewController

@synthesize textView = _textView;

- (UITextView *)textView
{
    if(!_textView)
    {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:16];
    }
    return _textView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.textView];
    
    [self.textView becomeFirstResponder];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(touchUpInsideRightBarButtonItem:)];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect rect = self.view.bounds;
    rect.size.height = 200;
    self.textView.frame = rect;
}

- (void)touchUpInsideRightBarButtonItem:(UIBarButtonItem *)sender
{
    if([self.delegate respondsToSelector:@selector(textViewController:didFinishedText:)])
    {
        [self.delegate textViewController:self didFinishedText:[self.textView.text trim]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
