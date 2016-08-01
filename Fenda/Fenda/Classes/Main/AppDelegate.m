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
#import "QuestionDetailController.h"
#import "AnswerVoiceController.h"
#import "BaseNavController.h"
#import "TabbarController.h"


#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"sfsfsdfsdfsf");
    
    //设置Bmob
    [self setupBmob];
    
    //设置友盟
//    [self setUMSDKWith:launchOptions];
    
    //全局样式
    [self setAllStyle];
    
    
    //Twitter官方设置
//    [Fabric with:@[[Twitter class]]];
    
    //腾讯bugly
     [Bugly startWithAppId:@"900037657"];
    
    
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeFacebook]) {
        NSLog(@"facebook已经授权(已登录状态)");
    }else{
        
        NSLog(@"facebook未授权(未登录状态)");
    }
    
    //设置shareSDK
    [self setShareSDK];
    
//    [self updateDeviceToken];
    
    
    return YES;
}

#pragma mark - 设置Bmob
-(void)setupBmob{
    
    //设置bmob
    [Bmob registerWithAppKey:@"8307cbf7bc30650a6a30ffb25be78b81"];
    //    [Bmob registerWithAppKey:@"26cc3d0d29e618b194be911c994efd11"];
    
    
    // Override point for customization after application launch.
    //注册推送，iOS 8的推送机制与iOS 7有所不同，这里需要分别设置
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc]init];
        //注意：此处的Bundle ID要与你申请证书时填写的一致。
        categorys.identifier=@"com.soloask.ios";
        
        UIUserNotificationSettings *userNotifiSetting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys,nil]];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:userNotifiSetting];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        //注册远程推送
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
 
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    
    //注册成功后上传Token至服务器
    BmobInstallation  *currentIntallation = [BmobInstallation installation];
    [currentIntallation setDeviceTokenFromData:deviceToken];
    [currentIntallation saveInBackground];
    ;
    self.deviceToken = currentIntallation.deviceToken;
    [self updateDeviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    
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

#pragma mark - 更新用户设备deviceToken
-(void)updateDeviceToken{
    
    //更新当前用户User表的deviceToken
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    
    [bquery getObjectInBackgroundWithId:[UserManager sharedUserManager].userObjectID block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                
            
                [object setObject:self.deviceToken forKey:@"deviceToken"];
               
                
                //异步更新数据
                [object updateInBackground];
            }
        }else{
            [MBProgressHUD showError:@""];
        }
    }];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSInteger bage = [UIApplication sharedApplication].applicationIconBadgeNumber;
    bage = bage + 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = bage;
    
    //获取当前tabar控制器并设置选中的item
    TabbarController *tabContrl = (TabbarController *)self.window.rootViewController;
    tabContrl.selectedIndex = 0;
    
    //发送跳转通知
    NSString *openType = userInfo[@"aps"][@"openType"];
    if ([openType isEqualToString:@"ask"]) {
        //有人提问我的时候跳到回答页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeAskOpen" object:userInfo];
        return;
    }
    
    
    if ([openType isEqualToString:@"answer"]) {
        //问题被回答的时候跳到对应问题详情页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeAnswerOpen" object:userInfo];
        return;
    }
    

    
    NSLog(@"%@",userInfo);
}


/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    [self updateDeviceToken];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [self updateDeviceToken];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
