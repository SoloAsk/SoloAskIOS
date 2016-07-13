//
//  HotCell.m
//  Fenda
//
//  Created by zhiwei on 16/6/13.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "HotCell.h"
#import "UIImageView+WebCache.h"

@interface HotCell()

//问题
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

//回答者信息
@property (weak, nonatomic) IBOutlet UILabel *askerLabel;

//回答者头像
@property (weak, nonatomic) IBOutlet UIImageView *icon;

//限时免费 or 1元偷听
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;


//语音icon背景
@property (weak, nonatomic) IBOutlet UIImageView *voiceBgImage;

//偷听人数
@property (weak, nonatomic) IBOutlet UILabel *listenerLabel;

//语音Label
@property (weak, nonatomic) IBOutlet UILabel *voiceTitle;

@end

@implementation HotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //圆形头像
    self.icon.layer.cornerRadius = self.icon.bounds.size.width/2;
    self.icon.clipsToBounds = YES;
    
   
}




-(void)setQuestion:(Question *)question{
    
    _question = question;
    
    //内容
    self.questionLabel.text = [_question objectForKey:@"quesContent"];
    
    //用户名和头衔
    BmobObject *answerUser =  [_question objectForKey:@"answerUser"];
    NSString *askerName = [answerUser objectForKey:@"userName"];
    NSString *askerTitle = [answerUser objectForKey:@"userTitle"];
    self.askerLabel.text = [NSString stringWithFormat:@"%@ | %@",askerName,askerTitle];
    
    //头像
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[answerUser objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"001"]];
    
    //偷听人数
    NSNumberFormatter *fmatter= [[NSNumberFormatter alloc] init];
    NSString *listenNum = [fmatter stringFromNumber:[_question objectForKey:@"listenerNum"]];
    self.listenerLabel.text = [NSString stringWithFormat:@"%@%@",listenNum,NSLocalizedString(@"mineAskcell_heard", "")];
    
    //语音
    
    if ([[_question objectForKey:@"isFree"] boolValue]) {
        
        self.freeLabel.text = NSLocalizedString(@"listen_for_free", "");
        self.voiceBgImage.image = [UIImage imageNamed:@"fanta_bubble_background_free.9"];
        
//        self.listenerLabel.hidden = NO;
        
    }else{
        
        self.freeLabel.text = NSLocalizedString(@"listen_for_buy", "");
        self.voiceBgImage.image = [UIImage imageNamed:@"fanta_bubble_background.9"];
//        self.listenerLabel.hidden = YES;
    }
    
    
}




-(void)setModel:(HotModel *)model{
    
    _model = model;
    
//    self.questionLabel.text = _model.question;
    self.askerLabel.text = [NSString stringWithFormat:@"%@|%@",_model.askerName,_model.askerDesc];
    
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:_model.iconURL] placeholderImage:[UIImage imageNamed:@"001"]];
    self.icon.image = [UIImage imageNamed:_model.iconURL];
    
    if ([_model.isFree boolValue]) {//限时免费听
        
        self.freeLabel.text = NSLocalizedString(@"listen_for_free", "");
        self.voiceBgImage.image = [UIImage imageNamed:@"fanta_bubble_background_free.9"];
        self.listenerLabel.hidden = YES;
        
    }else{//1元偷偷听
        
        self.freeLabel.text = NSLocalizedString(@"listen_for_buy", "");
        self.voiceBgImage.image = [UIImage imageNamed:@"fanta_bubble_background.9"];
        self.listenerLabel.hidden = NO;
        
        self.listenerLabel.text = [NSString stringWithFormat:@"%@ %@",_model.listener,NSLocalizedString(@"format_listerers","")];
    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
