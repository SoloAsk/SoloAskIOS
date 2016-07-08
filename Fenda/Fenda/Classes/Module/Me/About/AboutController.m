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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
