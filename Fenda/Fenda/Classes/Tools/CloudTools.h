//
//  CloudTools.h
//  Fenda
//
//  Created by zhiwei on 16/7/16.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HotResultBlock)(NSArray *array, NSError *error);

@interface CloudTools : NSObject



//获取首页信息
+(void)queryHotWithBlock:(HotResultBlock)result;




@end
