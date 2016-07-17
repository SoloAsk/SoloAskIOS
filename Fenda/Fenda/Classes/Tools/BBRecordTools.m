//
//  BBRecordTools.m
//  AACTEST
//
//  Created by zhiwei on 16/7/17.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "BBRecordTools.h"
#import <AVFoundation/AVFoundation.h>

@interface BBRecordTools()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>



@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic) AVAudioPlayer *player;

@end

@implementation BBRecordTools

-(void)startRecord{
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [filePath stringByAppendingPathComponent:@"luyin.aac"];
    self.filePath = filePath;
    self.fileURL = [NSURL fileURLWithPath:filePath];
    
    NSLog(@"文件路径：%@", self.filePath);
    
    // 设置会话，以便可以直接进行录制和播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    // 录音机的参数设置
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // 录音格式，这里是aac
    [dict setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
    // 采样率，这个值会影响音频质量，Android与iOS都是16000，在可接受范围内
    [dict setValue:[NSNumber numberWithFloat:16000] forKey: AVSampleRateKey];
    // 通道数
    [dict setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    // 线性采样率
    [dict setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    // 录音质量
    [dict setValue:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
    
    NSError *error = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.fileURL settings: dict error: &error];
    self.recorder.delegate = self;
    if (error)
    {
        NSLog(@"录音机创建失败：%@", error.localizedDescription);
        return;
    }
    
    [self.recorder record];
}


-(void)stopRecord{
    
    if (self.recorder)
    {
        [self.recorder stop];
        self.recorder = nil;
    }
    
    if (self.player)
    {
        [self.player stop];
        self.player = nil;
    }
    
}

- (void)pauseRecord {
    [self.recorder pause];
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    // 录音完成之后的delagte
    NSLog(@"录音完成: %@", self.filePath);
    NSFileManager *mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:self.filePath])
    {
        unsigned long long size = [[mgr attributesOfItemAtPath:self.filePath error:nil] fileSize];
        NSLog(@"文件大小：%lld", size);
    }
    
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //播放完成
    
}


#pragma mark - play
-(void)play{
    
    if (self.player) {
        [self.player play];
    }else{
    
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.fileURL error:&error];
    self.player.numberOfLoops = 0;
    [self.player prepareToPlay];
    if (error)
    {
        NSLog(@"播放机错误：%@", error.localizedDescription);
        return;
    }
    
    [self.player play];
        
    }
}


-(void)playWithURL:(NSURL *)url{
    
    if (self.player) {
        [self.player play];
    }else{
    
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.player.numberOfLoops = 0;
    self.player.delegate = self;
    [self.player prepareToPlay];
    if (error)
    {
        NSLog(@"播放机错误：%@", error.localizedDescription);
        return;
    }
    
    [self.player play];
    
    
    }
    
}

- (BOOL)isPlaying {
    return self.player.isPlaying;
}

- (void)stopPlay {
    [self.player stop];
}

- (void)pausePlay {
    return [self.player pause];
}




@end
