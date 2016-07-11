//
//  MineHeadView.m
//  Fenda
//
//  Created by zhiwei on 16/6/13.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineHeadView.h"
#import "UIImageView+WebCache.h"
#import "Tools.h"

@interface MineHeadView()

//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

//用户名
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

//头衔
@property (weak, nonatomic) IBOutlet UILabel *honorLabel;

//个人介绍
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

//提问需支付的价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

//收入
@property (weak, nonatomic) IBOutlet UILabel *earningLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyDesLabel;

@end

@implementation MineHeadView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width/2;
    self.userIcon.clipsToBounds = YES;
    self.moneyDesLabel.text = NSLocalizedString(@"user_payment_rules", "");
    
    
    
    CGSize textSize = [self.user.userIntroduce boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    if (textSize.height > 18) {
        
        CGRect frame = self.frame;
        frame.size.height = 300.5+30;
        self.frame = frame;
//        NSLog(@"frame:%@---文本：%@--textSize:%@",NSStringFromCGRect(self.frame),self.introduceLabel.text,NSStringFromCGSize(textSize));
    }
 
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MineHeadView" owner:nil options:nil].lastObject;
    }
    return self;
}

#pragma mark - 编辑按钮
- (IBAction)editBtnClick:(UIButton *)sender {
    
    if (self.editBlock) {
        self.editBlock();
    }
    
}



-(void)setUser:(UserManager *)user{
    
    _user = user;
    
    if (_user) {
        
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.user.userIcon] placeholderImage:[UIImage imageNamed:@"001"]];
        
        self.userNameLabel.text = _user.userName;
        
        self.honorLabel.text = _user.userhonor;
        
        self.introduceLabel.text = _user.userIntroduce;

        self.priceLabel.text = [NSString stringWithFormat:@"%@ $%@",NSLocalizedString(@"user_payment_for_asking", ""),_user.askPrice];

        self.earningLabel.text = [NSString stringWithFormat:@"%@ $%@",NSLocalizedString(@"user_earned", ""),_user.earning];
    }
}



@end
