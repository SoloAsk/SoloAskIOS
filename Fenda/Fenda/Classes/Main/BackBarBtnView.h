//
//  BackBarBtnView.h
//  Fenda
//
//  Created by zhiwei on 16/6/29.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackBtnBlock)();

@interface BackBarBtnView : UIView

@property (nonatomic,copy) BackBtnBlock backBlock;

@end
