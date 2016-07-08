//
//  CenterCell.m
//  Fenda
//
//  Created by zhiwei on 16/6/14.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "CenterCell.h"

@interface CenterCell()

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@end

@implementation CenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userIcon.layer.cornerRadius = 20;
    self.userIcon.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
