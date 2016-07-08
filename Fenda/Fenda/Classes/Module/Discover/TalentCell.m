//
//  TalentCell.m
//  Fenda
//
//  Created by zhiwei on 16/6/20.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "TalentCell.h"
#import "UIImageView+WebCache.h"


@interface TalentCell()

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
//头衔
@property (weak, nonatomic) IBOutlet UILabel *userHonor;
//简介
@property (weak, nonatomic) IBOutlet UILabel *userIntroduce;

@end

@implementation TalentCell

-(void)setUserMoel:(UserModel *)userMoel{
    
    _userMoel = userMoel;
    if (_userMoel) {
        
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:_userMoel.iconURL] placeholderImage:[UIImage imageNamed:@"001"]];
        self.userName.text = _userMoel.userName;
        self.userHonor.text = _userMoel.honor;
        self.userIntroduce.text = _userMoel.introduce;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userIcon.layer.cornerRadius = 25;
    self.userIcon.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
