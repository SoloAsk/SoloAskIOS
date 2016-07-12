//
//  UserManager.m
//  Fenda
//
//  Created by zhiwei on 16/6/17.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "UserManager.h"
#import "Tools.h"

@implementation UserManager
singleton_implementation(UserManager)

#pragma mark - =============抽取封装保存UserDefaults信息================
//TODO:保存id类型
-(void)saveUserDefaultsWithObject:(nullable id)value AndKey:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//TODO:保存Bool类型
-(void)saveUserDefaultsWithBool:(BOOL)value AndKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - =========================================================

#pragma mark - 保存用户属性
-(void)setAttributes:(NSDictionary *)dataDic{
    
    if (dataDic) {
        
        for (NSString *key in dataDic) {
            
            if ([Tools isNull:dataDic[key]]) {
                [self saveUserDefaultsWithObject:@"" AndKey:key];
            }else{
                
            [self saveUserDefaultsWithObject:dataDic[key] AndKey:key];
                
            }

        }
    }
    
}


-(NSString *)objectId{
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"objectId"]]) {
        return @"";
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"objectId"];
    
}

/**
 用户在微博的id号
 */
-(NSString *)userId{
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]) {
        return @"";
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}

/**
 用户昵称
 */
-(NSString *)userName{
    
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]]) {
        return @"无名";
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
}


/**
 用户头像的url
 */
-(NSString *)userIcon{
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"userIcon"]]) {
        return @"";
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userIcon"];
}

/**
 头衔
 */
-(NSString *)userTitle{
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"userTitle"]]) {
        return @"something";
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userTitle"];
}

/**
 简介
 */
-(NSString *)userIntroduce{
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"userIntroduce"]]) {
        return @"something";
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userIntroduce"];
}

/**
 提问价格
 */
-(NSNumber *)askPrice{
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"askPrice"]]) {
        return @0;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"askPrice"];
}


/**
 总收入
 */
-(NSNumber *)earning{
    
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"earning"]]) {
        return @0;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"earning"];
}

/**
 总收益
 */
-(NSNumber *)income{
    
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"income"]]) {
        return @0;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"income"];
}

/*
  回答问题个数
 */
-(NSNumber *)answerQuesNum{
    
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"answerQuesNum"]]) {
        return @0;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"answerQuesNum"];
}

/*
 问问题的个数
 */
-(NSNumber *)askQuesNum{
    
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"askQuesNum"]]) {
        return @0;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"askQuesNum"];
}

/*
 偷听过问题的个数
 */
-(NSNumber *)heardQuesNum{
    
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"heardQuesNum"]]) {
        return @0;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"heardQuesNum"];
}

/*
 PayPay账户
 */
-(NSString *)paypalAccount{
    
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"paypalAccount"]]) {
        return @"";
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"paypalAccount"];
}

/*
 登录的平台
 */

-(NSString *)loginPlatform{
    
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginPlatform"]]) {
        return @"未知平台";
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"loginPlatform"];
}


-(void)setIsLogin:(BOOL)isLogin{
    
//    if (isLogin == NO) {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"usid"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"iconURL"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
//    }
    
    [self saveUserDefaultsWithBool:isLogin AndKey:@"isLogin"];

}



/**
 用户登录状态
 */
-(BOOL)isLogin{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}



@end
