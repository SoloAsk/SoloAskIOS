//
//  CloudTools.m
//  Fenda
//
//  Created by zhiwei on 16/7/16.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "CloudTools.h"



@implementation CloudTools


+(void)queryHotWithBlock:(HotResultBlock)result{
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Question"];
    
    //一次性查询多个关联关系
    [bquery includeKey:@"askUser,answerUser"];
    [bquery whereKey:@"state" equalTo:@1];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        result(array,error);
        
    }];
}


@end
