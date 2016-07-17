//
//  MineListenController.m
//  Fenda
//
//  Created by zhiwei on 16/6/29.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineListenController.h"
#import "MineListenCell.h"
#import "QuestionDetailController.h"
#import "MineListenHeadView.h"
#import "NoQandAController.h"

@interface MineListenController ()

@property (nonatomic,strong) MineListenCell *listenCell;



@end

@implementation MineListenController

static NSString *reuseIdentifier = @"MineListenCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"我听", "");
    self.shareItem.hidden = YES;
    
    [self example01];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"MineListenCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.listenCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    
}


-(void)loadData{
    
    UserManager *user = [UserManager sharedUserManager];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Question"];
    
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"User"];
    [inQuery whereKey:@"objectId" equalTo:user.userObjectID];
    
    //匹配查询
    [bquery whereKey:@"heardUser" matchesQuery:inQuery];
    [bquery includeKey:@"askUser,answerUser"];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            [MBProgressHUD showError:@"加载数据失败"];
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        
        
        if (array.count == 0) {
            [MBProgressHUD showError:@"无结果"];
            [self.tableView.mj_header endRefreshing];
            
        }else if (array.count > 0){
            
            [self.data removeAllObjects];
            
            for (Question *question in array) {
                
                
                [self.data addObject:question];
                
                // 刷新表格
                [self.tableView reloadData];
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [self.tableView.mj_header endRefreshing];
                
                
            }
            
        }
        
        
        
    }];
    
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineListenCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.question = self.data[indexPath.row];
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        MineListenHeadView *headView = [[MineListenHeadView alloc] init];
        headView.askCount = self.data.count;
        return headView;
    }
    
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuestionDetailController *quesVC = [[QuestionDetailController alloc] init];
    quesVC.question = self.data[indexPath.row];
    quesVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:quesVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = [self.listenCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 46;
    }
    
    return 0;
}




@end
