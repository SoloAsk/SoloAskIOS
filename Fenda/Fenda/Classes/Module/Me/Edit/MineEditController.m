//
//  MineEditController.m
//  Fenda
//
//  Created by zhiwei on 16/6/29.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineEditController.h"
#import "EditView.h"

@interface MineEditController ()

@end

@implementation MineEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - 初始化视图
-(void)setupUI{
    
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    myScrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+100);
    myScrollView.contentOffset = CGPointMake(0, 0);
    myScrollView.scrollEnabled = YES;
    
    EditView *editView = [[EditView alloc] init];
    editView.frame = myScrollView.bounds;
    
    [myScrollView addSubview:editView];
    [self.view addSubview:myScrollView];
    
    
    self.title = NSLocalizedString(@"编辑", "");
    BackBarBtnView *backview = [[BackBarBtnView alloc] init];
    backview.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backview];
}


@end
