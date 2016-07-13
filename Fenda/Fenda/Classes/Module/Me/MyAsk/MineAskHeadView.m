//
//  MineAskHeadView.m
//  Fenda
//
//  Created by zhiwei on 16/7/5.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineAskHeadView.h"

@interface MineAskHeadView()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation MineAskHeadView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    
}


-(void)setAskCount:(NSInteger)askCount{
    
    _askCount = askCount;
    
    self.countLabel.text = [NSString stringWithFormat:@"%@%ld",NSLocalizedString(@"format_asked", ""),(long)_askCount];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MineAskHeadView" owner:nil options:nil].lastObject;
    }
    return self;
}

@end
