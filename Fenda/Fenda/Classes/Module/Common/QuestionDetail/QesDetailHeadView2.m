//
//  QesDetailHeadView2.m
//  Fenda
//
//  Created by zhiwei on 16/7/14.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "QesDetailHeadView2.h"

@interface QesDetailHeadView2()

//提问者头像
@property (weak, nonatomic) IBOutlet UIButton *askerIcon;
@property (weak, nonatomic) IBOutlet UILabel *askerName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *askContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;





@end

@implementation QesDetailHeadView2

-(void)setQuestion:(Question *)question{
    
    _question = question;
    
    
    //内容
    self.askContentLabel.text = [_question objectForKey:@"quesContent"];
    
    //--适配内容高度
    CGSize size = [self.askContentLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 165) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    if (size.height > 18) {
        CGRect frame = self.frame;
        frame.size.height = frame.size.height+(size.height-18);
        self.frame = frame;
    }
    
    
    //价格
    self.priceLabel.text = [NSString stringWithFormat:@"$%@",[_question objectForKey:@"quesPrice"]];
    
    
    BmobObject *askUser =  [_question objectForKey:@"askUser"];
    //头像
    [self.askerIcon sd_setImageWithURL:[NSURL URLWithString:[askUser objectForKey:@"userIcon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"001"]];
    
    //用户名
    self.askerName.text = [askUser objectForKey:@"userName"];
    
    //时间范围
    self.timeLabel.text = [Tools compareCurrentTime:[_question objectForKey:@"askTime"]];
    
}



-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.askerIcon.layer.cornerRadius = self.askerIcon.bounds.size.width/2;
    self.askerIcon.clipsToBounds = YES;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"QesDetailHeadView2" owner:nil options:nil].lastObject;
    }
    return self;
}




@end
