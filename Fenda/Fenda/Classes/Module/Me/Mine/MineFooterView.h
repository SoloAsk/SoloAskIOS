//
//  MineFooterView.h
//  Fenda
//
//  Created by zhiwei on 16/6/13.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LogoutBlock)();

@interface MineFooterView : UIView

@property (nonatomic,copy)LogoutBlock logoutBlock;

@end
