//
//  CenterCell.m
//  Fenda
//
//  Created by zhiwei on 16/6/14.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "CenterCell.h"

@interface CenterCell()

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userIntroduce;

@end

@implementation CenterCell

-(void)setBUser:(User *)bUser{
    
    _bUser = bUser;
    
    //头像
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[_bUser objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"001"]];
    
    //用户名
    self.userName.text = [_bUser objectForKey:@"userName"];
    
    //简介
    self.userIntroduce.text = [_bUser objectForKey:@"userIntroduce"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userIcon.layer.cornerRadius = 20;
    self.userIcon.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
