//
//  QuestionDetailController.m
//  Fenda
//
//  Created by zhiwei on 16/6/14.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "QuestionDetailController.h"
#import "CenterCell.h"
#import "AskTableController.h"
#import "QesDetailHeadView.h"
#import "UserManager.h"
#import "LoginController.h"
#import <StoreKit/StoreKit.h>
#import "ShareBtnView.h"
#import "AVAudioRecordTool.h"
#import "AVAudioSession+Extension.h"
#import "PlayAnimation.h"
#import "MCSimpleAudioPlayer.h"
#import "NSString+Extension.h"
#import "QesDetailHeadView2.h"


@interface QuestionDetailController ()<UMSocialUIDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>

//{
//@private
//    MCSimpleAudioPlayer *_player;
////    NSTimer *_timer;
//}

@property (nonatomic,strong) CenterCell *centerCell;

@property (nonatomic,strong) UserManager *userManager;

//必须强引用才能播放
@property (nonatomic,strong) AVAudioRecordTool *audioTool;

//语音是否已经购买
@property (nonatomic,assign) BOOL isBuy;


@property (nonatomic,strong) QesDetailHeadView *quesVC;

@property (strong, nonatomic) NSTimer *recordTimer;

//播放语音
@property (nonatomic,strong) MCSimpleAudioPlayer *player;

@end

@implementation QuestionDetailController

static NSString *reuseIdentifier2 = @"centerCell";
static NSString *reuseIdentifier3 = @"footerCell";

#pragma mark - 视图生命周期
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.userManager = [UserManager sharedUserManager];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [self.player stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupUI];
 
}

-(void)setupUI{
    
    self.title = NSLocalizedString(@"问题详情", "");
    self.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    self.isBuy = NO;
    
    self.audioTool = [[AVAudioRecordTool alloc] init];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.quesVC = [[QesDetailHeadView alloc] init];
    self.quesVC.question = self.question;
    self.quesVC.btnBlock = ^(NSInteger btnTag,QesDetailHeadView *detailView){
        
        NSLog(@"-----%ld",(long)btnTag);
        
        
        if (weakSelf.userManager.isLogin) {
            
            
            if (btnTag == 1) {//点击了提问者头像
                
                [weakSelf gotoAskTableControllerWithUser:[weakSelf.question objectForKey:@"askUser"]];
                
                return ;
            }
            
            if (btnTag == 2) {//点击了回答者头像
                
                [weakSelf gotoAskTableControllerWithUser:[weakSelf.question objectForKey:@"answerUser"]];
                return;
            }
            
            
            
            if (btnTag == 3) {//点击了语音，进行内购
                weakSelf.isBuy = YES;
                if (weakSelf.isBuy) {
                    
                    
                    if ([Tools isHaveVoiceWithFileName:[NSString stringWithFormat:@"%@.aac",weakSelf.question.objectId]]) {
                        
                        NSLog(@"文件存在");
                        [weakSelf playingVoice];
                        
                    }else{
                        
                        NSLog(@"文件不存在");
                        //1.下载语音呢
                        [weakSelf downloadFile];
                    }
                    
                    
                    
                    
//
                    
                    return ;
                }
                
                //                [MBProgressHUD showMessage:@"请稍后"];
                //                //请求可售商品
                //                NSSet *productSet = [NSSet setWithArray:@[@"soloask.listen"]];
                //                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
                //                request.delegate = weakSelf;
                //                [request start];
                
                
                return ;
            }
            
            AskTableController *apVC = [[AskTableController alloc] init];
            [weakSelf.navigationController pushViewController:apVC animated:YES];
        }else{
            
            LoginController *loginVC = [[LoginController alloc] init];
            [weakSelf.navigationController pushViewController:loginVC animated:YES];
            
        }
        
        
    };
    
    QesDetailHeadView2 *headView2 = [[QesDetailHeadView2 alloc] init];
    headView2.question = self.question;
    
    if ([[self.question objectForKey:@"state"] intValue] == 0) {
        
        self.tableView.tableHeaderView = headView2;
        
    }else{
        
        self.tableView.tableHeaderView = self.quesVC;
    }
    
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier2];
    
    self.centerCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier2];

    
}

#pragma mark - 封装方法
-(void)gotoAskTableControllerWithUser:(User *)user{
    
    AskTableController *apVC = [[AskTableController alloc] init];
    apVC.bUser = user;
    UserManager *manager = [UserManager sharedUserManager];
    if ([apVC.bUser.objectId isEqualToString:manager.objectId]) {
        [MBProgressHUD showError:@"不能提问自己"];
        return;
    }
    [self.navigationController pushViewController:apVC animated:YES];
}

- (void)downloadFile{
    
    [SVProgressHUD show];
    
    [NetWorkingTools downloadFileWithURL:[self.question objectForKey:@"quesVoiceURL"] destionation:^(NSURL *targetPath, NSURLResponse *response) {
        
        
        
        
        [SVProgressHUD showSuccessWithStatus:@"下载完毕"];
        [SVProgressHUD dismissWithDelay:1];
        
    } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        
        [Tools reNameWithSourceURL:filePath useName:[NSString stringWithFormat:@"/voices/%@.aac",self.question.objectId]];

        
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
                
                self.isBuy = YES;
                
                self.quesVC.voiceTitle.text = NSLocalizedString(@"detail_click_to_play", "");
                
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

#pragma mark - 语音播放
-(MCSimpleAudioPlayer *)player{
    
    if (_player == nil) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"b3013af6ec.aac" ofType:nil];
        
        //播放以objectid命名的aac文件
        NSString *documentDerectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *filePath = [documentDerectory stringByAppendingPathComponent:[NSString stringWithFormat:@"voices/%@.aac",self.question.objectId]];
        NSLog(@"filePath = %@",filePath);
        _player = [[MCSimpleAudioPlayer alloc] initWithFilePath:filePath fileType:kAudioFileMP3Type];
    }
    
    return _player;
}

-(void)playingVoice{
    
    
    //第二种播放方式
    if (self.player.isPlayingOrWaiting)
    {
        [self.player pause];//如果正在播放就停止
        [self stopRecordTimer];
    }
    else
    {
        [self.player play];//如果停止播放，就播放
        [PlayAnimation runAnimationWithCount:3 AndImageView:self.quesVC.animationImgView];
        [self startRecordTimer];
    }
    
    
    
    
}

- (void)startRecordTimer {
    [self.recordTimer invalidate];
    self.recordTimer = [NSTimer timerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(updateRecordCurrentTime)
                                             userInfo:nil
                                              repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
}


- (void)updateRecordCurrentTime {
    
    if (!self.player.isPlayingOrWaiting) {//如果不播放了就停止动画
        [self stopRecordTimer];
        return;
    }
    
    [PlayAnimation runAnimationWithCount:3 AndImageView:self.quesVC.animationImgView];
    
}

- (void)stopRecordTimer {
    [self.recordTimer invalidate];
    self.recordTimer = nil;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    CenterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
    cell.bUser = [self.question objectForKey:@"answerUser"];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    CGSize size;
    
    size = [self.centerCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (self.userManager.isLogin) {
        
        [self gotoAskTableControllerWithUser:[self.question objectForKey:@"answerUser"]];
        
    }else{
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
  
}



@end
