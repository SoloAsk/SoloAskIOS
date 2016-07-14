//
//  Tools.h
//  Fenda
//
//  Created by zhiwei on 16/6/18.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+(void)showHudWithMessage:(NSString *)msg;

/*
 判断对象是否为空
 */
+ (BOOL)isNull:(id)object;

/*
 时间格式实现几天前，几小时前，几分钟前
 */
+ (NSString *) compareCurrentTime:(NSString *)strTime;

/*
 产生随机十位字符串
 */
+(NSString *)randomString;

/*
 将NSDate转换成NSString
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/*
 将NSString转换成NSDate
 */
+ (NSDate *)dateFromString:(NSString *)dateString;


@end
