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
#import "AnswerVoiceController.h"


@interface HotTableController ()


@property (nonatomic,strong) HotCell *proCell;

//防止多次跳转
@property (nonatomic,assign) NSInteger jump;
@property (nonatomic,assign) NSInteger jump2;

@end

@implementation HotTableController

static NSString *reuseIdentifier = @"hotCell";

-(void)setupUI{
    
    self.backview.hidden = YES;
    self.shareItem.hidden = YES;
    
    self.title = NSLocalizedString(@"tab_name1", "");
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.jump = 0;
    self.jump2 = 0;
    //接收到远程通知
    //我问
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeAskOpenAction:) name:@"noticeAskOpen" object:nil];
    //我答
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeAnswerOpenAction:) name:@"noticeAnswerOpen" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
//
}


-(void)noticeAnswerOpenAction:(NSNotification *)noti{
    
    
   
        NSDictionary *userInfoDic = (NSDictionary *)[noti object];
        
        if (userInfoDic[@"aps"][@"questionID"]) {
            
            //查找GameScore表
            BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Question"];
            [bquery includeKey:@"askUser,answerUser"];
            //查找GameScore表里面id为0c6db13c的数据
            [bquery getObjectInBackgroundWithId:userInfoDic[@"aps"][@"questionID"] block:^(BmobObject *object,NSError *error){
                if (error){
                    //进行错误处理
                }else{
                    
                    if (object) {
                        
                        
                        
                        if (self.jump2 == 0) {
                            self.jump2++;
                            QuestionDetailController *detailVC = [[QuestionDetailController alloc] init];
                            detailVC.question = (Question *)object;
                            detailVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:detailVC animated:YES];
                            
                            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"noticeAnswerOpen" object:nil];
                        }
                        
                        
                        
                       
                    }
                }
            }];
            
        }

    
    
    
    
}


-(void)noticeAskOpenAction:(NSNotification *)noti{
    
    
    
    NSDictionary *userInfoDic = (NSDictionary *)[noti object];
    
    if (userInfoDic[@"aps"][@"questionID"]) {
        
        //查找GameScore表
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Question"];
        [bquery includeKey:@"askUser,answerUser"];
        //查找GameScore表里面id为0c6db13c的数据
        [bquery getObjectInBackgroundWithId:userInfoDic[@"aps"][@"questionID"] block:^(BmobObject *object,NSError *error){
            if (error){
                //进行错误处理
            }else{
                
                if (object) {
                    
                    
                    
                    if (self.jump == 0) {
                        self.jump++;
                        AnswerVoiceController *detailVC = [[AnswerVoiceController alloc] init];
                        detailVC.quesModel = (Question *)object;
                        detailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:detailVC animated:YES];
                        
                        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"noticeAskOpen" object:nil];
                    }
                    
                    
                    
                    
                }
            }
        }];
        
    }
    
    
    
    
    
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
