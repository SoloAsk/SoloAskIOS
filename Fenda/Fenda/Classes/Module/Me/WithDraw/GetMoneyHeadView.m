
//
//  GetMoneyHeadView.m
//  Fenda
//
//  Created by zhiwei on 16/6/30.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "GetMoneyHeadView.h"

@interface GetMoneyHeadView()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIButton *getMoneyBtn;

@end

@implementation GetMoneyHeadView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width/2;
    self.userIcon.clipsToBounds = YES;
    
    self.getMoneyBtn.layer.cornerRadius = 5;
    self.getMoneyBtn.clipsToBounds = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"GetMoneyHeadView" owner:nil options:nil].lastObject;
    }
    return self;
}

@end
