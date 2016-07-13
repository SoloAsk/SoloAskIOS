//
//  MineAskCell.h
//  Fenda
//
//  Created by zhiwei on 16/6/27.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "Question.h"

@interface MineAskCell : UITableViewCell

@property (nonatomic,strong) QuestionModel *quesModel;

@property (nonatomic,strong) Question *qModel;

//是我问（1）还是我答（2）
@property (nonatomic,assign) NSInteger isWhat;

@end
