//
//  AVAudioRecordTool.m
//  AVAudioRecord
//
//  Created by Jax on 16/6/13.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import "AVAudioRecordTool.h"
#import "NSString+Extension.h"
#import "MeterTable.h"

@interface AVAudioRecordTool() <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) MeterTable *meterTable;

@end

@implementation AVAudioRecordTool

- (instancetype)init {
    if (self = [super init]) {
        
        /**
         1.音频格式
         AVFormatIDKey 键定义了写入内容的音频格式(coreAudioType.h)
         kAudioFormatLinearPCM 文件大 高保真
         kAudioFormatMPEG4AAC 显著压缩文件，并保证高质量的音频内容
         kAudioFormatAppleIMA4 显著压缩文件，并保证高质量的音频内容
         kAudioFormatiLBC
         kAudioFormatULaw
         
         2.采样率
         AVSampleRateKey 用于定义音频的采样率
         采样率越高 内容质量越高 相应文件越大
         标准采样率8000 16000 22050 44100(CD采样率)
         
         3.通道数
         AVNumberOfChannelsKey
         设值为1:意味着使用单声道录音
         设值为2:意味着使用立体声录制
         除非使用外部硬件进行录制，一般是用单声道录制
         
         */
        
        NSString *tempDirectory   = NSTemporaryDirectory();
        NSString *filePath        = [tempDirectory stringByAppendingPathComponent:@"audio.caf"];
        NSURL *fileURL            = [NSURL fileURLWithPath:filePath];
        self.tempURL              = fileURL;
        NSDictionary *settingDict = @{
                                      AVFormatIDKey  :  @(kAudioFormatMPEG4AAC_ELD),
                                      AVSampleRateKey : @(44100.0f),
                                      AVNumberOfChannelsKey :@1,
                                      AVEncoderBitDepthHintKey : @16,
                                      AVEncoderAudioQualityKey : @(AVAudioQualityMedium)
                                      };
        NSError *error            = nil;
        self.audioRecord          = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settingDict error:&error];
        if (self.audioRecord) {
            self.audioRecord.delegate        = self;
            self.audioRecord.meteringEnabled = YES;
            [self.audioRecord prepareToRecord];
        }
        _meterTable = [[MeterTable alloc] init];
        
    }
    return self;
}

#pragma mark - record

- (BOOL)record {
    return [self.audioRecord record];
}

- (void)pauseRecord {
    [self.audioRecord pause];
}

- (void)stopRecord {
    [self.audioRecord stop];
}

- (void)stopWithCompletionHandler:(AudioRecordStopCompletionHandler)handler {
    self.audioRecordCompletionBlock = handler;
    [self.audioRecord stop];
}

- (NSString *)recordFormattedCurrentTime {
    NSUInteger time = (NSUInteger)self.audioRecord.currentTime;
    return [self formatterTime:time];
}

#pragma mark - play

- (BOOL)isPlaying {
    return self.audioPlayer.isPlaying;
}

- (void)pausePlay {
    return [self.audioPlayer pause];
}

- (void)stopPlay {
    [self.audioPlayer stop];
}

- (void)playBack:(NSURL *)url {
    if (self.audioPlayer) {
        [self.audioPlayer play];
    } else {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.audioPlayer.delegate = self;
        if (self.audioPlayer) {
            [self.audioPlayer play];
        }
    }
}

- (NSString *)playFormattedCurrentTime {
    NSUInteger time = (NSUInteger)self.audioPlayer.currentTime;
    return [self formatterTime:time];
}

#pragma mark - save audio file

- (NSURL *)saveRecordingWithName:(NSString *)name {
    //不重名
//    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
//    NSString *filename = [NSString stringWithFormat:@"%@-%f.aac ", name, timestamp];
    
    //重名
    NSString *filename = [NSString stringWithFormat:@"%@.aac", name];
    
    NSString *document = [NSString documentDirectory];
    NSString *savePath = [document stringByAppendingPathComponent:filename];
    NSLog(@"----path:%@",savePath);
    NSURL *sourceURL = self.audioRecord.url;
    NSURL *saveURL = [NSURL fileURLWithPath:savePath];
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:sourceURL toURL:saveURL error:&error];
    if (success) {
        [self.audioRecord prepareToRecord];
        
        NSLog(@"----path:%@",saveURL);
    } else {
        NSLog(@"saveRecordingWithName failured: %@", error);
    }
    return saveURL;
}

#pragma mark - delegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (self.audioRecordCompletionBlock) {
        self.audioRecordCompletionBlock(flag);
    }}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.audioPlayCompletionBlock) {
        self.audioPlayCompletionBlock(flag);
    }
}

#pragma  mark - voice meter

- (MeterLavel *)meterLevel {
    
    [self.audioRecord updateMeters];
    
    CGFloat avgPower    = [self.audioRecord averagePowerForChannel:0];
    CGFloat peakPower   = [self.audioRecord peakPowerForChannel:0];
    CGFloat linearLevel = [self.meterTable valueForPower:avgPower];
    CGFloat peakLevel   = [self.meterTable valueForPower:peakPower];

    return [MeterLavel levelsWithLevel:linearLevel peakLevel:peakLevel];
    
}

#pragma mark - other

- (NSString *)formatterTime:(NSUInteger)time {
    NSInteger hours = (time / 3600);
    NSInteger minutes = (time / 60) % 60;
    NSInteger seconds = time % 60;
    
    NSString *format = @"%02i:%02i:%02i";
    return [NSString stringWithFormat:format, hours, minutes, seconds];
}














@end
