//
//  TabbarController.m
//  Fenda
//
//  Created by zhiwei on 16/6/19.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "TabbarController.h"

@interface TabbarController ()

@end

@implementation TabbarController










- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [[self.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"tab_name1", "")];
    [[self.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"tab_name2", "")];
    [[self.tabBar.items objectAtIndex:2] setTitle:NSLocalizedString(@"tab_name3", "")];
    
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
