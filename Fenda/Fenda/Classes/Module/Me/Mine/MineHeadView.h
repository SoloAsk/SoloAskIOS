//
//  MineHeadView.h
//  Fenda
//
//  Created by zhiwei on 16/6/13.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

typedef void (^EditBlock)();

@interface MineHeadView : UIView

@property (nonatomic,strong) UserManager *user;

@property (nonatomic,copy) EditBlock editBlock;







@end
