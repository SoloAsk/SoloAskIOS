//
//  CloudTools.h
//  Fenda
//
//  Created by zhiwei on 16/7/16.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

//查询结果回调
typedef void(^QueryResultBlock)(NSArray *array, NSError *error);
//保存结果回调
typedef void(^SaveResultBlock)(BOOL isSuccessful, NSError *error);
typedef void(^SuccessBlock)();
typedef void(^ErrorBlock)();
//获取保存的对象回调
typedef void(^GetObjectBlock)(NSObject *object, NSError *error);

@interface CloudTools : NSObject



//获取首页信息
+(void)queryHotWithBlock:(QueryResultBlock)result;

//获取发现页信息
+(void)queryDiscoverWithBlock:(QueryResultBlock)result;

//获取提问页问题列表信息
+(void)queryAskWithUser:(User *)user resultBlock:(QueryResultBlock)result;

//提问完成将信息保存后台
+(void)saveAskWithAskInfoDic:(NSDictionary *)infoDic answerObjID:(NSString *)aObjID resultBlock:(GetObjectBlock)result;

@end
