//
//  MineListenCell.m
//  Fenda
//
//  Created by zhiwei on 16/6/29.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineListenCell.h"


@interface MineListenCell()

//头像
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

//内容
@property (weak, nonatomic) IBOutlet UILabel *quesContent;

//用户名
@property (weak, nonatomic) IBOutlet UILabel *userName;

//头衔
@property (weak, nonatomic) IBOutlet UILabel *userHonor;

//据现在时间
@property (weak, nonatomic) IBOutlet UILabel *quesTime;

//偷听人数
@property (weak, nonatomic) IBOutlet UILabel *listenNum;

@end

@implementation MineListenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width/2;
    self.userIcon.clipsToBounds = YES;
}

-(void)setQuestion:(Question *)question{
    
    _question = question;
    
    
//    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:_question.answerUser.userIcon] placeholderImage:[UIImage imageNamed:@"001"]];
    
    
}

@end
