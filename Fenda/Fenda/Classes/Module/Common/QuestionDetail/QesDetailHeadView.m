//
//  QesDetailHeadView.m
//  Fenda
//
//  Created by zhiwei on 16/6/28.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "QesDetailHeadView.h"


@interface QesDetailHeadView()

//提问者头像
@property (weak, nonatomic) IBOutlet UIButton *askerIcon;
@property (weak, nonatomic) IBOutlet UILabel *askerName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *askContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerIcon;

@property (weak, nonatomic) IBOutlet UILabel *minesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *listenerNumLabel;

@end

@implementation QesDetailHeadView

-(void)setQuestion:(Question *)question{
    
    _question = question;
    
    //内容
    self.askContentLabel.text = [_question objectForKey:@"quesContent"];
    
    //价格
    self.priceLabel.text = [NSString stringWithFormat:@"$%@",[_question objectForKey:@"quesPrice"]];
    
    //偷听人数
    NSNumberFormatter *fmatter= [[NSNumberFormatter alloc] init];
    NSString *listenNum = [fmatter stringFromNumber:[_question objectForKey:@"listenerNum"]];
    self.listenerNumLabel.text = [NSString stringWithFormat:@"%@%@",listenNum,NSLocalizedString(@"mineAskcell_heard", "")];
    
    //TODO:----------------------------回答者------------------------------
    BmobObject *answerUser =  [_question objectForKey:@"answerUser"];
    
    //头像
    [self.answerIcon sd_setImageWithURL:[NSURL URLWithString:[answerUser objectForKey:@"userIcon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"001"]];
    
    
    //TODO:----------------------------提问者------------------------------
    BmobObject *askUser =  [_question objectForKey:@"askUser"];
    //头像
    [self.askerIcon sd_setImageWithURL:[NSURL URLWithString:[askUser objectForKey:@"userIcon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"001"]];
    
    //用户名
    self.askerName.text = [askUser objectForKey:@"userName"];
    
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.askerIcon.layer.cornerRadius = self.askerIcon.bounds.size.width/2;
    self.askerIcon.clipsToBounds = YES;
    self.answerIcon.layer.cornerRadius = self.answerIcon.bounds.size.width/2;
    self.answerIcon.clipsToBounds = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"QesDetailHeadView" owner:nil options:nil].lastObject;
    }
    return self;
}


- (IBAction)listenBtn:(UIButton *)sender {
}


#pragma mark - 点击回答者
- (IBAction)answerBtn:(UIButton *)sender {
    
    if (self.btnBlock) {
        self.btnBlock(sender.tag,self);
    }
}


#pragma mark - 点击提问者
- (IBAction)askerBtn:(UIButton *)sender {
    
    if (self.btnBlock) {
        self.btnBlock(sender.tag,self);
    }
}

#pragma mark - 点击语音
- (IBAction)voiceBtn:(UIButton *)sender {
    
    if (self.btnBlock) {
        self.btnBlock(sender.tag,self);
    }
    
}

@end
