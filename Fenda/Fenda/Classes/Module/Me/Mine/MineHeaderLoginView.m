//
//  MineHeaderLoginView.m
//  Fenda
//
//  Created by zhiwei on 16/6/16.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineHeaderLoginView.h"

@interface MineHeaderLoginView()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation MineHeaderLoginView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.clipsToBounds = YES;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MineHeaderLoginView" owner:nil options:nil].lastObject;
    }
    return self;
    
    

}

- (IBAction)loginBtn:(UIButton *)sender {
    
    if (self.loginBlock) {
        self.loginBlock();
    }
}


@end
