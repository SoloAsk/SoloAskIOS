//
//  AskHeaderView.m
//  Fenda
//
//  Created by zhiwei on 16/6/15.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "AskHeaderView.h"
#import "IQKeyboardManager.h"

#import "UIImageView+WebCache.h"
#import "UserManager.h"
#import "Tools.h"
#import "MBProgressHUD+NJ.h"
#import "SVProgressHUD.h"

@interface AskHeaderView()<UITextViewDelegate>

//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

//用户名
@property (weak, nonatomic) IBOutlet UILabel *userName;

//头衔
@property (weak, nonatomic) IBOutlet UILabel *honorLabel;

//写好了
@property (weak, nonatomic) IBOutlet UIButton *writeOverBtn;

//选择按钮
@property (weak, nonatomic) IBOutlet UIButton *checBtn;



//详细介绍
@property (weak, nonatomic) IBOutlet UILabel *DetailDescLabel;

//回答的问题数和收入状况
@property (weak, nonatomic) IBOutlet UILabel *stateDesc;

//是否公开
@property (weak, nonatomic) IBOutlet UIButton *isPrivateBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnLeading;

//提问价格
@property (weak, nonatomic) IBOutlet UILabel *askPrice;

//底部label
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
//提示（公开按钮旁）
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation AskHeaderView

-(void)setUserModel:(UserModel *)userModel{
    
    _userModel = userModel;
    
    if (_userModel) {
        
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:_userModel.userIcon] placeholderImage:[UIImage imageNamed:@"001"]];
        
        self.userName.text = _userModel.userName;
        self.honorLabel.text = _userModel.userTitle;
        self.DetailDescLabel.text = _userModel.userIntroduce;
        
        NSNumberFormatter *fmatter = [[NSNumberFormatter alloc] init];
        self.askPrice.text = [NSString stringWithFormat:@"$%@",[fmatter stringFromNumber:_userModel.askPrice]];
        
        
        self.footerLabel.text = [NSString stringWithFormat:@"%@%@%@%@",NSLocalizedString(@"footer_label_01",""),[fmatter stringFromNumber:_userModel.answerQuesNum],NSLocalizedString(@"footer_label_02",""),[fmatter stringFromNumber:_userModel.earning]];

    }
    
    
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    
    self.askContent.placeholder = NSLocalizedString(@"hint_ask_question", "");
    
    self.tipLabel.text = NSLocalizedString(@"check_ask_question", "");
    
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width/2;
    self.userIcon.clipsToBounds = YES;
    
    self.writeOverBtn.layer.cornerRadius = 5;
    self.writeOverBtn.clipsToBounds = YES;
    
    self.askContent.layer.cornerRadius = 5;
    
    if (IS_IPHONE5) {
        self.checkBtnLeading.constant = 10;
    }
    
    CGSize textSize = [self.DetailDescLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    if (textSize.height > 18) {
        
        CGRect frame = self.frame;
        frame.size.height = 527+30;
        self.frame = frame;
//        NSLog(@"frame:%@---文本：%@--textSize:%@",NSStringFromCGRect(self.frame),self.DetailDescLabel.text,NSStringFromCGSize(textSize));
    }
    
    
    
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"AskHeaderView" owner:nil options:nil].lastObject;
    }
    return self;
}

//选择是否公开提问
- (IBAction)checBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

#pragma mark - 写好了
- (IBAction)editOverClick:(UIButton *)sender {
    
    if ([Tools isNull:self.askContent.text]) {
        [MBProgressHUD showError:@"提问内容不能为空"];
        return;
    }
    
    
    if (self.editBlock) {
        
        NSDictionary *dic = @{
            @"isPrivate":[NSNumber numberWithBool:self.isPrivateBtn.selected],
            @"askContent":self.askContent.text
            };
        
        self.editBlock(dic);
    }
    
}

//这里只能使用xib的firstResponder连接，所以圆是空心
-(IBAction)viewClick:(id)sender{
    
    [self endEditing:YES];
}



#pragma mark - UITextView代理
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;{
//    
//    NSLog(@"textViewShouldBeginEditing");
//    
//    return YES;
//}
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView;{
//    NSLog(@"textViewShouldEndEditing");
//    
//    return YES;
//}
//
//- (void)textViewDidBeginEditing:(UITextView *)textView;{
//    NSLog(@"textViewDidBeginEditing");
//  
//}
//- (void)textViewDidEndEditing:(UITextView *)textView;{
//    NSLog(@"textViewDidEndEditing");
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;{
//    NSLog(@"shouldChangeTextInRange");
//    
//    return YES;
//}
//- (void)textViewDidChange:(UITextView *)textView;{
//    NSLog(@"textViewDidChange");
//}
//
//- (void)textViewDidChangeSelection:(UITextView *)textView;{
//    NSLog(@"textViewDidChangeSelection");
//}
//
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0);{
//    NSLog(@"shouldInteractWithURL");
//    
//    return YES;
//}
//- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
//    NSLog(@"shouldInteractWithTextAttachment");
//    
//    return YES;
//}



@end
