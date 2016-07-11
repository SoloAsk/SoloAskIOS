//
//  LoginController.m
//  Fenda
//
//  Created by zhiwei on 16/6/16.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "LoginController.h"
#import "UserManager.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+NJ.h"

@interface LoginController ()
@property (weak, nonatomic) IBOutlet UIButton *fbLoginBgn;


@end

@implementation LoginController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([UserManager sharedUserManager].isLogin) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"登录", "");
    
    self.fbLoginBgn.layer.cornerRadius = 5;
    self.fbLoginBgn.clipsToBounds = YES;
    
    BackBarBtnView *backview = [[BackBarBtnView alloc] init];
    backview.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backview];
}


//同意协议按钮
- (IBAction)checkBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

//分答用户协议
- (IBAction)protocal:(UIButton *)sender {
}

#pragma mark - FaceBook登录
- (IBAction)facebookLoginClick:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToFacebook];
  
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        [SVProgressHUD show];
        
        if (response.responseCode == UMSResponseCodeSuccess) {
        
            [self setupUserManagerWithPlatform:snsPlatform];
            

        }else{
            
            [SVProgressHUD dismiss];
        }
    
    
    });
    
}


#pragma mark - QQ登录
- (IBAction)qqLoginClick:(UIButton *)sender {
 
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {

            [self setupUserManagerWithPlatform:snsPlatform];
            
        }});
}

//设置用户信息、跳转页面
-(void)setupUserManagerWithPlatform:(UMSocialSnsPlatform *)snsPlatform{
    
    
    
    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
    
    
    
    //查找User表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"userId" equalTo:snsAccount.usid];
    //查找User表里面usid数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            NSLog(@"error = %@",error);
            
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
        
        if (array.count == 0) {//TODO:云端无此用户
            
            
            //保存用户信息到云端
            BmobObject *bUser = [BmobObject objectWithClassName:@"User"];
            [bUser setObject:snsAccount.usid forKey:@"userId"];
            [bUser setObject:snsAccount.userName forKey:@"userName"];
            [bUser setObject:snsAccount.iconURL forKey:@"userIcon"];
            [bUser setObject:snsPlatform.platformName forKey:@"loginPlatform"];
            [bUser setObject:@"something" forKey:@"userTitle"];
            [bUser setObject:@"something" forKey:@"userIntroduce"];
            [bUser setObject:@1 forKey:@"askPrice"];
            [bUser setObject:@0 forKey:@"earning"];
            [bUser setObject:@0 forKey:@"income"];
            [bUser setObject:@0 forKey:@"answerQuesNum"];
            [bUser setObject:@0 forKey:@"askQuesNum"];
            [bUser setObject:@0 forKey:@"heardQuesNum"];
            
            
            
            [bUser saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
                if (isSuccessful) {
                    NSLog(@"od = %@",bUser.objectId);
                    
                    NSDictionary *dic = @{
                                          @"objectId":bUser.objectId,
                                          @"userId":snsAccount.usid,
                                          @"userName":snsAccount.userName,
                                          @"userIcon":snsAccount.iconURL,
                                          @"loginPlatform":snsPlatform.platformName,
                                          @"userTitle":@"something",
                                          @"userIntroduce":@"something",
                                          @"askPrice":@1,
                                          @"earning":@0,
                                          @"income":@0,
                                          @"answerQuesNum":@0,
                                          @"askQuesNum":@0,
                                          @"heardQuesNum":@0
                                          };
                    UserManager *user = [UserManager sharedUserManager];
                    [user setAttributes:dic];
                    
                    
                    
                    
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    [UserManager sharedUserManager].isLogin = YES;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
                if (error) {
                    
                    NSLog(@"error = %@",error);
                   [UserManager sharedUserManager].isLogin = NO;
                    
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showErrorWithStatus:@"登录失败"];
                }
            }];
            
        }else if (array.count == 1){//TODO:说明云端已经有此用户
            
            BmobObject *bUser2 = array[0];
            
            NSArray *keys = @[
                              @"objectId",
                              @"userId",
                              @"userName",
                              @"userIcon",
                              @"userTitle",
                              @"userIntroduce",
                              @"askPrice",
                              @"earning",
                              @"income",
                              @"answerQuesNum",
                              @"askQuesNum",
                              @"heardQuesNum",
                              @"paypalAccount",
                              @"loginPlatform"];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
            for (NSString *key in keys) {
                
                if ([Tools isNull:[bUser2 objectForKey:key]]) {
                    [dic setObject:@"" forKey:key];
                }else{
                    
                [dic setObject:[bUser2 objectForKey:key] forKey:key];
                    
                }
            }
//            NSLog(@"od = %@",[bUser2 objectForKey:@"objectId"]);
            [[UserManager sharedUserManager] setAttributes:dic];
            
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [UserManager sharedUserManager].isLogin = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
 
  
    }];
    

    
}





@end
