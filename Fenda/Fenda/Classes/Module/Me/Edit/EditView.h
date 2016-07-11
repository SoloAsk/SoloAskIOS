//
//  EditView.h
//  Fenda
//
//  Created by zhiwei on 16/6/29.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

typedef void(^SaveBlock)();

@interface EditView : UIView

@property (nonatomic,copy) SaveBlock saveBlock;

@property (nonatomic,strong) UserManager *user;

@end
