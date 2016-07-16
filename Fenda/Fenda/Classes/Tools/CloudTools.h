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

//更新结果回调
typedef void(^UpdateResultBlock)(BOOL isSuccessful, NSError *error);

//保存结果回调
typedef void(^SaveResultBlock)(BOOL isSuccessful, NSError *error);
typedef void(^SuccessBlock)();
typedef void(^ErrorBlock)();
//获取保存的对象回调
typedef void(^GetObjectBlock)(NSObject *object, NSError *error);

@interface CloudTools : NSObject



//TODO:首页
+(void)queryHotWithBlock:(QueryResultBlock)result;

//TODO:发现页
+(void)queryDiscoverWithBlock:(QueryResultBlock)result;

//TODO:提问页
//获取提问页问题列表信息
+(void)queryAskWithUser:(User *)user resultBlock:(QueryResultBlock)result;

//提问完成将信息保存后台
+(void)saveAskWithAskInfoDic:(NSDictionary *)infoDic answerObjID:(NSString *)aObjID resultBlock:(GetObjectBlock)result;

//TODO:我问页
+(void)queryMyAskWithBlock:(QueryResultBlock)result;

//TODO:我答页
+(void)queryMyAnswerWithBlock:(QueryResultBlock)result;

//TODO:编辑页
//获取编辑页头部用户信息信息
+(void)queryEditWithBlock:(GetObjectBlock)result;

//编辑页点保存更新用户信息
+(void)updateEditUserWithBUser:(User *)user UserInfo:(NSDictionary *)infoDic Block:(UpdateResultBlock)result;


@end
