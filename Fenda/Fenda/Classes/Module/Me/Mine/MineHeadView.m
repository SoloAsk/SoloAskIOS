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

@end

@implementation MineHeadView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width/2;
    self.userIcon.clipsToBounds = YES;
    
    
    
    CGSize textSize = [self.introduceLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
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
        
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.user.iconURL] placeholderImage:[UIImage imageNamed:@"001"]];
        
        self.userNameLabel.text = [Tools isNull:_user.userName] ? @"" : _user.userName;
        
        self.honorLabel.text = [Tools isNull:_user.honor] ? @"somthing" : _user.honor;
        
//        self.introduceLabel.text = [Tools isNull:_user.introduce] ? @"somthing" : _user.introduce;
        
//        self.introduceLabel.text = @"somthingsomthisomthingsomthingsomthingsomthingsomthingsomthingsomthingsomthingsomthingsomthingsomthingsomthingsomthingsomthingsomthingsomthingngsomthingsomthing";
        
        
//        self.priceLabel.text = [Tools isNull:_user.price] ? @"向我提问需要支付￥0" : [NSString stringWithFormat:@"向我提问需要支付￥%@",_user.price];
//        
//        self.earningLabel.text = [NSString stringWithFormat:@"总收入￥%@，总收益￥%@",_user.earning,_user.income];
    }
}



@end
