//
//  EditView.m
//  Fenda
//
//  Created by zhiwei on 16/6/29.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "EditView.h"
#import "zySheetPickerView.h"
#import "IQTextView.h"
#import "MBProgressHUD+NJ.h"
#import "UIImageView+WebCache.h"

@interface EditView()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet IQTextView *honorLabel;
@property (weak, nonatomic) IBOutlet IQTextView *introduce;
@property (weak, nonatomic) IBOutlet UILabel *userName;

//需要国际化
@property (weak, nonatomic) IBOutlet UILabel *yTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yIntroduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *yPayLabel;

@end

@implementation EditView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.yTitleLabel.text = NSLocalizedString(@"user_title", "");
    self.yIntroduceLabel.text = NSLocalizedString(@"user_introduce", "");
    self.yPayLabel.text = NSLocalizedString(@"user_payment_for_asking", "");
    self.introduce.placeholder = NSLocalizedString(@"hint_user_introduce", "");
    self.honorLabel.placeholder = NSLocalizedString(@"hint_user_title", "");
    [self.saveBtn setTitle:NSLocalizedString(@"btn_save", "") forState:UIControlStateNormal];
    
    
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width/2;
    self.userIcon.clipsToBounds = YES;
    
    self.saveBtn.layer.cornerRadius = 5;
    self.saveBtn.clipsToBounds = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"EditView" owner:nil options:nil].lastObject;
    }
    return self;
}


- (IBAction)priceBtnClick:(UIButton *)sender {
    
    NSArray * str  = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:str andHeadTitle:@"Select Price" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        [self.priceBtn setTitle:choiceString forState:UIControlStateNormal];
        [pickerView dismissPicker];
    }];
    [pickerView show];
}

-(void)setUser:(UserManager *)user{
    
    _user = user;
    
    
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:_user.userIcon] placeholderImage:[UIImage imageNamed:@"001"]];
    self.userName.text = _user.userName;
    self.honorLabel.text = _user.userTitle;
    self.introduce.text = _user.userIntroduce;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [self.priceBtn setTitle:[formatter stringFromNumber:_user.askPrice] forState:UIControlStateNormal];
    
}


- (IBAction)saveBtnClick:(UIButton *)sender {
    
    if ([Tools isNull:self.honorLabel.text]) {
        [MBProgressHUD showError:NSLocalizedString(@"hud_prompt_honor", "")];
        return;
    }
    
    if ([Tools isNull:self.introduce.text]) {
        [MBProgressHUD showError:NSLocalizedString(@"hud_prompt_introduce", "")];
        return;
    }
    
    if ([Tools isNull:self.saveBtn.titleLabel.text]) {
        [MBProgressHUD showError:NSLocalizedString(@"hud_prompt_askPrice", "")];
        return;
    }
    
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"userId" equalTo:_user.userId];
    
    [MBProgressHUD showMessage:NSLocalizedString(@"hud_prompt_save", "")];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
            return ;
        }
        
        if (array.count == 1) {
            
            BmobObject *bUser = array[0];
            
            [bUser setObject:self.honorLabel.text forKey:@"userTitle"];
            [bUser setObject:self.introduce.text forKey:@"userIntroduce"];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [bUser setObject:[formatter numberFromString:self.priceBtn.titleLabel.text] forKey:@"askPrice"];
            
            [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
                if (error) {
                    [MBProgressHUD showSuccess:NSLocalizedString(@"hud_prompt_saveFailed", "")];
                    return ;
                }
                
                if (isSuccessful) {
                    
                    NSLog(@"---->>%@",self.priceBtn.titleLabel.text);
                    
                    UserManager *localUser = [UserManager sharedUserManager];
                    NSDictionary *dic = @{
                                @"userTitle":self.honorLabel.text,
                                @"userIntroduce":self.introduce.text,
                                @"askPrice":[formatter numberFromString:self.priceBtn.titleLabel.text]
                                          };
                    [localUser setAttributes:dic];
                    
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:NSLocalizedString(@"hud_prompt_saveSuccess", "")];
                    
                    
                    if (self.saveBlock) {
                        self.saveBlock();
                    }
                }
            }];
            
            
            
            
           
        }
        
        
    }];
    
    
    
  
    
}



@end
