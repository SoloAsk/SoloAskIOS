//
//  AskTableController.m
//  Fenda
//
//  Created by zhiwei on 16/6/15.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "AskTableController.h"
#import "AskHeaderView.h"
#import "AskTableCell.h"
#import "IQKeyboardManager.h"
#import "SVProgressHUD.h"
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD+NJ.h"
#import "QuestionModel.h"
#import "MJExtension.h"
#import "UserManager.h"
#import "MineAskController.h"
#import "QuestionDetailController.h"
#import "TabbarController.h"





@interface AskTableController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver,UMSocialUIDelegate>

@property (nonatomic,strong) AskTableCell *askCell;

@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,strong) QuestionModel *questionModel;

//点击finish返回的内容
@property (nonatomic,strong) NSDictionary *askDic;

@property (nonatomic,strong) NSMutableArray *data;

@end

@implementation AskTableController
static NSString *reuseIdentifier = @"AskTableCell";

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
   [self setupUI];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"提问", "");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AskTableCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.askCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    [self example01];
}

#pragma mark - 加载网络数据
-(void)loadData{
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Question"];
    
    [bquery whereKey:@"answerUser" equalTo:self.bUser];
    [bquery includeKey:@"answerUser,askUser"];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            [MBProgressHUD showError:@"请检查网络"];
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        
        if (array.count == 0) {
//            [MBProgressHUD showError:@"无结果"];
            [self.tableView.mj_header endRefreshing];
            
        }else if (array.count > 0){
            
            for (Question *question in array) {
                
                [self.data addObject:question];
                
            }
            
            // 刷新表格
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
        }
        
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
        
            [self.data removeAllObjects];
            [weakSelf loadData];
    
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}



#pragma mark - 界面将要展示时要做的事情
-(void)setupUI{
    
    
    
    AskHeaderView *askView = [[AskHeaderView alloc]init];
    askView.bUser = self.bUser;

    askView.editBlock = ^(NSDictionary *dic){
        
        
        self.askDic = dic;
        

        
//        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        self.hud.labelText = @"请稍后";
//        [self.hud show:YES];
//        [self.hud hide:YES afterDelay:5];
        
        [self saveQuestion];

        
        //请求可售商品
//        NSSet *productSet = [NSSet setWithArray:@[@"soloask.listen"]];
//        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
//        request.delegate = self;
//        [request start];
        
    };
    
    
    self.tableView.tableHeaderView = askView;
 
}

//将问题保存到云端
-(void)saveQuestion{
    

    
//    [MBProgressHUD showMessage:@"请稍后..."];
    
    BmobObject  *post = [BmobObject objectWithClassName:@"Question"];
    //设置问题内容、价格、是否公开
    [post setObject:self.askDic[@"quesContent"] forKey:@"quesContent"];
    [post setObject:self.askDic[@"quesPrice"] forKey:@"quesPrice"];
    [post setObject:[NSNumber numberWithBool:self.askDic[@"isPublic"]] forKey:@"isPublic"];
    [post setObject:@0 forKey:@"state"];
    [post setObject:@0 forKey:@"listenerNum"];
    [post setObject:[Tools stringFromDate:[NSDate date]] forKey:@"askTime"];
    
    
    //设置问题关联的提问者记录
    UserManager *localUser = [UserManager sharedUserManager];
    BmobObject *askerUser = [BmobObject objectWithoutDataWithClassName:@"User" objectId:localUser.objectId];
    [post setObject:askerUser forKey:@"askUser"];
    

    
    //设置问题关联的回答者记录
    BmobObject *answerUser = [BmobObject objectWithoutDataWithClassName:@"User" objectId:self.bUser.objectId];
    [post setObject:answerUser forKey:@"answerUser"];
    
    
    
    //异步保存
    [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            
            [MBProgressHUD showSuccess:@"提问成功"];
//            [self.navigationController popViewControllerAnimated:YES];
            //提问成功跳到详情页
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            
//            TabbarController *tabVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TabbarController"];
//            tabVC.selectedIndex = 2;
//            window.rootViewController = tabVC;
            QuestionDetailController *detailVC = [[QuestionDetailController alloc] init];
            
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"Question"];
            
            [bquery includeKey:@"askUser,answerUser"];
            [bquery getObjectInBackgroundWithId:post.objectId block:^(BmobObject *object, NSError *error) {
                
                
                if (object) {
                    detailVC.question = (Question *)object;
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
                
            }];
            
           
            
            
            
            
            
            
        }else{
            if (error) {

                [MBProgressHUD showError:@"提问失败"];
            }
        }
    }];
    
}

#pragma mark - 内购代理
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    for (SKProduct *product in response.products) {
        
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        
    }
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    /*
     SKPaymentTransactionStatePurchasing, 正在购买,不需要做处理
     SKPaymentTransactionStatePurchased, 购买成功,给用户对应的商品,并且停止该交易
     SKPaymentTransactionStateFailed, 购买失败,不需要做处理
     SKPaymentTransactionStateRestored, 恢复购买,给用户商品,并且停止交易
     SKPaymentTransactionStateDeferred 未决定的,不需要做处理
     */
    

    
    for (SKPaymentTransaction *transacion in transactions) {
        switch (transacion.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                break;
                
            case SKPaymentTransactionStatePurchased:
                
            {
                
                [self saveQuestion];
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"购买成功"];
                [queue finishTransaction:transacion];
            }
                
                
                break;
                
            case SKPaymentTransactionStateFailed:
                [queue finishTransaction:transacion];
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"购买失败"];
                break;
                
            case SKPaymentTransactionStateRestored:
                [MBProgressHUD showError:@"恢复购买"];
                [MBProgressHUD hideHUD];
                [queue finishTransaction:transacion];
                
                break;
                
            case SKPaymentTransactionStateDeferred:
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"未决定购买"];
                [queue finishTransaction:transacion];
                break;
                
            default:
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"未知错误"];
                
                break;
        }
        
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AskTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.question = self.data[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = [self.askCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"%@",NSStringFromCGSize(size));
    return size.height;
}

//给cell预估行高
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 222;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuestionDetailController *quesVC = [[QuestionDetailController alloc] init];
    quesVC.question = self.data[indexPath.row];
    quesVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:quesVC animated:YES];
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    if (section == 0) {
//        AskHeaderView *askView = [[AskHeaderView alloc]init];
//        askView.priceLabel.text = self.userModel.price;
//        askView.editBlock = ^(NSDictionary *dic){
//            
//            NSLog(@"写好了");
//            
//            
//            [MBProgressHUD showMessage:@"请稍后"];
//            
//            //请求可售商品
//            NSSet *productSet = [NSSet setWithArray:@[@"Fenda.vDownload"]];
//            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
//            request.delegate = self;
//            [request start];
//            
//        };
//        askView.userModel = self.userModel;
//        return askView;
//    }
//    
//    return nil;
//}




@end
