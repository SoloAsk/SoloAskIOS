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
+(void)saveAskWithAskInfoDic:(NSDictionary *)infoDic answerObjID:(User *)answer resultBlock:(GetObjectBlock)result{
    
    [MBProgressHUD  showMessage:@"请稍后"];
    
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
    BmobObject *answerUser = [BmobObject objectWithoutDataWithClassName:@"User" objectId:answer.objectId];
    [post setObject:answerUser forKey:@"answerUser"];
    
    
    
    //异步保存
    [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        
        if (error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"保存信息失败"];
            NSLog(@"%@",[error description]);
        }
        
        
        if (isSuccessful) {
            
            
            
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"Question"];
            
            [bquery includeKey:@"askUser,answerUser"];
            [bquery getObjectInBackgroundWithId:post.objectId block:^(BmobObject *object, NSError *error) {
                
                if (error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:[error description]];
                    NSLog(@"%@",[error description]);
                }
                
                
                if (object) {
                    //                    //给被提问者发推送通知
                    BmobQuery *query = [BmobInstallation query];
                    [query whereKey:@"deviceToken" equalTo:[answer objectForKey:@"deviceToken"]];
                    
                    BmobPush *push = [BmobPush push];
                    [push setQuery:query];
                    
                    
                    NSString *askerName = [[object objectForKey:@"askUser"] objectForKey:@"userName"];
                    NSString *notiStr = [NSString stringWithFormat:@"%@给您提了一个问题",askerName];
                    NSDictionary *message = @{
                                              @"sound": @"cheering.caf",
                                              @"alert": notiStr,
                                              @"badge": @0,
                                              @"questionID":object.objectId
                                              };
                    
                    NSDictionary *dic = @{
                                          @"aps":message
                                          };
                    
                    //                    NSString *msg = [dic mj_JSONString];
                    
                    [push setData:dic];
                    [push sendPushInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                        
                        if (error) {
                            [MBProgressHUD hideHUD];
                            [MBProgressHUD showError:[error description]];
                            NSLog(@"%@",[error description]);
                        }
                        
                        
                        if (isSuccessful) {
                            [MBProgressHUD hideHUD];
                            [MBProgressHUD showSuccess:@"提问成功"];
                            result(object,error);
                        }
                        
                    }];
                    
                }
                
             
                
            }];
            
            
            
        }

       
        
    }];
    
}




#pragma mark - 获取我问页面信息
+(void)queryMyAskWithBlock:(QueryResultBlock)result{
    
    UserManager *user = [UserManager sharedUserManager];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Question"];
    
    BmobObject *bUser = [BmobObject objectWithoutDataWithClassName:@"User" objectId:user.userObjectID];
    [bquery whereKey:@"askUser" equalTo:bUser];
    [bquery includeKey:@"answerUser,askUser"];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
    
        result(array,error);
    }];
}


#pragma mark - 获取我答页面信息
+(void)queryMyAnswerWithBlock:(QueryResultBlock)result{
    
    UserManager *user = [UserManager sharedUserManager];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Question"];
    
    BmobObject *bUser = [BmobObject objectWithoutDataWithClassName:@"User" objectId:user.userObjectID];
    [bquery whereKey:@"answerUser" equalTo:bUser];
    [bquery includeKey:@"askUser,answerUser"];
    
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        result(array,error);
        
    }];
    
}

#pragma mark - 编辑页
+(void)queryEditWithBlock:(GetObjectBlock)result{
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery getObjectInBackgroundWithId:[UserManager sharedUserManager].userObjectID block:^(BmobObject *object, NSError *error) {
        
        result(object,error);
        
    }];
    
}

#pragma mark - 编辑页点保存更新用户信息
+(void)updateEditUserWithBUser:(User *)user UserInfo:(NSDictionary *)infoDic Block:(UpdateResultBlock)result{
    
    [user setObject:infoDic[@"userTitle"] forKey:@"userTitle"];
    [user setObject:infoDic[@"userIntroduce"] forKey:@"userIntroduce"];
    
    [user setObject:infoDic[@"askPrice"] forKey:@"askPrice"];
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        result(isSuccessful,error);
        
        
    }];
}


#pragma mark - 我的获取头部用户信息
+(void)queryMineHeadWithBlock:(GetObjectBlock)result{
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery getObjectInBackgroundWithId:[UserManager sharedUserManager].userObjectID block:^(BmobObject *object, NSError *error) {
        
        result(object,error);
        
    }];
}



@end
