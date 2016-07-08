//
//  MineAskHeadView.m
//  Fenda
//
//  Created by zhiwei on 16/7/5.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineAskHeadView.h"

@implementation MineAskHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MineAskHeadView" owner:nil options:nil].lastObject;
    }
    return self;
}

@end
