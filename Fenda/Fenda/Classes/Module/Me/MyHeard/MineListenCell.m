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
    
    
    //回答者头像
    User *answerUser = [_question objectForKey:@"answerUser"];
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[answerUser objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"001"]];
    
    //回答者用户名
    self.userName.text = [answerUser objectForKey:@"userName"];
    
    //回答者头衔
    self.userHonor.text = [answerUser objectForKey:@"userTitle"];
    
    //内容
    self.quesContent.text = [_question objectForKey:@"quesContent"];
    
    //时间范围
    self.quesTime.text = [Tools compareCurrentTime:[_question objectForKey:@"askTime"]];
    
    //偷听人数
    NSNumberFormatter *fmatter = [[NSNumberFormatter alloc] init];
    self.listenNum.text = [NSString stringWithFormat:@"%@ %@",[fmatter stringFromNumber:[_question objectForKey:@"listenerNum"]],NSLocalizedString(@"mineAskcell_heard", "")];
    
    
}

@end
