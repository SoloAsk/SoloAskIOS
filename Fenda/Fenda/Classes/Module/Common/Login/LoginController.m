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




#pragma mark - FaceBook登录（shareSDK）
- (IBAction)facebookLoginClick:(UIButton *)sender {
    
    [ShareSDK getUserInfo:SSDKPlatformTypeFacebook
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             
             [self setupUserManagerWithUser:user];
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
    

}



//设置用户信息、跳转页面
-(void)setupUserManagerWithUser:(SSDKUser *)user{
    
    
    //查找User表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"userId" equalTo:user.uid];
    //查找User表里面usid数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            NSLog(@"error = %@",error);
            
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
        
        if (array.count == 0) {//TODO:云端无此用户
            
            
            //保存用户信息到云端
            User *bUser = [User objectWithClassName:@"User"];
            [bUser setObject:user.uid forKey:@"userId"];
            [bUser setObject:user.nickname forKey:@"userName"];
            [bUser setObject:user.icon forKey:@"userIcon"];
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
                    
                    
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    [UserManager sharedUserManager].isLogin = YES;
                    [UserManager sharedUserManager].userObjectID = bUser.objectId;
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
            
            User *bUser2 = array[0];
            
            NSLog(@"bUser = %@",bUser2);
            
            [UserManager sharedUserManager].userObjectID = bUser2.objectId;
            
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [UserManager sharedUserManager].isLogin = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
        
    }];
    
    
    
}






@end
