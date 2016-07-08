//
//  CLShareManager.m
//  LoginShare
//
//  Created by ClaudeLi on 16/5/3.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLShareManager.h"
#import "CLShareManager+ShareView.h"

@interface CLShareManager (){
    UIViewController *_shareVC;
    NSString *_content;
    UIImage *_image;
    NSString *_url;
}
@end

@implementation CLShareManager

+ (void)setShareAppKey{
//    [UMSocialData setAppKey:K_UM_AppKey];
//    //微信
//    [UMSocialWechatHandler setWXAppId:K_WX_AppID appSecret:K_WX_AppSecret url:K_Share_Url];
//    //朋友圈
//    [UMSocialWechatHandler setWXAppId:K_WX_AppID appSecret:K_WX_AppSecret url:K_Share_Url];
//    // 新浪
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:K_Sina_AppKey secret:K_Sina_AppSecret RedirectURL:K_Share_Url];
//    // QQ
//    [UMSocialQQHandler setQQWithAppId:K_QQ_AppId appKey:K_QQ_AppKey url:K_Share_Url];
//    // QQ控件
//    [UMSocialQQHandler setQQWithAppId:K_QQ_AppId appKey:K_QQ_AppKey url:K_Share_Url];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatShareView];
    }
    return self;
}

- (void)setShareVC:(UIViewController *)vc content:(NSString *)content image:(UIImage *)image url:(NSString *)url{
    _shareVC = vc;
    _content = content;
    _image = image;
    _url = url;
}

- (void)show{
    self.shareBgView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.shareBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.shareView.frame = CGRectMake(0, ScreenHeight - 200, ScreenWidth, 200);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hiddenShareView{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.shareView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
    } completion:^(BOOL finished) {
        self.shareBgView.hidden = YES;
    }];
}

- (void)shareAction:(UIButton *)sender{
    [self hiddenShareView];
    
    if (self.btnBlock) {
        self.btnBlock(sender.tag);
    }
    
    
//TODO:原始分享代码
//    NSString * titleStr = _content;
//    NSString * urlStr = _url;
//    UIImage  * image = _image;
//    NSArray *shareType;
//    if (sender.tag == 0) {
//        // 微信
//        shareType = @[UMShareToWechatSession];
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = urlStr;
//        [UMSocialData defaultData].extConfig.wechatSessionData.title = titleStr;
//        
//    }else if (sender.tag == 1) {
//        // 朋友圈
//        shareType = @[UMShareToWechatTimeline];
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlStr;
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleStr;
//    }else if (sender.tag == 2) {
//        // 新浪
//        titleStr = [NSString stringWithFormat:@"%@   猛戳->>>%@(分享来自@你随意_37610)",titleStr,urlStr];
//        shareType = @[UMShareToSina];
//    }else{
//        if ([TencentOAuth iphoneQQInstalled]) {
//            if (sender.tag == 3) {
//                // QQ
//                shareType = @[UMShareToQQ];
//                [UMSocialData defaultData].extConfig.qqData.url = urlStr;
//                [UMSocialData defaultData].extConfig.qqData.title = titleStr;
//            }else if (sender.tag == 4) {
//                // QQ空间
//                shareType = @[UMShareToQzone];
//                [UMSocialData defaultData].extConfig.qzoneData.url = urlStr;
//                [UMSocialData defaultData].extConfig.qzoneData.title = titleStr;
//            }
//        } else {
//            NSLog(@"程序未安装,请到App Store下载");
//            return;
//        }
//    }
//    [self postShareWith:shareType content:titleStr image:image];
}

- (void)postShareWith:(NSArray *)type content:(NSString *)content image:(id)image{
    [[UMSocialDataService defaultDataService] postSNSWithTypes:type content:content image:image location:nil urlResource:nil presentedController:_shareVC completion:^(UMSocialResponseEntity *response){
        [self shareFinishWith:response];
    }];
}

// 分享完成
- (void)shareFinishWith:(UMSocialResponseEntity *)response{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功！");
    }else if (response.responseCode == UMSResponseCodeCancel) {
        NSLog(@"取消");
    }else {
        NSLog(@"失败");
    }
}


@end
