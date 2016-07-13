//
//  MineListenHeadView.m
//  Fenda
//
//  Created by zhiwei on 16/6/30.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineListenHeadView.h"

@interface MineListenHeadView()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation MineListenHeadView

-(void)setAskCount:(NSInteger)askCount{
    
    _askCount = askCount;
    
    self.countLabel.text = [NSString stringWithFormat:@"%@%ld",NSLocalizedString(@"format_heard", ""),(long)_askCount];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MineListenHeadView" owner:nil options:nil].lastObject;
    }
    return self;
}

@end
