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
    
    [CloudTools queryAskWithUser:self.bUser resultBlock:^(NSArray *array, NSError *error) {
       
        
        if (error) {
            [MBProgressHUD showError:@"请检查网络"];
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        
        if (array.count == 0) {
            //            [MBProgressHUD showError:@"无结果"];
            [self.tableView.mj_header endRefreshing];
            
        }else if (array.count > 0){
            
            [self.data removeAllObjects];
            
            for (Question *question in array) {
                //只有已回答，完整的问题才显示
                if ([[question objectForKey:@"state"] intValue] == 1) {
                    [self.data addObject:question];
                }
                
                
                
            }
            
            // 刷新表格
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
        }

        
    }];
    
    
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
        
        NSNumber *indexNum = [self.bUser objectForKey:@"priceRank"];
        NSInteger index = [indexNum integerValue];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Products2" ofType:@"plist"];
        NSArray *products = [NSArray arrayWithContentsOfFile:path];
        
        
        if ([SKPaymentQueue canMakePayments]) {
            
            [SVProgressHUD show];
            //请求可售商品
            NSSet *productSet = [NSSet setWithArray:@[products[index]]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
            request.delegate = self;
            [request start];
        }
        
        
    };
    
    
    self.tableView.tableHeaderView = askView;
 
}

#pragma mark - 将问题保存到云端
-(void)saveQuestion{
    
    
    [CloudTools saveAskWithAskInfoDic:self.askDic answerObjID:self.bUser resultBlock:^(NSObject *object, NSError *error) {
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取问题信息失败"];
            [SVProgressHUD dismissWithDelay:1.0];
        }
        
       
        if (object) {
            
            QuestionDetailController *detailVC = [[QuestionDetailController alloc] init];
            detailVC.question = (Question *)object;
            [self.navigationController pushViewController:detailVC animated:YES];
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
    
    
//    [SVProgressHUD setMinimumDismissTimeInterval:1];
    for (SKPaymentTransaction *transacion in transactions) {
        switch (transacion.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                break;
                
            case SKPaymentTransactionStatePurchased:
                
            {
                //购买成功绑定信息
                [self saveQuestion];
                [queue finishTransaction:transacion];
            }
                
                
                break;
                
            case SKPaymentTransactionStateFailed:
            
                [queue finishTransaction:transacion];
                [SVProgressHUD showErrorWithStatus:@"购买失败"];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                
                [queue finishTransaction:transacion];
                [SVProgressHUD showErrorWithStatus:@"恢复购买"];
                break;
                
            case SKPaymentTransactionStateDeferred:
                
                [queue finishTransaction:transacion];
                [SVProgressHUD showErrorWithStatus:@"未决定购买"];
                break;
                
            default:
                [SVProgressHUD showErrorWithStatus:@"未知错误"];
                
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





@end
