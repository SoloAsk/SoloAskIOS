//
//  QesDetailHeadView.h
//  Fenda
//
//  Created by zhiwei on 16/6/28.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnBlock)(NSInteger btnTag);

@interface QesDetailHeadView : UIView

@property (nonatomic,copy) BtnBlock btnBlock;

@end
