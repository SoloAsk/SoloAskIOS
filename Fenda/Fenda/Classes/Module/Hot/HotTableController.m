//
//  HotTableController.m
//  Fenda
//
//  Created by zhiwei on 16/6/13.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "HotTableController.h"

#import "HotCell.h"
#import "HotModel.h"
#import "MJExtension.h"
#import "QuestionDetailController.h"
#import "MBProgressHUD+NJ.h"
#import "MJRefresh.h"


@interface HotTableController ()


@property (nonatomic,strong) HotCell *proCell;

@end

@implementation HotTableController

static NSString *reuseIdentifier = @"hotCell";

-(void)setupUI{
    
    self.backview.hidden = YES;
    self.shareItem.hidden = YES;
    
    self.title = NSLocalizedString(@"tab_name1", "");
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self example01];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.proCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    

}

#pragma mark - 加载网络数据
-(void)loadData{
    
    [CloudTools queryHotWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            [MBProgressHUD showError:@"加载数据失败"];
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        
        if (array.count == 0) {
            [MBProgressHUD showError:@"无结果"];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
        }else if (array.count > 0){
            
            //删除原有数据
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


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.question = self.data[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.data.count > 0) {
        QuestionDetailController *detailVC = [[QuestionDetailController alloc] init];
        Question *question = self.data[indexPath.row];
        detailVC.question = question;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        Question *model = self.data[indexPath.row];
        self.proCell.question = model;

    CGSize cellSize = [self.proCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return cellSize.height+1;
    
}







@end
