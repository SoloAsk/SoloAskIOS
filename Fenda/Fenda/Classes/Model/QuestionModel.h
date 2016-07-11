//
//  QuestionModel.h
//  Fenda
//
//  Created by zhiwei on 16/6/27.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

//问题id
@property (nonatomic,copy) NSString *questionId;

//提问者（关联用户表）
@property (nonatomic,strong) BmobObject *askUser;

//回答者	（关联用户表）
@property (nonatomic,strong) BmobObject *answerUser;

//偷听用户
@property (nonatomic,strong) BmobObject *hearedUser;

//提问的内容
@property (nonatomic,copy) NSString *quesContent;

//回答者语音地址
@property (nonatomic,copy) NSString *quesVoiceURL;

//语音长度（60s以内）
@property (nonatomic,strong) NSNumber *voiceTime;

//偷听人数
@property (nonatomic,copy) NSString *listenerNum;

//问题的价格（提问时的价格）
@property (nonatomic,strong) NSNumber *quesPrice;

//回答者距离现在的时间
@property (nonatomic,copy) NSString *answerTime;

//问题是否是免费的
@property (nonatomic,assign) BOOL isFree;

//问题是否是公开的
@property (nonatomic,assign) BOOL isPublic;

//问题的状态（待回答，已回答，已过期）
@property (nonatomic,copy) NSString *state;



@end
