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
