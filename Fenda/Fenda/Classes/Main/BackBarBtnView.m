//
//  BackBarBtnView.m
//  Fenda
//
//  Created by zhiwei on 16/6/29.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "BackBarBtnView.h"

@implementation BackBarBtnView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"BackBarBtnView" owner:nil options:nil].lastObject;
    }
    return self;
}

- (IBAction)backBtnClick:(UIButton *)sender {
    
    if (self.backBlock) {
        self.backBlock();
    }
}

@end
