//
//  MineFooterView.m
//  Fenda
//
//  Created by zhiwei on 16/6/13.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineFooterView.h"

@implementation MineFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MineFooterView" owner:nil options:nil].lastObject;
    }
    return self;
}


//退出登录
- (IBAction)logout:(UIButton *)sender {
    
    if (self.logoutBlock) {
        self.logoutBlock();
    }
}





@end
