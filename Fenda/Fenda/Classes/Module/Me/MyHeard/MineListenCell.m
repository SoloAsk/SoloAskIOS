//
//  MineListenCell.m
//  Fenda
//
//  Created by zhiwei on 16/6/29.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineListenCell.h"

@interface MineListenCell()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@end

@implementation MineListenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width/2;
    self.userIcon.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
