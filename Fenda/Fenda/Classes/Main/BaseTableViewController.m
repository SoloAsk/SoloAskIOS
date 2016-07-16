//
//  BaseTableViewController.m
//  Fenda
//
//  Created by zhiwei on 16/7/5.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CLShareManager+ShareView.h"
#import <TwitterKit/TWTRComposer.h>
#import <TwitterKit/TWTRSession.h>
#import <TwitterKit/TwitterKit.h>
#import <Social/Social.h>

@interface BaseTableViewController ()<UMSocialUIDelegate>

@property (nonatomic, strong) Reachability *conn;

@property (nonatomic,strong) CLShareManager *manager;

@end

@implementation BaseTableViewController


#pragma mark - 视图声明周期
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    BackBarBtnView *backview = [[BackBarBtnView alloc] init];
    backview.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    self.backview = backview;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backview];
    
    ShareBtnView *shareItem = [[ShareBtnView alloc] init];
    shareItem.sharekBlock = ^{
        [self itemShareAction];
    };
    self.shareItem = shareItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareItem];

}

- (void)dealloc
{
    
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark UITableView + 下拉刷新 默认
- (void)example01
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadData];
        
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)loadData{
    
}

-(NSMutableArray *)data{
    
    if (_data == nil) {
        
        _data = [NSMutableArray array];
        
    }
    
    return _data;
}


#pragma mark - 监听网络状态
- (void)networkStateChange
{
    [self checkNetworkState];
}

- (void)checkNetworkState
{
    
    NetworkStatus netState = [self.conn currentReachabilityStatus];
    
    if (netState == ReachableViaWiFi) {//使用Wifi上网
        
        self.canReachability = YES;
        
    }else if (netState == ReachableViaWWAN){//蜂窝网络
        
        self.canReachability = YES;
        
    }else if (netState == NotReachable){//无网络
        
        self.canReachability = NO;
        [MBProgressHUD showError:@"请检查您的手机网络"];
        
    }
    
}



#pragma mark - 分享按钮（ShareSDK弹出界面）
//-(void)itemShareAction{

//    //1、创建分享参数（必要）
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                     images:[UIImage imageNamed:@"传入的图片名"]
//                                        url:[NSURL URLWithString:@"http://mob.com"]
//                                      title:@"分享标题"
//                                       type:SSDKContentTypeAuto];
//    
//    // 定制新浪微博的分享内容
//    [shareParams SSDKSetupSinaWeiboShareParamsByText:@"定制新浪微博的分享内容" title:nil image:[UIImage imageNamed:@"传入的图片名"] url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
//    // 定制微信好友的分享内容
//    [shareParams SSDKSetupWeChatParamsByText:@"定制微信的分享内容" title:@"title" url:[NSURL URLWithString:@"http://mob.com"] thumbImage:nil image:[UIImage imageNamed:@"传入的图片名"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
    
    //2、分享
//    [ShareSDK showShareActionSheet:self.view items:<#(NSArray *)#> shareParams:<#(NSMutableDictionary *)#> onShareStateChanged:<#^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)shareStateChangedHandler#>]
//}


#pragma mark - 分享按钮（自定义弹出界面）

-(void)itemShareAction{
    
    NSLog(@"-----------LLL");
    
     self.manager = [[CLShareManager alloc] init];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.manager.btnBlock = ^(NSInteger btnTag){
      
        if (btnTag == 0) {
            
            
            //1、创建分享参数（必要）
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                             images:[UIImage imageNamed:@"传入的图片名"]
                                                url:[NSURL URLWithString:@"http://mob.com"]
                                              title:@"分享标题"
                                               type:SSDKContentTypeAuto];
            
          [ShareSDK showShareEditor:SSDKPlatformTypeFacebook otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
              
              if (state == SSDKResponseStateSuccess) {
                  NSLog(@"分享成功");
              }
              
          }];
            
            
            
            
            
            
            
        }else if (btnTag == 1){
            
            TWTRComposer *composer = [[TWTRComposer alloc] init];
            
            [composer setText:@"just setting up my Fabric"];
            [composer setImage:[UIImage imageNamed:@"fabric"]];
            
            // Called from a UIViewController
            [composer showFromViewController:weakSelf completion:^(TWTRComposerResult result) {
                if (result == TWTRComposerResultCancelled) {
                    NSLog(@"Tweet composition cancelled");
                }
                else {
                    NSLog(@"Sending Tweet!");
                }
            }];


        }
    };
    
    [self.manager show];
    
}


#pragma mark - 原生分享
-(void)nativeShare{
    
    //
    
    // 首先判断新浪分享是否可用
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        return;
    }
    // 创建控制器，并设置ServiceType
    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    // 添加要分享的图片
    [composeVC addImage:[UIImage imageNamed:@"about"]];
    // 添加要分享的文字
    [composeVC setInitialText:@"开启问答赚钱模式"];
    // 添加要分享的url
    [composeVC addURL:[NSURL URLWithString:@"http://www.soloask.com"]];
    // 弹出分享控制器
    [self presentViewController:composeVC animated:YES completion:nil];
    // 监听用户点击事件
    composeVC.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultDone) {
            NSLog(@"点击了发送");
        }
        else if (result == SLComposeViewControllerResultCancelled)
        {
            NSLog(@"点击了取消");
        }
    };
}






@end
