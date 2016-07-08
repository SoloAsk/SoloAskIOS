//
//  QuestionModel.h
//  Fenda
//
//  Created by zhiwei on 16/6/27.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

//存放提问者和回答者的用户信息
@property (nonatomic,strong) NSArray *users;

//提问者id
@property (nonatomic,copy) NSString *askerid;

//回答者id
@property (nonatomic,copy) NSString *answerid;

//问题内容
@property (nonatomic,copy) NSString *askContent;

//语音地址
@property (nonatomic,copy) NSString *answervoiceurl;

//提问时间
@property (nonatomic,copy) NSString *questionTime;

//偷听人数
@property (nonatomic,copy) NSString *listenerNum;

//是否公开  ＝1是不公开 ＝0是公开
@property (nonatomic,strong) NSNumber *isPrivate;

//分成收入
@property (nonatomic,strong) NSNumber *fenIncome;

//问题的状态
@property (nonatomic,strong) NSString *quesState;

//提问时候的价格
@property (nonatomic,strong) NSNumber *askPrice;

//回答者头像地址
@property (nonatomic,copy) NSString *answerIconURL;

//回答者用户名
@property (nonatomic,copy) NSString *answerUserName;

//是限时免费听还是一元偷偷听
@property (nonatomic,assign) Boolean *isFree;

//回答者头衔
@property (nonatomic,copy) NSString *answerHonor;


@end
