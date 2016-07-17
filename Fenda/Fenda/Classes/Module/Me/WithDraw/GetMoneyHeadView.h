//
//  GetMoneyHeadView.h
//  Fenda
//
//  Created by zhiwei on 16/6/30.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubmitFinishBlock)();

@interface GetMoneyHeadView : UIView

@property (nonatomic,copy) SubmitFinishBlock finishBlock;

@property (nonatomic,strong) User *bUser;

@end
