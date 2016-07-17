//
//  BBRecordTools.h
//  AACTEST
//
//  Created by zhiwei on 16/7/17.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface BBRecordTools : NSObject


//文件path
@property (nonatomic,strong) NSString *filePath;

//文件URL
@property (nonatomic,strong) NSURL *fileURL;

#pragma mark - 录音相关
//开始录音
- (void)startRecord;

//暂停录音
- (void)pauseRecord;

//停止录音
- (void)stopRecord;

#pragma mark - 播放相关
//播放录音
- (void)play;

//暂停播放
- (void)pausePlay;

//停止播放
- (void)stopPlay;

//播放某个url的录音文件
- (void)playWithURL:(NSURL *)url;

//是否在播放状态
- (BOOL)isPlaying;







@end
