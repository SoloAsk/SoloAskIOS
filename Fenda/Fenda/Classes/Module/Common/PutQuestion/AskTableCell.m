//
//  AskTableCell.m
//  Fenda
//
//  Created by zhiwei on 16/6/15.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "AskTableCell.h"

@interface AskTableCell()

//提问者头像
@property (weak, nonatomic) IBOutlet UIImageView *askUserIcon;
//回答者头像
@property (weak, nonatomic) IBOutlet UIImageView *anserUserIcon;

@end

@implementation AskTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.askUserIcon.layer.cornerRadius = self.askUserIcon.bounds.size.width/2;
    self.askUserIcon.clipsToBounds = YES;
    self.anserUserIcon.layer.cornerRadius = self.anserUserIcon.bounds.size.width/2;
    self.anserUserIcon.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
