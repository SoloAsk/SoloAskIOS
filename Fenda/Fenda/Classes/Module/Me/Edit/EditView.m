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
    
    NSArray * str  = @[@"0.99",@"1.99",@"2.99",@"4.99"];
    
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:str andHeadTitle:@"Select Price" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        
        [self.priceBtn setTitle:[NSString stringWithFormat:@"$%@",choiceString] forState:UIControlStateNormal];
        [pickerView dismissPicker];
    }];
    [pickerView show];
}


-(void)setBUser:(User *)bUser{
    
    _bUser = bUser;
    
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[_bUser objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"001"]];
    self.userName.text = [_bUser objectForKey:@"userName"];
    self.honorLabel.text = [_bUser objectForKey:@"userTitle"];
    self.introduce.text = [_bUser objectForKey:@"userIntroduce"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [self.priceBtn setTitle:[NSString stringWithFormat:@"$%@",[formatter stringFromNumber:[_bUser objectForKey:@"askPrice"]]] forState:UIControlStateNormal];
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
    
    NSNumber *priceRank;
    NSString *btnText = self.priceBtn.titleLabel.text;
    
    if ([btnText isEqualToString:@"$0.99"]) {
        priceRank = @1;
    }else if([btnText isEqualToString:@"$1.99"]){
        priceRank = @2;
    }else if([btnText isEqualToString:@"$2.99"]){
        priceRank = @3;
    }else if([btnText isEqualToString:@"$4.99"]){
        priceRank = @4;
    }
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSDictionary *userInfoDic = @{
                @"userTitle":self.honorLabel.text,
                @"userIntroduce":self.introduce.text,
                @"askPrice":[formatter numberFromString:self.priceBtn.titleLabel.text],
                @"priceRank":priceRank
                };
    
    [CloudTools updateEditUserWithBUser:self.bUser UserInfo:userInfoDic Block:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            [MBProgressHUD showSuccess:NSLocalizedString(@"hud_prompt_saveSuccess", "")];
            if (self.saveBlock) {
                self.saveBlock();
            }
        }

        
    }];
    
    

    
}



@end
