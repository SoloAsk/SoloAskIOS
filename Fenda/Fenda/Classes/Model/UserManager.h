//
//  UserManager.h
//  Fenda
//
//  Created by zhiwei on 16/6/17.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface UserManager : NSObject
singleton_interface(UserManager)

//当前用户的bmob objectid
@property (nonatomic,copy) NSString *objectId;

/**
 用户昵称
 */
@property (nonatomic, copy) NSString *userName;

/**
 用户在微博的id号
 */
@property (nonatomic, copy) NSString *usid;

/**
 用户微博头像的url
 */
@property (nonatomic, copy) NSString *iconURL;

/**
 用户登录状态
 */
@property (nonatomic,assign) BOOL isLogin;

/**
 头衔
 */
@property (nonatomic, copy) NSString *honor;

/**
 简介
 */
@property (nonatomic, copy) NSString *introduce;

/**
 向我提问的价格
 */
@property (nonatomic, copy) NSString *price;

/**
 总收入
 */
@property (nonatomic, copy) NSString *earning;

/**
 总收益
 */
@property (nonatomic, copy) NSString *income;

/**
 登录的平台
 */
@property (nonatomic, copy) NSString *loginPlaform;

-(void)setAttributes:(NSDictionary *)dic;



@end
