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
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            [self setupUserManagerWithPlatform:snsPlatform];

        }});
    
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
    
    //保存用户信息
    UserManager *user = [UserManager sharedUserManager];
    NSDictionary *dic = @{
        @"usid":snsAccount.usid,
        @"userName":snsAccount.userName,
        @"iconURL":snsAccount.iconURL,

        };
    [user setAttributes:dic];
    [UserManager sharedUserManager].isLogin = YES;
    
    
    //查找User表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"usid" equalTo:snsAccount.usid];
    //查找User表里面usid数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
        
        if (array.count == 0) {
            
            //保存用户信息到云端
            BmobObject *bUser = [BmobObject objectWithoutDataWithClassName:@"User" objectId:[Tools randomString]];
            [bUser setObject:snsAccount.usid forKey:@"usid"];
            [bUser setObject:snsAccount.userName forKey:@"userName"];
            [bUser setObject:snsAccount.iconURL forKey:@"iconURL"];
            [bUser setObject:snsPlatform.platformName forKey:@"loginPlaform"];
            [bUser setObject:@"something" forKey:@"honor"];
            [bUser setObject:@"something" forKey:@"introduce"];
            [bUser setObject:@"1" forKey:@"price"];
            [bUser setObject:@"0" forKey:@"earning"];
            [bUser setObject:@"0" forKey:@"income"];
            
            UserManager *user = [UserManager sharedUserManager];
            
            NSLog(@"ID------->%@",bUser.objectId);
            NSDictionary *dic = @{
                                  @"honor":@"something",
                                  @"introduce":@"something",
                                  @"price":@"1",
                                  @"earning":@"0",
                                  @"income":@"0"
                                  };
            [user setAttributes:dic];
            
            [bUser saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
                if (isSuccessful) {
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
                if (error) {
                   
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showErrorWithStatus:@"登录失败"];
                }
            }];
            
        }else if (array.count == 1){//说明云端已经有此用户
            
            BmobObject *bUser = array[0];
            //保存用户其他信息
            UserManager *user = [UserManager sharedUserManager];
            NSDictionary *dic = @{
                @"honor":[bUser objectForKey:@"honor"],
                @"introduce":[bUser objectForKey:@"introduce"],
                @"price":[bUser objectForKey:@"price"],
                @"earning":[bUser objectForKey:@"earning"],
                @"income":[bUser objectForKey:@"income"]
                };
            [user setAttributes:dic];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
        
        
        
        
  
    }];
    

    
}





@end
