//
//  HotTableController.m
//  Fenda
//
//  Created by zhiwei on 16/6/13.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "HotTableController.h"

#import "HotCell.h"
//#import "QuestionModel.h"
#import "HotModel.h"
#import "MJExtension.h"
#import "QuestionDetailController.h"
#import "MBProgressHUD+NJ.h"
#import "MJRefresh.h"


@interface HotTableController ()

@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,strong) HotCell *proCell;

@end

@implementation HotTableController

static NSString *reuseIdentifier = @"hotCell";

static const CGFloat MJDuration = 2.0;

-(void)setupUI{
    
    self.backview.hidden = YES;
    self.shareItem.hidden = YES;
    
    self.title = NSLocalizedString(@"tab_name1", "");
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self example01];
//    [self example11];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.proCell = [self.tableView dequeueReusableCellWithIdentifier:@"hotCell"];
    

}

#pragma mark - 加载网络数据
-(void)loadData{
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Question"];
    
    [bquery includeKey:@"askUser"];
    [bquery includeKey:@"answerUser"];
    
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

-(NSMutableArray *)data{
    
    if (_data == nil) {
        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"HotCellData.plist" ofType:nil];
//        
//        _data = [HotModel mj_objectArrayWithFile:path];
        
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
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf loadData];
            // 刷新表格
            [self.tableView reloadData];
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            
            [self.tableView.mj_header endRefreshing];
            
        });
        
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark UITableView + 上拉刷新 默认
- (void)example11
{
    [self example01];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        [weakSelf loadData];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
    
    // 马上进入刷新状态
//    [self.tableView.mj_footer beginRefreshing];
}

#pragma mark 只加载一次数据
- (void)loadOnceData
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        NSDictionary *dic = @{@"listener":@32,
                              @"isFree":@0,
                              @"iconURL":@"杨紫",
                              @"askerDesc":@"The grass root / soil round",
                              @"askerName":@"Qiu Yingying",
                              @"question":@"\"Ode to joy\" scraper, has a good reputation, in addition to play forcibly implanted narrator, from everywhere, a lot of people love songs, love Andy, fell in love with the old Tan, fell in love with the Fan Shengmei, but alone to here Yang Zi played Qiu Yingying, state of sharp, have open hand tore Qiu Yingying mode."};
        [self.data addObject:[HotModel mj_objectWithKeyValues:dic]];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // 隐藏当前的上拉刷新控件
//        self.tableView.mj_footer.hidden = YES;
    });
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
    
    QuestionDetailController *detailVC = [[QuestionDetailController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    Question *model = self.data[indexPath.row];
    
    self.proCell.question = model;
    
    CGSize cellSize = [self.proCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return cellSize.height;
    
}







@end
