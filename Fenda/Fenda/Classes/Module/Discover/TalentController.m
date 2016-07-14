//
//  TalentController.m
//  Fenda
//
//  Created by zhiwei on 16/6/20.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "TalentController.h"
#import "TalentCell.h"
#import "AskTableController.h"
#import "UserModel.h"
#import "MJExtension.h"
#import "UserManager.h"
#import "LoginController.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+NJ.h"

#import "UIView+MJExtension.h"
#import "UIViewController+Example.h"
#import "MJRefresh.h"



@interface TalentController ()

@property (nonatomic,strong) TalentCell *talentCell;

@property (strong, nonatomic) NSMutableArray *data;


@end

@implementation TalentController

static NSString *reuseIdentifier = @"TalentCell";


-(void)setupUI{
    
    self.backview.hidden = YES;
    self.shareItem.hidden = YES;
    
    self.title = NSLocalizedString(@"tab_name2", "");
}


#pragma mark - 加载网络数据
-(void)loadData{
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    
    //查找User表里面usid数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            [MBProgressHUD showError:@"加载数据失败"];
            [self.tableView.mj_header endRefreshing];
            return;
        }
       
            
        for (User *bUser in array) {
            
                [self.data addObject:bUser];
            }
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [self.tableView.mj_header endRefreshing];
        
    }];
    

}


-(NSMutableArray *)data{
    
    if (_data == nil) {
        
        _data = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _data;
}

#pragma mark UITableView + 下拉刷新 默认
- (void)example01
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadNewData];
        [self.data removeAllObjects];
        [weakSelf loadData];
        
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TalentCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.talentCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    [self.tableView setSeparatorColor:TABLE_LINE_COLOR];
    
    [self example01];
    
//    [[UITableView appearance] setSeparatorColor:TABLE_LINE_COLOR];
    
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TalentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.bUser = self.data[indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = [self.talentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserManager *mUser = [UserManager sharedUserManager];
    
    if (mUser.isLogin) {
        
        User *bUser = self.data[indexPath.row];
        
        if ([[bUser objectForKey:@"userId"] isEqualToString:mUser.userId]) {
            
//            NSLog(@"userModelid = %@,mUserid = %@",user.usid,mUser.userId);
            
   
            
            [MBProgressHUD showError:@"不能提问自己"];
            
            
        }else{
            
            AskTableController *askVC = [[AskTableController alloc] init];
            askVC.bUser = self.data[indexPath.row];
            askVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:askVC animated:YES];
        }

        
    }else{
        
        LoginController *loginVC = [[LoginController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
    
    
}

@end
