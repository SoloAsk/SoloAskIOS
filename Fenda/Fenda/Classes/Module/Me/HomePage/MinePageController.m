//
//  MinePageController.m
//  Fenda
//
//  Created by zhiwei on 16/6/19.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MinePageController.h"
#import "AskTableCell.h"
#import "MinePageHeaderView.h"
#import "QuestionDetailController.h"


@interface MinePageController ()

//头部已登录视图
@property (nonatomic, nonnull,strong) MinePageHeaderView *headerView;

@property (nonatomic,strong) AskTableCell *askCell;
@end

@implementation MinePageController

static NSString *reuseIdentifier = @"AskTableCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"我的主页", "");
    
    self.shareItem.hidden = YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
        self.headerView.user = [UserManager sharedUserManager];
        self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AskTableCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.askCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
}

-(MinePageHeaderView *)headerView{
  
    if (_headerView == nil) {
        _headerView = [[MinePageHeaderView alloc] init];
        
    }
    
    return _headerView;
}


#pragma mark - tableView 代理
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 10;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AskTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = [self.askCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
}

//给cell预估行高
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 172;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuestionDetailController *quesVC = [[QuestionDetailController alloc] init];
    quesVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:quesVC animated:YES];
}








@end
