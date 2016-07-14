//
//  Tools.m
//  Fenda
//
//  Created by zhiwei on 16/6/18.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "Tools.h"
#import "SVProgressHUD.h"

@interface Tools()



@end

@implementation Tools

+(void)showHudWithMessage:(NSString *)msg{
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showErrorWithStatus:msg];
}

+(NSURL *)reNameWithSourceURL:(NSURL *)fileURL useName:(NSString *)fileName{
    
    // 创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //创建文件目录
    NSString *documentDerectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    [fileMgr createDirectoryAtPath:[NSString stringWithFormat:@"%@/voices",documentDerectory] withIntermediateDirectories:YES attributes:nil error:nil];
    
    //指向文件目录
    NSString *filePath1 = [documentDerectory stringByAppendingPathComponent:fileName];
    
    NSURL *fileURL1 = [NSURL fileURLWithPath:filePath1];
    
    NSError *error1 = nil;
    if ([fileMgr moveItemAtURL:fileURL toURL:fileURL1 error:&error1] != YES) {
        
        //文件移动并重命名成功
    }
    
    return fileURL1;
}


+(BOOL)isHaveVoiceWithFileName:(NSString *)fileName{
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *documentDerectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *filePath = [documentDerectory stringByAppendingPathComponent:[NSString stringWithFormat:@"voices/%@",fileName]];
    
    if ([fileMgr fileExistsAtPath:filePath]) {
        
        return  YES;
        
    }else{
        
        return NO;
    }
    
}



+ (BOOL)isNull:(id)object
{
    if ([object isKindOfClass:[NSNumber class]]) {
        object = [NSString stringWithFormat:@"%@",object];
    }
    // 判断是否为空串
    if ([object isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (object==nil)
    {
        return YES;
    }else if ([object isEqualToString:@"<null>"]){
        return YES;
    }else if ([object isEqualToString:@"null"])
    {
        return YES;
    }
    else if ([object isEqualToString:@"(null)"])
    {
        return YES;
    }
    else if ([object isEqualToString:@""]){
        return YES;
    }
    return NO;
}


+ (NSString *) compareCurrentTime:(NSString *)strTime
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *timeDate = [dateFormatter dateFromString:strTime];
    NSLog(@"timeDate = %@",timeDate);
    
    //得到与当前时间差(全部使用标准时间计算)
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    //01.标准时间和北京时间差8个小时
//    timeInterval = timeInterval + 8*60*60;
    
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:NSLocalizedString(@"time_range_just", "")];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld %@",temp,NSLocalizedString(@"time_range_minute", "")];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld %@",temp,NSLocalizedString(@"time_range_hour", "")];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld %@",temp,NSLocalizedString(@"time_range_day", "")];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld %@",temp,NSLocalizedString(@"time_range_month", "")];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld %@",temp,NSLocalizedString(@"time_range_year", "")];
    }
    
    return  result;
}


+(NSString *)randomString{
    
    int NUMBER_OF_CHARS = 10;
    char data[NUMBER_OF_CHARS];
    for (int x=0;x<NUMBER_OF_CHARS;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *dataPoint = [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
    
    return dataPoint;
}

+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    return destDateString;
    
}


+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}





@end
