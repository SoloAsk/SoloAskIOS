//
//  HotCellModel.h
//  Fenda
//
//  Created by zhiwei on 16/6/13.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface HotCellModel : NSObject

//偷听人数
@property (nonatomic,copy) NSString *listener;

//是否是限时免费
@property (nonatomic,copy) NSString *isFree;

//回答者头像
@property (nonatomic,copy) NSString *iconURL;

//回答者介绍
@property (nonatomic,copy) NSString *askerDesc;

//回答者姓名
@property (nonatomic,copy) NSString *askerName;

//问题
@property (nonatomic,copy) NSString *question;




@end
