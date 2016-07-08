//
//  ShareBtnView.m
//  Fenda
//
//  Created by zhiwei on 16/7/5.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "ShareBtnView.h"

@implementation ShareBtnView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ShareBtnView" owner:nil options:nil].lastObject;
    }
    return self;
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    
    if (self.sharekBlock) {
        self.sharekBlock();
    }
}

@end
