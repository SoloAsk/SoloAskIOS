//
//  MineAnswerController.m
//  Fenda
//
//  Created by zhiwei on 16/6/28.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineAnswerController.h"
#import "MineAskCell.h"
#import "MinAnswerHeadView.h"
#import "AnswerVoiceController.h"
#import "QuestionModel.h"
#import "UserManager.h"
#import "Question.h"
#import "QuestionDetailController.h"


@interface MineAnswerController ()

@property (nonatomic,strong) MineAskCell *mineAskCell;



@end

@implementation MineAnswerController

static NSString *reuseIdentifier = @"mineAskCell";




-(void)loadData{
    
    [CloudTools queryMyAnswerWithBlock:^(NSArray *array, NSError *error) {
       
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






- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我答", "");
    
    [self example01];
    
    self.shareItem.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineAskCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.mineAskCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineAskCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.isWhat = 2;
    cell.qModel = self.data[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.mineAskCell.qModel = self.data[indexPath.row];
    
    CGSize size = [self.mineAskCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Question *ques = self.data[indexPath.row];
    
    if ([[ques objectForKey:@"state"]  isEqual: @0]) {//未回答
        
        AnswerVoiceController *answerVC = [[AnswerVoiceController alloc] init];
        answerVC.hidesBottomBarWhenPushed = YES;
        answerVC.quesModel = self.data[indexPath.row];
        [self.navigationController pushViewController:answerVC animated:YES];
        
    }else if([[ques objectForKey:@"state"]  isEqual: @1]){//已回答
        
        QuestionDetailController *detailVC = [[QuestionDetailController alloc] init];
        detailVC.question = ques;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    
        
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //头部
    if (section == 0) {
        MinAnswerHeadView *headView = [[MinAnswerHeadView alloc] init];
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
