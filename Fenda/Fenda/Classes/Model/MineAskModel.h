//
//  MineAskModel.h
//  Fenda
//
//  Created by zhiwei on 16/6/27.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineAskModel : NSObject

//回答者用户头像
@property (nonatomic, strong)  NSString *iconURL;

//回答者用户名
@property (nonatomic, copy)  NSString *userName;

//提问的价格
@property (nonatomic, strong)  NSNumber *askPrice;

//问题当前状态
@property (nonatomic, copy) NSString *quesState;

//问题内容
@property (nonatomic, copy) NSString *quesContent;

//问题时间
@property (nonatomic, copy) NSDate *quesTime;

//偷听
@property (nonatomic, strong) NSNumber *listen;

//分成收入
@property (nonatomic,strong) NSNumber *fenIncome;

@end
