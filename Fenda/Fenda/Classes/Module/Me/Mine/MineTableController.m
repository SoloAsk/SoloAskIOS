//
//  MineTableController.m
//  Fenda
//
//  Created by zhiwei on 16/6/13.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineTableController.h"

#import "MineHeadView.h"
#import "MJExtension.h"
#import "MineFooterView.h"
#import "MineHeaderLoginView.h"
#import "LoginController.h"
#import "UserManager.h"
#import "MinePageController.h"
#import "MineAskController.h"
#import "MineAnswerController.h"
#import "MineListenController.h"
#import "CalculateController.h"
#import "AboutController.h"
#import "MineEditController.h"
#import "NoQandAController.h"

@interface MineTableController ()<UMSocialUIDelegate>

@property (nonatomic,strong) NSArray *datas;

@property (nonatomic,assign) BOOL isLogin;

//头部已登录视图
@property (nonatomic, nonnull,strong) MineHeadView *headerView;

//头部未登录视图
@property (nonatomic,strong) MineHeaderLoginView *loginHeaderView;

//底部退出视图
@property (nonatomic,strong) MineFooterView *footerView;

@end

@implementation MineTableController

static NSString *reuseIdentifier = @"mineCell";



-(void)setupUI{
    
    self.backview.hidden = YES;
//    self.shareItem.hidden = YES;
    
    self.title = NSLocalizedString(@"tab_name3", "");
    
}



#pragma mark - 头部已登录视图
-(MineHeadView *)headerView{
    
    __weak __typeof__(self) weakSelf = self;
    if (_headerView == nil) {
        _headerView = [[MineHeadView alloc] init];
        _headerView.editBlock = ^{
            
            MineEditController *editVC = [[MineEditController alloc] init];
            editVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:editVC animated:YES];
        };
       
    }
    
    return _headerView;
}

#pragma mark - 头部未登录视图
-(MineHeaderLoginView *)loginHeaderView{
    
    if (_loginHeaderView == nil) {
        _loginHeaderView = [[MineHeaderLoginView alloc] init];
        
        __weak __typeof__(self) weakSelf = self;
        _loginHeaderView.loginBlock = ^{
            //跳转到登录视图
            LoginController *loginVC = [[LoginController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:loginVC animated:YES];
        };
    }
    
    return _loginHeaderView;
}

#pragma mark - 底部退出视图
-(MineFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [[MineFooterView alloc] init];
        
        __weak __typeof__(self) weakSelf = self;
        _footerView.logoutBlock = ^{
            
            
            
            weakSelf.tableView.tableHeaderView = weakSelf.loginHeaderView;
            
            //保存退出状态
            [UserManager sharedUserManager].isLogin = NO;
            [weakSelf tableView:weakSelf.tableView viewForFooterInSection:3];
            [weakSelf.tableView reloadData];
        };

    }
    return _footerView;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.isLogin) {
//        NSLog(@"现在是已登录成功状态");
        self.headerView.user = [UserManager sharedUserManager];
        self.tableView.tableHeaderView = self.headerView;
        
    }else{
//        NSLog(@"现在是未登录状态");
        
        self.tableView.tableHeaderView = self.loginHeaderView;
    }
}

-(BOOL)isLogin{
    
    return [UserManager sharedUserManager].isLogin;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    
    self.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;

}


#pragma mark - UM实现回调方法：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}




-(NSArray *)datas{
    
    if (_datas == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Mine.plist" ofType:nil];
        _datas = [NSArray mj_objectArrayWithFile:path];
    }
    
    return _datas;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *rowsArray = self.datas[section];
    return rowsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSArray *sectionArray = self.datas[indexPath.section];
    NSDictionary *rowDic = sectionArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:rowDic[@"icon"]];
    cell.textLabel.text = NSLocalizedString(rowDic[@"title"], "");
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *sectionArray = self.datas[indexPath.section];
    NSDictionary *rowDic = sectionArray[indexPath.row];
    NSString *className = rowDic[@"className"];
    
    
    //模拟数据
    BOOL isLogin = YES;
    BOOL isHave = YES;//我问、我答、我听没有数据
    
    
    if (indexPath.section == 2 && indexPath.row == 1) {//关于
        [self pushuVCWithClassName:className];
        return;
    }
    
    
        if (!isLogin) {//未登录
        [self pushuVCWithClassName:@"LoginController"];
        return;
    }
    
    
        if (((indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 3) ) && (indexPath.section == 1)) {
           
            if (!isHave) {
                NoQandAController *noVC = [[NoQandAController alloc] init];
                noVC.hidesBottomBarWhenPushed = YES;
                noVC.cid = indexPath.row;
                [self.navigationController pushViewController:noVC animated:YES];
                return;
            }
            
           [self pushuVCWithClassName:className];
            return;
        }
    
           
    [self pushuVCWithClassName:className];
    
        
  
        
    
 
}


-(void)pushuVCWithClassName:(NSString *)cName{
    
    Class c = NSClassFromString(cName);
    UIViewController *VC = [[c alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 3) {
        
        if (self.isLogin) {
            return self.footerView;
        }
        return nil;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 3) {
        return 60;
    }
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}





@end
