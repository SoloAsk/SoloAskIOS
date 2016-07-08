//
//  CLShareManager.h
//  LoginShare
//
//  Created by ClaudeLi on 16/5/3.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define shareNameArray @[@"Facebook",@"Twitter"]
#define shareImageArray @[@"share_facebook",@"share_twitter"]

typedef void(^BtnClickBlock)(NSInteger btnTag);


@interface CLShareManager : NSObject

@property (nonatomic,copy) BtnClickBlock btnBlock;

// 分享视图背景
@property (nonatomic, strong) UIView *shareBgView;
// 分享视图
@property (nonatomic, strong) UIView *shareView;

/**
 *  设置分享的AppKey，Appdelegate中执行一次即可。
 */
+ (void)setShareAppKey;

/**
 *  需要分享的内容
 *
 *  @param vc      分享所在视图控制器
 *  @param content 分享的内容
 *  @param image   分享的图片
 *  @param url     分享的urlString
 */
- (void)setShareVC:(UIViewController *)vc content:(NSString *)content image:(UIImage *)image url:(NSString *)url;

/**
 *  显示分享视图
 */
- (void)show;

/**
 *  隐藏分享视图
 */
- (void)hiddenShareView;

/**
 *  各个分享按钮点击事件
 *
 *  @param sender sender
 */
- (void)shareAction:(UIButton *)sender;

@end
