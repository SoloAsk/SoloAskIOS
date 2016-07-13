//
//  MinAnswerHeadView.m
//  Fenda
//
//  Created by zhiwei on 16/6/28.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MinAnswerHeadView.h"



@interface MinAnswerHeadView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MinAnswerHeadView

-(void)setAskCount:(NSInteger)askCount{
    
    _askCount = askCount;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@%ld",NSLocalizedString(@"format_answered", ""),(long)_askCount];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MinAnswerHeadView" owner:nil options:nil].lastObject;
    }
    return self;
}








@end
