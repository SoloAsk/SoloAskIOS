
//
//  GetMoneyHeadView.m
//  Fenda
//
//  Created by zhiwei on 16/6/30.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "GetMoneyHeadView.h"

@interface GetMoneyHeadView()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIButton *getMoneyBtn;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UITextField *paypayFiled1;
@property (weak, nonatomic) IBOutlet UITextField *paypayField2;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation GetMoneyHeadView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width/2;
    self.userIcon.clipsToBounds = YES;
    
    self.getMoneyBtn.layer.cornerRadius = 5;
    self.getMoneyBtn.clipsToBounds = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"GetMoneyHeadView" owner:nil options:nil].lastObject;
    }
    return self;
}

-(void)setBUser:(User *)bUser{
    
    _bUser = bUser;
    
    if (_bUser) {
        
        [self.userIcon sd_setImageWithURL:[_bUser objectForKey:@"userIcon"] placeholderImage:[UIImage imageNamed:@"001"]];
        
        self.userName.text = [_bUser objectForKey:@"userName"];
        
        self.paypayFiled1.text = [_bUser objectForKey:@"paypalAccount"];
        self.paypayField2.text = [_bUser objectForKey:@"paypalAccount"];
    }
}

//提交按钮
- (IBAction)submitAction:(UIButton *)sender {
    
    if ([Tools isNull:self.paypayFiled1.text]) {
        [self showMessage:@"paypal账号不能为空"];
        return;
    }
    
    if ([Tools isNull:self.paypayField2.text]) {
        [self showMessage:@"请再次输入paypal账号"];
        return;
    }
    
    if (![self.paypayFiled1.text isEqualToString:self.paypayField2.text]) {
        
        [self showMessage:@"两次输入账号不一致"];
        return;
    }
    
    [SVProgressHUD show];
    
    
    
    
    BmobObject *withDraw = [BmobObject objectWithClassName:@"Withdraw"];
    [withDraw setObject:[NSNumber numberWithBool:NO] forKey:@"dealed"];
    [withDraw setObject:[Tools stringFromDate:[NSDate date]] forKey:@"applyTime"];
    [withDraw setObject:self.paypayField2.text forKey:@"paypalAccount"];
    User *user = [User objectWithoutDataWithClassName:@"User" objectId:[UserManager sharedUserManager].userObjectID];
    
    if (self.checkBtn.isSelected) {
        
        [user setObject:self.paypayField2.text forKey:@"paypalAccount"];
        [user updateInBackground];
    }
  
    [withDraw setObject:user forKey:@"user"];
    
    [withDraw saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (error) {
            [self showMessage:@"申请提现失败"];
        }
        
        if (isSuccessful) {
            [SVProgressHUD setMinimumDismissTimeInterval:1.0];
            [SVProgressHUD showSuccessWithStatus:@"申请提现成功"];
            
            if (self.finishBlock) {
                self.finishBlock();
            }
        }
        
        
    }];
    
   
}

-(void)showMessage:(NSString *)msg{
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD showErrorWithStatus:msg];
    
}


//记住按钮
- (IBAction)rememberAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}






@end
