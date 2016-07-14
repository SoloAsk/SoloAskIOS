//
//  NetWorkingTools.h
//  Fenda
//
//  Created by zhiwei on 16/7/14.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Singleton.h"

typedef void(^DestinationBlock)(NSURL *targetPath, NSURLResponse *response);
typedef void(^CompletionBlock)(NSURLResponse *response, NSURL *filePath, NSError *error);

@interface NetWorkingTools : NSObject


+(void)downloadFileWithURL:(NSString *)urlStr destionation:(DestinationBlock)desBlock completion:(CompletionBlock)completBlock;

@end
