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
 将某个文件路径下的文件重命名，并返回重命名后的文件路径
*/
+(NSURL *)reNameWithSourceURL:(NSURL *)fileURL useName:(NSString *)fileName;

/*
 是否已经有这个文件名的语音文件
 */
+(BOOL)isHaveVoiceWithFileName:(NSString *)fileName;


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
