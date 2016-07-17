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



//是否正在内购，防止按钮被多次点击
@property (nonatomic,assign) BOOL isBuying;


@property (nonatomic,strong) QesDetailHeadView *quesVC;

@property (strong, nonatomic) NSTimer *recordTimer;


//记录语音是否 已经 下载并且购买过(防止每次判断都要去联网)
@property (nonatomic,assign) BOOL isLocalBuy;

@property (nonatomic,strong) BBRecordTools *recordTools;

@end

@implementation QuestionDetailController

static NSString *reuseIdentifier2 = @"centerCell";
static NSString *reuseIdentifier3 = @"footerCell";

#pragma mark - 视图生命周期
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    
    //判断有没有当前问题的语音文件
    if ([Tools isHaveVoiceWithFileName:[NSString stringWithFormat:@"%@.aac",self.question.objectId]]) {
        self.quesVC.voiceTitle.text = NSLocalizedString(@"detail_click_to_play", "");
        self.isLocalBuy = YES;
    }
    
    
    self.userManager = [UserManager sharedUserManager];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    //删除下载的语音
    [self removeFileWithFileName:[NSString stringWithFormat:@"voices/%@.aac",self.question.objectId]];
    
    
    self.isLocalBuy = NO;
    [self.recordTools stopRecord];
    self.recordTools = nil;
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupUI];
 
}

-(void)setupUI{
    
    self.title = NSLocalizedString(@"问题详情", "");
    self.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.quesVC = [[QesDetailHeadView alloc] init];
    self.quesVC.question = self.question;
    self.quesVC.btnBlock = ^(NSInteger btnTag,QesDetailHeadView *detailView){
        
        
        
        if (weakSelf.userManager.isLogin) {
            
            if (weakSelf.isBuying) {
                return;
            }

            
            if (btnTag == 1) {//点击了提问者头像
                [weakSelf gotoAskTableControllerWithUser:[weakSelf.question objectForKey:@"askUser"]];
                return ;
            }
            
            
            if (btnTag == 2) {//点击了回答者头像
                [weakSelf gotoAskTableControllerWithUser:[weakSelf.question objectForKey:@"answerUser"]];
                return;
            }
            
            
            
            if (btnTag == 3) {//点击了语音，进行内购
                
                if (weakSelf.isBuying) {
                    return;
                }

                if (weakSelf.isLocalBuy) {//如果已经购买过此语音，直接播放
                    [weakSelf playingVoice];
                    return;
                }
                
                
                
            //判断是否是 提问者 和 回答者
                weakSelf.isBuying = YES;
                [weakSelf isAuthorAndAnswerWithBlock:^(BOOL isAuthor) {
                    
                    if (isAuthor) {
                        
                        NSLog(@"是回答者或者作者");
                        weakSelf.isBuying = NO;
                        [SVProgressHUD dismiss];
                        weakSelf.isLocalBuy = YES;
                        [weakSelf playingVoice];
                        
                        return ;
                    }else{
                        NSLog(@"不是回答者或者作者");
                        //获取后台是否已经关联了此用户（已经偷听了）
                        [weakSelf searchUserOfQuestionWithResultBlock:^(BOOL isHave) {
                            
                            if (isHave) {//----已经买过了
                                weakSelf.isBuying = NO;
                                weakSelf.isLocalBuy = YES;
                                //播放语音
                                [weakSelf playingVoice];
                                
                                
                            }else{//----未曾买过 to 内购
                                
                                [weakSelf appleBuy];
                            }
                            
                        }];
                        
                        return ;
                    }
                    
                    
                }];
            
                
            
               
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

-(void)itemShareAction{
    
    if (self.isBuying) {
        return;
    }
    
    [super itemShareAction];
    
}

#pragma mark - **************封装方法**************
//TODO:跳转到提问页
-(void)gotoAskTableControllerWithUser:(User *)user{
    
    AskTableController *apVC = [[AskTableController alloc] init];
    apVC.bUser = user;
    UserManager *manager = [UserManager sharedUserManager];
    if ([apVC.bUser.objectId isEqualToString:manager.userObjectID]) {
        [MBProgressHUD showError:@"不能提问自己"];
        return;
    }
    [self.navigationController pushViewController:apVC animated:YES];
}

//TODO:下载文件
- (void)downloadFile{
    
    [SVProgressHUD show];
    
    [NetWorkingTools downloadFileWithURL:[self.question objectForKey:@"quesVoiceURL"] destionation:^(NSURL *targetPath, NSURLResponse *response) {
        
//        [SVProgressHUD dismiss];
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showSuccessWithStatus:@"下载完毕"];
        
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.quesVC.voiceTitle.text = NSLocalizedString(@"detail_click_to_play", "");
//            [self playingVoice];
            
        });
        
        
        
       
    } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:[error description]];
            return ;
        }
        
        //将语音文件重命名为问题objectId
        [Tools reNameWithSourceURL:filePath useName:[NSString stringWithFormat:@"/voices/%@.aac",self.question.objectId]];
        
        
        
        //重命名后删除源文件
        if (filePath) {
            NSLog(@"fileURL ====== %@",filePath);
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager removeItemAtURL:filePath error:nil]) {
                NSLog(@"删除保存的录音文件成功---1");
            }else{
                
                NSLog(@"删除保存的录音文件失败---1");
            }
            
        }

    }];
 
}

//TODO:关联偷听用户
-(void)addListenerRelation{
    
    [SVProgressHUD show];
    
    BmobObject *question = [BmobObject objectWithoutDataWithClassName:@"Question" objectId:self.question.objectId];
    
    //新建relation对象
    BmobRelation *relation = [[BmobRelation alloc] init];
    [relation addObject:[BmobObject objectWithoutDataWithClassName:@"User" objectId:[UserManager sharedUserManager].userObjectID]];
    
    //添加关联关系到hearedUser列中
    [question addRelation:relation forKey:@"heardUser"];
    
    //异步更新obj的数据
    [question updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            [self addListenerNumber];
            
        }else{
            
            [SVProgressHUD showSuccessWithStatus:[error description]];
            [SVProgressHUD dismissWithDelay:1];
        }
    }];
}

//TODO:更新偷听者数量
-(void)addListenerNumber{
    
    //创建一条数据，并上传至服务器
        BmobObject *questionToBeChanged = [BmobObject objectWithoutDataWithClassName:@"Question" objectId:self.question.objectId];
            [questionToBeChanged incrementKey:@"listenerNum"];
            [questionToBeChanged updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    
                    [SVProgressHUD dismiss];
//                    [SVProgressHUD dismissWithDelay:1];
                    
                } else {
                    [SVProgressHUD showSuccessWithStatus:[error description]];
                    [SVProgressHUD dismissWithDelay:1];
                }
            }];
   
}

//TODO:查询Question偷听列里是否已经有此用户
-(void)searchUserOfQuestionWithResultBlock:(SearchResultBlock)resultBlock{
    
    //关联对象表
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    
    //需要查询的列
    BmobObject *question = [BmobObject objectWithoutDataWithClassName:@"Question" objectId:self.question.objectId];
    [bquery whereObjectKey:@"heardUser" relatedTo:question];
    
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            
            NSInteger sum = 0;
            for (BmobObject *user in array) {
                
                if ([user.objectId isEqualToString:[UserManager sharedUserManager].userObjectID]) {
                    
                    sum++;
                    
                }
            }
            
            if (sum > 0) {
                resultBlock(YES);
            }else{
                resultBlock(NO);
            }
        }
    }];
}

//
-(void)isAuthorAndAnswerWithBlock:(IsAskerOrAnswerBlock)result{
    
    [SVProgressHUD show];
    
    //查询问题表
    BmobQuery *query = [BmobQuery queryWithClassName:@"Question"];
    
    [query getObjectInBackgroundWithId:self.question.objectId block:^(BmobObject *object, NSError *error) {
        
        if (error) {
            NSLog(@"error = %@",error);
            
            [SVProgressHUD showErrorWithStatus:[error description]];
            [SVProgressHUD dismissWithDelay:1];
        }
        
        if (object) {
            
            BmobObject *asker = [object objectForKey:@"askUser"];
            NSString *askerID = asker.objectId;
            
            BmobObject *answer = [object objectForKey:@"answerUser"];
            NSString *answerID = answer.objectId;
            NSString *localUserID = [UserManager sharedUserManager].userObjectID;
            
            if ([askerID isEqualToString:localUserID] || [answerID isEqualToString:localUserID]) {
                
                result(YES);
            }else{
                result(NO);
            }
        }
    }];
  

}



-(void)appleBuy{

    
    
    if ([SKPaymentQueue canMakePayments]) {//判断设备是否可以内购
        
        [SVProgressHUD show];
        self.isBuying = YES;
        //请求可售商品
        NSSet *productSet = [NSSet setWithArray:@[@"cn.listen.price1"]];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
        request.delegate = self;
        [request start];
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"此设备不能内购或者已禁止"];
    }
    
    
    
}


#pragma mark - 内购代理
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    for (SKProduct *product in response.products) {
        
//        [SVProgressHUD dismiss];
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        
    }
    
//    [SVProgressHUD dismiss];
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
    
//    [SVProgressHUD dismiss];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    for (SKPaymentTransaction *transacion in transactions) {
        
        switch (transacion.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                break;
                
            case SKPaymentTransactionStatePurchased:
                
            {
                //关联偷听用户并增加偷听数量
                [self addListenerRelation];
                
                [queue finishTransaction:transacion];
                
            
                self.quesVC.voiceTitle.text = NSLocalizedString(@"detail_click_to_play", "");
                
                self.isBuying = NO;
                
            }
                
                
                break;
                
            case SKPaymentTransactionStateFailed:
            {
                [queue finishTransaction:transacion];
               
                [SVProgressHUD showErrorWithStatus:@"购买失败"];
                self.isBuying = NO;
                
            }
                break;
                
            case SKPaymentTransactionStateRestored:
            
                [SVProgressHUD showErrorWithStatus:@"恢复购买"];
                self.isBuying = NO;
                [queue finishTransaction:transacion];
                break;
                
            case SKPaymentTransactionStateDeferred:
        
                [SVProgressHUD showErrorWithStatus:@"未决定购买"];
                self.isBuying = NO;
                [queue finishTransaction:transacion];
                break;
                
            default:
               
                [SVProgressHUD showErrorWithStatus:@"未知错误"];
                self.isBuying = NO;
                break;
        }
        
        
    }
}


#pragma mark - 语音播放(更新)
-(BBRecordTools *)recordTools{
    
    if (_recordTools == nil) {
        
        NSString *documentDerectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *filePath = [documentDerectory stringByAppendingPathComponent:[NSString stringWithFormat:@"voices/%@.aac",self.question.objectId]];
        
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        _recordTools = [[BBRecordTools alloc] init];
        
        _recordTools.fileURL = fileURL;
    }
    
    return _recordTools;
    
}




-(void)playingVoice{
    
    //如果语音文件没有下载
    if (![Tools isHaveVoiceWithFileName:[NSString stringWithFormat:@"%@.aac",self.question.objectId]]) {
        
        [self downloadFile];//下载语音文件
        
        return;
    }
    
    
    
    if ([self.recordTools isPlaying]) {
        
        [self stopRecordTimer];
        [self.recordTools pausePlay];
        
    }else{
        
        [self.recordTools play];
        [PlayAnimation runAnimationWithCount:3 AndImageView:self.quesVC.animationImgView];
        [self startRecordTimer];
    }
  
    
}

- (void)startRecordTimer {
    [self.recordTimer invalidate];
    self.recordTimer = [NSTimer timerWithTimeInterval:0.3
                                               target:self
                                             selector:@selector(updateRecordCurrentTime)
                                             userInfo:nil
                                              repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
}


- (void)updateRecordCurrentTime {
    
    
//    if ([self.recordTools isPlaying]) {
//        [self startRecordTimer];
//        return;
//    }
    
    
    if (![self.recordTools isPlaying]) {//如果不播放了就停止动画
        [self stopRecordTimer];
        return;
    }
    
    [PlayAnimation runAnimationWithCount:3 AndImageView:self.quesVC.animationImgView];
    
}

- (void)stopRecordTimer {
    [self.recordTimer invalidate];
    self.recordTimer = nil;
}

//TODO:删除录音
-(void)removeFileWithFileName:(NSString *)fileName{
    
    NSString *savePath = [[NSString documentDirectory] stringByAppendingPathComponent:fileName];
    NSURL *fileURL = [NSURL fileURLWithPath:savePath];
    NSLog(@"fileURL = %@",fileURL);
    if (fileURL) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager removeItemAtURL:fileURL error:nil]) {
            NSLog(@"删除保存的录音文件成功---1");
        }else{
            
            NSLog(@"删除保存的录音文件失败---1");
        }
        
    }
    
    
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
    
    if (self.isBuying) {
        return;
    }
    
    if (self.userManager.isLogin) {
        
        [self gotoAskTableControllerWithUser:[self.question objectForKey:@"answerUser"]];
        
    }else{
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
  
}



@end
