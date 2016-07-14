//
//  AskHeaderView.h
//  Fenda
//
//  Created by zhiwei on 16/6/15.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "IQTextView.h"

typedef void (^EditBtnBlock)(NSDictionary *dic);

@interface AskHeaderView : UIControl


@property (nonatomic,strong) User *bUser;

@property (nonatomic,copy) EditBtnBlock editBlock;


//提问价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

//问题内容
@property (weak, nonatomic) IBOutlet IQTextView *askContent;

@end
