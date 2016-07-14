//
//  AskTableCell.m
//  Fenda
//
//  Created by zhiwei on 16/6/15.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "AskTableCell.h"

@interface AskTableCell()


//--------------问题信息--------------
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *voiceTileLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceCount;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *listenNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *voiceBgImage;


//提问者头像
@property (weak, nonatomic) IBOutlet UIImageView *askUserIcon;

//回答者头像
@property (weak, nonatomic) IBOutlet UIImageView *anserUserIcon;





@end

@implementation AskTableCell


-(void)setQuestion:(Question *)question{
    
    _question = question;
    
    if (_question) {
        
        //提问者头像
        [self.askUserIcon sd_setImageWithURL:[NSURL URLWithString:[[_question objectForKey:@"askUser"] objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"001"]];
        
        //回答者头像
        [self.anserUserIcon sd_setImageWithURL:[NSURL URLWithString:[[_question objectForKey:@"answerUser"] objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"001"]];
        
        //内容
        self.contentLabel.text = [_question objectForKey:@"quesContent"];
        
        //价格
        self.priceLabel.text = [NSString stringWithFormat:@"$%@",[_question objectForKey:@"quesPrice"]];
        
        //语音
        if ([[_question objectForKey:@"isFree"] boolValue]) {
            
            self.voiceTileLabel.text = NSLocalizedString(@"listen_for_free", "");
            [self.voiceBgImage setImage:[UIImage imageNamed:@"fanta_bubble_background_free.9"]];
            
        }else{
            
            self.voiceTileLabel.text = NSLocalizedString(@"listen_for_buy", "");
            [self.voiceBgImage setImage:[UIImage imageNamed:@"anta_bubble_background.9"]];
        }
        
        
        //提问时间
        self.timeLabel.text = [Tools compareCurrentTime:[_question objectForKey:@"askTime"]];
        
        //语音长度
//        self.voiceCount.text = [_question objectForKey:@""];
        
        //偷听
//        self.listenNumLabel.text = [_question objectForKey:@""];
        
        
        
    }
}




- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.askUserIcon.layer.cornerRadius = self.askUserIcon.bounds.size.width/2;
    self.askUserIcon.clipsToBounds = YES;
    self.anserUserIcon.layer.cornerRadius = self.anserUserIcon.bounds.size.width/2;
    self.anserUserIcon.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
