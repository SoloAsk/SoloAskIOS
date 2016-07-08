//
//  NoQandAController.m
//  Fenda
//
//  Created by zhiwei on 16/7/1.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "NoQandAController.h"
#import "TabbarController.h"

@interface NoQandAController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

//去看看
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@end

@implementation NoQandAController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}


-(void)setupUI{
    
    self.lookBtn.layer.cornerRadius = 5;
    self.lookBtn.clipsToBounds = YES;

    //设置提示信息
    if (self.cid <=3 && self.cid >=1) {
        NSArray *titles = @[@"notice_no_question",@"notice_no_answer",@"notice_no_listen"];
        //    [self.lookBtn setTitle:NSLocalizedString(titles[self.cid], "") forState:UIControlStateNormal];
        self.tipLabel.text = NSLocalizedString(titles[self.cid-1], "");
    }
    
}


#pragma mark - 去看看
- (IBAction)lookBtnClick:(UIButton *)sender {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    TabbarController *tabVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TabbarController"];
    tabVC.selectedIndex = 1;
    window.rootViewController = tabVC;
    
    
}



@end
