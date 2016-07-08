//
//  ShareBtnView.h
//  Fenda
//
//  Created by zhiwei on 16/7/5.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShareBlock)();

@interface ShareBtnView : UIView

@property (nonatomic,copy) ShareBlock sharekBlock;

@end
