//
//  MineListenHeadView.m
//  Fenda
//
//  Created by zhiwei on 16/6/30.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineListenHeadView.h"

@implementation MineListenHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MineListenHeadView" owner:nil options:nil].lastObject;
    }
    return self;
}

@end
