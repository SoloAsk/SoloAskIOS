//
//  AppDelegate.m
//  Fenda
//
//  Created by zhiwei on 16/6/13.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"
#import "UMessage.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "UMSocialTwitterHandler.h"
#import "UMSocial.h"
#import <Bugly/Bugly.h>

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置bmob
    [Bmob registerWithAppKey:@"8307cbf7bc30650a6a30ffb25be78b81"];
//    [Bmob registerWithAppKey:@"26cc3d0d29e618b194be911c994efd11"];
    
    //设置友盟
    [self setUMSDKWith:launchOptions];
    
    //全局样式
    [self setAllStyle];
    
    
    //Twitter官方设置
//    [Fabric with:@[[Twitter class]]];
    
    //腾讯bugly
     [Bugly startWithAppId:@"900037657"];
    
    
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeFacebook]) {
        NSLog(@"9999999999999");
    }else{
        
        NSLog(@"88888888888888888");
    }
    
    //设置shareSDK
    [self setShareSDK];
    
    
    return YES;
}

#pragma mark - 设置shareSDK
-(void)setShareSDK{
    
    [ShareSDK registerApp:@"13f4b70e2e691"
          activePlatforms:@[
                            @(SSDKPlatformTypeFacebook)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeFacebook:
                      //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupFacebookByApiKey:@"1618281258486160"
                                               appSecret:@"3c0d5a4dfad7ba40b6b5a35f0895bf75"
                                                authType:SSDKAuthTypeBoth];
                      break;
                      
                  default:
                      break;
              }
          }];

}


#pragma mark - 设置友盟
-(void)setUMSDKWith:(NSDictionary *)launchOptions{
    
    //友盟推送
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:@"577b31ace0f55a8a310020f1" launchOptions:launchOptions];
    
    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
    [UMessage registerForRemoteNotifications];
    //for log
//    [UMessage setLogEnabled:YES];
    
    //友盟统计
    UMConfigInstance.appKey = @"577b31ace0f55a8a310020f1";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    
    [UMSocialData setAppKey:@"577b31ace0f55a8a310020f1"];
    
    
    
    //设置facebook应用ID及URL
//    [UMSocialFacebookHandler setFacebookAppID:@"1618281258486160" shareFacebookWithURL:@"http://www.umeng.com/social"];
//    [UMSocialFacebookHandler setFacebookAppID:@"193834921013209" shareFacebookWithURL:@"http://www.umeng.com/social"];
    
    //默认使用iOS自带的Twitter分享framework，在iOS 6以上有效。若要使用我们提供的twitter分享需要使用此开关：
    [UMSocialTwitterHandler openTwitter];
//     集成的TwitterSDK仅在iOS7.0以上有效，在iOS 6.x上自动调用系统内置Twitter授权
    if (UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [UMSocialTwitterHandler setTwitterAppKey:@"vC12ycM4LbdNooConUz0JFMWN" withSecret:@"Cb5cL5dZ0nXH41nvqDu0OwQDlKVx3dz2EfDCtym6GrKOiMtMVe"];
    }
}






//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    if (result == FALSE) {
//        //调用其他SDK，例如支付宝SDK等
//        
//        
//    }
//    return result;
//}


#pragma mark - 设置全局样式
-(void)setAllStyle{
    
    [UITabBar appearance].tintColor = NAV_BAR_COLOR;
    
    [UINavigationBar appearance].translucent = NO;
    [UITabBar appearance].translucent = NO;
    
    //导航返回按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //导航title文字颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    //隐藏返回按钮文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBarTintColor:NAV_BAR_COLOR];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //自定义返回按钮
//    UIImage *backButtonImage = [[UIImage imageNamed:@"ic_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 50, 5, 0)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    [[UITableView appearance] setSeparatorColor:TABLE_LINE_COLOR];
    
    
}








- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
