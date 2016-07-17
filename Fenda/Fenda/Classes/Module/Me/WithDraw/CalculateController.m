//
//  CalculateController.m
//  Fenda
//
//  Created by zhiwei on 16/6/30.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "CalculateController.h"
#import "GetMoneyHeadView.h"

@interface CalculateController ()

@end

@implementation CalculateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"bUSER = %@",self.bUser);
    
    self.title = NSLocalizedString(@"提现", "");
    BackBarBtnView *backview = [[BackBarBtnView alloc] init];
    backview.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backview];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    myScrollView.scrollEnabled = YES;
    myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+100);
    myScrollView.contentOffset = CGPointMake(0, 0);
    
    GetMoneyHeadView *getView = [[GetMoneyHeadView alloc] init];
    getView.bUser = self.bUser;
    getView.finishBlock = ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    getView.frame = myScrollView.bounds;
    [myScrollView addSubview:getView];
    
    
    [self.view addSubview:myScrollView];
    
    
}

@end
