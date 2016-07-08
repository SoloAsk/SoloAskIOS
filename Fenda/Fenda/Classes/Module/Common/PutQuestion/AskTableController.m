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





@interface AskTableController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver,UMSocialUIDelegate>

@property (nonatomic,strong) AskTableCell *askCell;

@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,strong) QuestionModel *questionModel;

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

#pragma mark - 界面将要展示时要做的事情
-(void)setupUI{
    
    AskHeaderView *askView = [[AskHeaderView alloc]init];
    
//    askView.frame=CGRectMake(0, 0, 100, 800);
    
    
    askView.priceLabel.text = self.userModel.price;
    askView.editBlock = ^(NSDictionary *dic){
        
        NSLog(@"写好了");
        
        
        [MBProgressHUD showMessage:@"请稍后"];
        
        //请求可售商品
        NSSet *productSet = [NSSet setWithArray:@[@"soloask.listen"]];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
        request.delegate = self;
        [request start];
        
    };
    askView.userModel = self.userModel;
    
    
    
    self.tableView.tableHeaderView = askView;
    
    
//    CGRect newFrame = askView.frame;
//    newFrame.size.height = [askView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    askView.frame = newFrame;
//    
//    [self.tableView setTableHeaderView:askView];
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
    
//    self.hud.label.text = [NSString stringWithFormat:@"请求到的票据个数：%ld",(unsigned long)transactions.count];
    
    for (SKPaymentTransaction *transacion in transactions) {
        switch (transacion.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                break;
                
            case SKPaymentTransactionStatePurchased:
                
            {
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

    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    

    
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
