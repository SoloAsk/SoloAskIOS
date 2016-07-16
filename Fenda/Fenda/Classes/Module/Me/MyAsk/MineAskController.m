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
#import "MJExtension.h"
#import "MBProgressHUD+NJ.h"
#import "MJRefresh.h"
#import "QuestionDetailController.h"
#import "NoQandAController.h"
#import "MinAnswerHeadView.h"
#import "MineAskHeadView.h"


@interface MineAskController ()

@property (nonatomic,strong) MineAskCell *mineAskCell;


@end

@implementation MineAskController

static NSString *reuseIdentifier = @"mineAskCell";


-(void)loadData{
    
    [CloudTools queryMyAskWithBlock:^(NSArray *array, NSError *error) {
       
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
                
            }
            // 刷新表格
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
            
            
        }

        
    }];

}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我问", "");
    
    self.shareItem.hidden = YES;
    
    
    [self example01];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineAskCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.mineAskCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineAskCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.isWhat = 1;
    cell.qModel = self.data[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Question *qmodel = self.data[indexPath.row];
    
    self.mineAskCell.qModel = qmodel;
    
    CGSize size = [self.mineAskCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height +1;//必须+1，否则Label显示不全
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuestionDetailController *questionDetailVC = [[QuestionDetailController alloc] init];
    questionDetailVC.question = self.data[indexPath.row];
    questionDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:questionDetailVC animated:YES];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //头部
    if (section == 0) {
        MineAskHeadView *headView = [[MineAskHeadView alloc] init];
        headView.askCount = self.data.count;
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
