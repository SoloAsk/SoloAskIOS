//
//  QuestionDetailController.h
//  Fenda
//
//  Created by zhiwei on 16/6/14.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

//是否是偷听者
typedef void(^SearchResultBlock)(BOOL isHave);

//是回答者还是提问者
typedef void(^IsAskerOrAnswerBlock)(BOOL isAuthor);


@interface QuestionDetailController : BaseTableViewController

@property (nonatomic,strong) Question *question;



@end
