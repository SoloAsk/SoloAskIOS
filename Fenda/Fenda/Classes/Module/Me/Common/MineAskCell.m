//
//  MineAskCell.m
//  Fenda
//
//  Created by zhiwei on 16/6/27.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineAskCell.h"
#import "UIImageView+WebCache.h"
#import "Tools.h"

@interface MineAskCell()

//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

//用户名
@property (weak, nonatomic) IBOutlet UILabel *userName;

//提问的价格
@property (weak, nonatomic) IBOutlet UILabel *askPrice;

//问题当前状态
@property (weak, nonatomic) IBOutlet UILabel *quesState;

//问题内容
@property (weak, nonatomic) IBOutlet UILabel *quesContent;

//问题时间
@property (weak, nonatomic) IBOutlet UILabel *quesTime;

//偷听和收入
@property (weak, nonatomic) IBOutlet UILabel *listenAndIncome;

@end

@implementation MineAskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width/2;
    self.userIcon.clipsToBounds = YES;
}


-(void)setQuesModel:(QuestionModel *)quesModel{
    
    _quesModel = quesModel;
    
    //价格
    NSNumberFormatter *fmatter = [[NSNumberFormatter alloc] init];
    self.askPrice.text = [fmatter stringFromNumber:_quesModel.quesPrice];
    
    self.quesContent.text = _quesModel.quesContent;
    
    
}


@end
