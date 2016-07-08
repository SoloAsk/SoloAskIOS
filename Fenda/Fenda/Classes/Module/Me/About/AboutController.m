//
//  AboutController.m
//  Fenda
//
//  Created by zhiwei on 16/6/19.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()

@end

@implementation AboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    BackBarBtnView *backview = [[BackBarBtnView alloc] init];
    backview.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backview];
    
    self.title = NSLocalizedString(@"title_about", "");
}



@end
