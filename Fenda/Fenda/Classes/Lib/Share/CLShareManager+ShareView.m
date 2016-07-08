//
//  CLShareManager+ShareView.m
//  CLShare
//
//  Created by ClaudeLi on 16/5/4.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLShareManager+ShareView.h"
#import "CLShareButton.h"

@implementation CLShareManager (ShareView)

- (void)creatShareView{
    self.shareBgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.shareBgView];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.shareBgView];
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 200)];
    topView.userInteractionEnabled = YES;
    [self.shareBgView addSubview:topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenShareView)];
    [topView addGestureRecognizer:tap];
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 200)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [self.shareBgView addSubview:self.shareView];
    
    UILabel * shareLeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, ScreenWidth, 15)];
    shareLeLabel.text = NSLocalizedString(@"share_topLabel", nil);
    shareLeLabel.textColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1.0];
    shareLeLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:shareLeLabel];
    
    //白线1
    UIView *LineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shareLeLabel.frame)+19, ScreenWidth, 1)];
    LineView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    [self.shareView addSubview:LineView];
    
    CGFloat itemWidth = 75.0f;
    UIScrollView * shareScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(LineView.frame)+10, ScreenWidth, 80)];
    shareScrollView.contentSize = CGSizeMake(itemWidth*shareNameArray.count, 0);
    shareScrollView.showsVerticalScrollIndicator = NO;
    shareScrollView.bounces = NO;
    shareScrollView.showsHorizontalScrollIndicator = NO;
    [self.shareView addSubview:shareScrollView];
    
    for (int i = 0; i < shareNameArray.count; i++) {
        
        //从中间到两边排序
        CLShareButton * shareBtn = [[CLShareButton alloc] initWithFrame:CGRectMake((ScreenWidth-shareImageArray.count*itemWidth-((shareImageArray.count-1)*45))/2+i*(itemWidth+45), 0, itemWidth, 80)];
        
//        shareBtn.backgroundColor = [UIColor greenColor];
        
        //从左到友排序
//        CLShareButton * shareBtn = [[CLShareButton alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, 80)];
        [shareBtn setImage:[UIImage imageNamed:shareImageArray[i]] forState:UIControlStateNormal];
        [shareBtn setTitle:shareNameArray[i] forState:UIControlStateNormal];
        shareBtn.tag = i;
        [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [shareScrollView addSubview:shareBtn];
    }
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(0, self.shareView.frame.size.height - 50, self.shareView.frame.size.width, 49);
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 6.0f;
//    cancelBtn.layer.borderColor = [[UIColor grayColor] CGColor];
//    cancelBtn.layer.borderWidth = 0.8f;
    cancelBtn.tintColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1.0];
    [cancelBtn setTitle:NSLocalizedString(@"share_cancel", nil) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hiddenShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:cancelBtn];
    self.shareBgView.hidden = YES;
    
    //白线2
    UIView *LineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(cancelBtn.frame)-1, ScreenWidth, 1)];
    LineView2.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    [self.shareView addSubview:LineView2];
}



@end
