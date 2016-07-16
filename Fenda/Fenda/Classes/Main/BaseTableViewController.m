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


#pragma mark - 网络状态改变时调用
- (void)networkStateChange
{
    [self checkNetworkState];
}

#pragma mark - 监听网络状态
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


#pragma mark - 分享按钮
-(void)itemShareAction{
    
    NSLog(@"-----------LLL");
    
     self.manager = [[CLShareManager alloc] init];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.manager.btnBlock = ^(NSInteger btnTag){
      
        if (btnTag == 0) {
            
//            FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//            content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
            
            
//            // 首先判断新浪分享是否可用
//            if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//                return;
//            }
//            // 创建控制器，并设置ServiceType
//            SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//            // 添加要分享的图片
//            [composeVC addImage:[UIImage imageNamed:@"about"]];
//            // 添加要分享的文字
//            [composeVC setInitialText:@"开启问答赚钱模式"];
//            // 添加要分享的url
//            [composeVC addURL:[NSURL URLWithString:@"http://www.soloask.com"]];
//            // 弹出分享控制器
//            [weakSelf presentViewController:composeVC animated:YES completion:nil];
//            // 监听用户点击事件
//            composeVC.completionHandler = ^(SLComposeViewControllerResult result){
//                if (result == SLComposeViewControllerResultDone) {
//                    NSLog(@"点击了发送");
//                }
//                else if (result == SLComposeViewControllerResultCancelled)
//                {
//                    NSLog(@"点击了取消");
//                }
//            };
           
            
            
            
        }else if (btnTag == 1){
            
//            TWTRComposer *composer = [[TWTRComposer alloc] init];
//            
//            [composer setText:@"just setting up my Fabric"];
//            [composer setImage:[UIImage imageNamed:@"fabric"]];
//            
//            // Called from a UIViewController
//            [composer showFromViewController:weakSelf completion:^(TWTRComposerResult result) {
//                if (result == TWTRComposerResultCancelled) {
//                    NSLog(@"Tweet composition cancelled");
//                }
//                else {
//                    NSLog(@"Sending Tweet!");
//                }
//            }];


        }
    };
    
    [self.manager show];
    
    
    
    
    
    
    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"5762c16e67e58e642e001208"
//                                      shareText:@"Hello Solo Ask，www.soloask.com"
//                                     shareImage:[UIImage imageNamed:@"icon.png"]
//                                shareToSnsNames:@[UMShareToFacebook,UMShareToTwitter]
//                                       delegate:self];
    
}



@end
