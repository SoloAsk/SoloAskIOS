//
//  User.h
//  Fenda
//
//  Created by zhiwei on 16/7/13.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

//#import <BmobSDK/BmobSDK.h>

@interface User : BmobObject


/**
 用户的id号
 */
@property (nonatomic, copy) NSString *userId;

/**
 用户昵称
 */
@property (nonatomic, copy) NSString *userName;


/**
 用户头像的url
 */
@property (nonatomic, copy) NSString *userIcon;

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
@property (nonatomic, strong) NSNumber *income;

/**
 回答问题个数
 */
@property (nonatomic,strong) NSNumber *answerQuesNum;

/*
 问问题的个数
 */
@property (nonatomic,strong) NSNumber *askQuesNum;

/*
 偷听过问题的个数
 */
@property (nonatomic,strong) NSNumber *heardQuesNum;

/*
 PayPay账户
 */
@property (nonatomic,copy) NSString *paypalAccount;


@end
