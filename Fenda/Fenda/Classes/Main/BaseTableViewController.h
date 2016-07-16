//
//  BaseTableViewController.h
//  Fenda
//
//  Created by zhiwei on 16/7/5.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareBtnView.h"
#import "Reachability.h"//监听网络状态
#import "MBProgressHUD+NJ.h"


@interface BaseTableViewController : UITableViewController

@property (nonatomic,weak) BackBarBtnView *backview;

@property (nonatomic,weak) ShareBtnView *shareItem;

//是否有网络，yes有，no没有
@property (nonatomic,assign) BOOL canReachability;

//存储下拉刷新数据
@property (nonatomic,strong) NSMutableArray *data;

/*下拉刷新 相关*/
- (void)example01;
-(void)loadData;

#pragma mark - 分享按钮（自定义弹出界面）
-(void)itemShareAction;


@end
