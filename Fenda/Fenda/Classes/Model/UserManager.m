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
            
                [self saveUserDefaultsWithObject:dataDic[key] AndKey:key];

        }
    }
    
}


/**
 用户昵称
 */
-(NSString *)userName{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
}


/**
 用户在微博的id号
 */
-(NSString *)usid{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"usid"];
}

/**
 用户微博头像的url
 */
-(NSString *)iconURL{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"iconURL"];
}

/**
 用户登录状态
 */
-(BOOL)isLogin{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}

/**
 头衔
 */
-(NSString *)honor{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"honor"];
}

/**
 简介
 */
-(NSString *)introduce{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"introduce"];
}

-(NSString *)price{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"price"];
}


-(NSString *)earning{
    
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"earning"]]) {
        return @"0";
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"earning"];
}

-(NSString *)income{
    
    if ([Tools isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"income"]]) {
        return @"0";
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"income"];
}

-(void)setIsLogin:(BOOL)isLogin{
    
    if (isLogin == NO) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"usid"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"iconURL"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    }
    
    [self saveUserDefaultsWithBool:isLogin AndKey:@"isLogin"];

}






@end
