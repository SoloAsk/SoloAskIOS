//
//  MineAskController.m
//  Fenda
//
//  Created by zhiwei on 16/6/27.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineAskController.h"
#import "MineAskCell.h"
#import "MineAskModel.h"
#import "UserManager.h"
#import "MJExtension.h"
#import "MBProgressHUD+NJ.h"
#import "MJRefresh.h"
#import "QuestionDetailController.h"
#import "NoQandAController.h"
#import "MinAnswerHeadView.h"
#import "MineAskHeadView.h"

@interface MineAskController ()

@property (nonatomic,strong) MineAskCell *mineAskCell;

@property (nonatomic,strong) NSMutableArray *data;

@end

@implementation MineAskController

static NSString *reuseIdentifier = @"mineAskCell";



-(void)loadData{
    
    UserManager *user = [UserManager sharedUserManager];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Question"];
    [bquery whereKey:@"askerid" equalTo:user.usid];
    //查找User表里面usid数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        
        
        if (error || !array) {
            [MBProgressHUD showError:@"加载数据失败"];
            [self.tableView.mj_header endRefreshing];
            return ;
        }
       
        
            for (BmobObject *bUser in array) {
                
                NSLog(@"objectID : %@",bUser.objectId);
                //                    NSLog(@"iconURL : %@",[bUser objectForKey:@"answerIconURL"]);
                
                [bquery getObjectInBackgroundWithId:bUser.objectId block:^(BmobObject *object,NSError *error){
                    
                    if (error){
                        [MBProgressHUD showError:@"加载数据失败"];
                        [self.tableView.mj_header endRefreshing];
                        return;
                    }
                  
                NSDictionary *dic = @{
                                                  @"iconURL":[object objectForKey:@"answerIconURL"],
                                                  @"userName":[object objectForKey:@"answerUserName"],
                                                  @"askPrice":[object objectForKey:@"askPrice"],
                                                  @"quesState":[object objectForKey:@"quesState"],
                                                  @"quesContent":[object objectForKey:@"askContent"],
                                                  @"quesTime":[object objectForKey:@"createdAt"],
                                                  @"listen":[object objectForKey:@"listenerNum"],
                                                  @"fenIncome":[object objectForKey:@"fenIncome"],
                                                  };
                            
                            MineAskModel *user = [MineAskModel mj_objectWithKeyValues:dic];
                            
                            [self.data addObject:user];
                            
                    // 刷新表格
                    [self.tableView reloadData];
                    
                    // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                    [self.tableView.mj_header endRefreshing];

                    
                }];
                
                
            }
        
       
        
        
    }];

}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我问", "");
    
    self.shareItem.hidden = YES;
    
    
//    [self example01];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineAskCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.mineAskCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
}

#pragma mark UITableView + 下拉刷新 默认
- (void)example01
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
     
        [self.data removeAllObjects];
        [weakSelf loadData];
       
        
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineAskCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
//    cell.mineAskModel = self.data[indexPath.section];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = [self.mineAskCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuestionDetailController *questionDetailVC = [[QuestionDetailController alloc] init];
    questionDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:questionDetailVC animated:YES];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //头部
    if (section == 0) {
        MineAskHeadView *headView = [[MineAskHeadView alloc] init];
        return headView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 46;
    }
    
    return 0;
}



@end
