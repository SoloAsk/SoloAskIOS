//
//  UserModel.h
//  Fenda
//
//  Created by zhiwei on 16/6/22.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

/**
 用户昵称
 */
@property (nonatomic, copy) NSString *userName;

/**
 用户在微博的id号
 */
@property (nonatomic, copy) NSString *userId;

/**
 用户微博头像的url
 */
@property (nonatomic, copy) NSString *userIcon;

/**
 用户登录状态
 */
@property (nonatomic,assign) BOOL isLogin;

/**
 头衔
 */
@property (nonatomic, copy) NSString *userTitle;

/**
 简介
 */
@property (nonatomic, copy) NSString *userIntroduce;

/**
 向我提问的价格
 */
@property (nonatomic, strong) NSNumber *askPrice;

/**
 总收入
 */
@property (nonatomic, strong) NSNumber *earning;

/**
 总收益
 */
@property (nonatomic, copy) NSString *income;

/**
 回答问题个数
 */
@property (nonatomic,strong) NSNumber  *answerQuesNum;

/**
 登录的平台
 */
@property (nonatomic, copy) NSString *loginPlatform;

@end
