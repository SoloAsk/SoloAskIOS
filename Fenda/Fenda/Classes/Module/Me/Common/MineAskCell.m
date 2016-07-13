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

//偷听
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
    
    if (self.isWhat == 1) {
        [self myAsk];
    }else{
        
        [self myAnswer];
    }
  
}



#pragma mark - 我问 中的cell
-(void)myAsk{
    
    NSNumberFormatter *fmatter = [[NSNumberFormatter alloc] init];
    
    //价格
    self.askPrice.text = [fmatter stringFromNumber:_quesModel.quesPrice];
    
    //内容
    self.quesContent.text = _quesModel.quesContent;
    
    //头像，用户名
    
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[_quesModel.answerUser objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"001"]];
    self.userName.text = [_quesModel.answerUser objectForKey:@"userName"];
    
    //问题状态
    if ([_quesModel.state intValue] == 0) {
        self.quesState.text = NSLocalizedString(@"status_unanswered", "");
    }else if ([_quesModel.state intValue] == 1){
        self.quesState.text = NSLocalizedString(@"status_answered", "");
    }else if ([_quesModel.state intValue] == 2){
        self.quesState.text = NSLocalizedString(@"status_refunded", "");
    }else if ([_quesModel.state intValue] == 3){
        self.quesState.text = NSLocalizedString(@"status_timeout", "");
    }
    
    //偷听人数
    self.listenAndIncome.text = [NSString stringWithFormat:@"%@%@",[fmatter stringFromNumber:_quesModel.listenerNum],NSLocalizedString(@"mineAskcell_heard", "")];
    
    //时间
    self.quesTime.text = [Tools compareCurrentTime:_quesModel.createdAt];
}




#pragma mark - 我答 中的cell
-(void)myAnswer{
    
    NSNumberFormatter *fmatter = [[NSNumberFormatter alloc] init];
    
    //价格
    self.askPrice.text = [fmatter stringFromNumber:_quesModel.quesPrice];
    
    //内容
    self.quesContent.text = _quesModel.quesContent;
    
    //头像
    
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[_quesModel.askUser objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"001"]];
    self.userName.text = [_quesModel.askUser objectForKey:@"userName"];
    
    
    
    //问题状态
    if ([_quesModel.state intValue] == 0) {
        self.quesState.text = NSLocalizedString(@"status_unanswered", "");
    }else if ([_quesModel.state intValue] == 1){
        self.quesState.text = NSLocalizedString(@"status_answered", "");
    }else if ([_quesModel.state intValue] == 2){
        self.quesState.text = NSLocalizedString(@"status_refunded", "");
    }else if ([_quesModel.state intValue] == 3){
        self.quesState.text = NSLocalizedString(@"status_timeout", "");
    }
    
    //偷听人数
    self.listenAndIncome.text = [NSString stringWithFormat:@"%@%@",[fmatter stringFromNumber:_quesModel.listenerNum],NSLocalizedString(@"mineAskcell_heard", "")];
    
    //时间
    self.quesTime.text = [Tools compareCurrentTime:_quesModel.createdAt];
}











@end
