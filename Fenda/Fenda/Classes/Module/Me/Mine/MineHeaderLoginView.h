//
//  MineHeaderLoginView.h
//  Fenda
//
//  Created by zhiwei on 16/6/16.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoginBlock)();

@interface MineHeaderLoginView : UIView

@property (nonatomic,copy)LoginBlock loginBlock;

@end
