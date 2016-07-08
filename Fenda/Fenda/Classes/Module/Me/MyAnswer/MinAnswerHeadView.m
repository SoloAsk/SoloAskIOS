//
//  MinAnswerHeadView.m
//  Fenda
//
//  Created by zhiwei on 16/6/28.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MinAnswerHeadView.h"

@implementation MinAnswerHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MinAnswerHeadView" owner:nil options:nil].lastObject;
    }
    return self;
}








@end
