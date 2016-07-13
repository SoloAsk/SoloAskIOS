//
//  QesDetailHeadView.h
//  Fenda
//
//  Created by zhiwei on 16/6/28.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QesDetailHeadView;
typedef void(^BtnBlock)(NSInteger btnTag,QesDetailHeadView *detailView);

@interface QesDetailHeadView : UIView

@property (nonatomic,copy) BtnBlock btnBlock;



@property (weak, nonatomic) IBOutlet UIImageView *animationImgView;

@property (weak, nonatomic) IBOutlet UILabel *voiceTitle;


@property (nonatomic,strong) Question *question;


@end
