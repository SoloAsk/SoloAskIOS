//
//  CloudTools.m
//  Fenda
//
//  Created by zhiwei on 16/7/16.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "CloudTools.h"



@implementation CloudTools


#pragma mark - 获取首页信息
+(void)queryHotWithBlock:(QueryResultBlock)result{
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Question"];
    
    //一次性查询多个关联关系
    [bquery includeKey:@"askUser,answerUser"];
    [bquery whereKey:@"state" equalTo:@1];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        result(array,error);
        
    }];
}

#pragma mark - 获取发现页信息
+(void)queryDiscoverWithBlock:(QueryResultBlock)result{
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    
    //查找User表里面usid数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        result(array,error);
        
    }];
    
}

#pragma mark - 获取提问页问题列表信息
+(void)queryAskWithUser:(User *)user resultBlock:(QueryResultBlock)result{
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Question"];
    
    [bquery whereKey:@"answerUser" equalTo:user];
    [bquery includeKey:@"answerUser,askUser"];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        result(array,error);
      
    }];
}


#pragma mark - 提问完成将信息保存后台
+(void)saveAskWithAskInfoDic:(NSDictionary *)infoDic answerObjID:(NSString *)aObjID resultBlock:(GetObjectBlock)result{
    
    BmobObject  *post = [BmobObject objectWithClassName:@"Question"];
    //设置问题内容、价格、是否公开
    [post setObject:infoDic[@"quesContent"] forKey:@"quesContent"];
    [post setObject:infoDic[@"quesPrice"] forKey:@"quesPrice"];
    [post setObject:[NSNumber numberWithBool:infoDic[@"isPublic"]] forKey:@"isPublic"];
    [post setObject:@0 forKey:@"state"];
    [post setObject:@0 forKey:@"listenerNum"];
    [post setObject:infoDic[@"askTime"] forKey:@"askTime"];
    
    //设置问题关联的提问者记录
    BmobObject *askerUser = [BmobObject objectWithoutDataWithClassName:@"User" objectId:infoDic[@"userObjectID"]];
    [post setObject:askerUser forKey:@"askUser"];
    
    //设置问题关联的回答者记录
    BmobObject *answerUser = [BmobObject objectWithoutDataWithClassName:@"User" objectId:aObjID];
    [post setObject:answerUser forKey:@"answerUser"];
    
    
    
    //异步保存
    [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        
        if (isSuccessful) {
            
            [MBProgressHUD showSuccess:@"提问成功"];
            
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"Question"];
            
            [bquery includeKey:@"askUser,answerUser"];
            [bquery getObjectInBackgroundWithId:post.objectId block:^(BmobObject *object, NSError *error) {
                
                result(object,error);
                
            }];
   
        }
        
        
        if (error) {
            [MBProgressHUD showError:@"提问失败"];
        }
        
        
    }];
    
}


@end
