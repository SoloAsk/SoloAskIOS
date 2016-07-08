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
