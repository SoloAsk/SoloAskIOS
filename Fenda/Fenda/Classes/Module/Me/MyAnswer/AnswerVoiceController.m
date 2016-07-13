//
//  AnswerVoiceController.m
//  Fenda
//
//  Created by zhiwei on 16/6/28.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "AnswerVoiceController.h"
#import "AVAudioRecordTool.h"
#import "AVAudioSession+Extension.h"
#import "NoQandAController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"


@interface AnswerVoiceController ()

//录音
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

//发送
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

//重录
@property (weak, nonatomic) IBOutlet UIButton *againBtn;

//用户头像
@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;

//用户名
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

//问题内容
@property (weak, nonatomic) IBOutlet UILabel *askContentLabel;

//提问时间
@property (weak, nonatomic) IBOutlet UILabel *askTimeLabel;

//拒绝按钮
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;

//记录录音按钮状态：0开始录音，1停止录音，2播放录音
@property (nonatomic,assign) NSInteger num;
//录音
@property (nonatomic, strong) AVAudioRecordTool *recordTool;

@property (nonatomic,strong) NSURL *playURL;

//时间Label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//记录label数字
@property (nonatomic,assign) NSInteger times;
//播放状态(yes：录音 no：播放)
@property (nonatomic,assign) BOOL state;
//记录录音时间
@property (strong, nonatomic) NSTimer *recordTimer;


@end

@implementation AnswerVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self setupData];
    
    //初始化录音工具类
    self.recordTool = [[AVAudioRecordTool alloc] init];
    
}





-(AVAudioRecordTool *)recordTool{
    
    if (_recordTool == nil) {
        _recordTool = [[AVAudioRecordTool alloc] init];
    }
    
    return _recordTool;
}



#pragma mark - 初始化界面数据
-(void)setupData{
    
    //头像,用户名
    
                
    [self.userIconBtn sd_setImageWithURL:[NSURL URLWithString:[self.quesModel.askUser objectForKey:@"userIcon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"001"]];
    self.userNameLabel.text = [self.quesModel.askUser objectForKey:@"userName"];
    
    
    //问题价格
    NSNumberFormatter *fmatter = [[NSNumberFormatter alloc] init];
    self.priceLabel.text = [NSString stringWithFormat:@"$%@",[fmatter stringFromNumber:self.quesModel.quesPrice]];
    
    //问题内容
    self.askContentLabel.text = self.quesModel.quesContent;
    
    //时间
    self.askTimeLabel.text = [Tools compareCurrentTime:self.quesModel.createdAt];
}


#pragma mark - 初始化UI界面
- (void)setupUI {
    self.title = NSLocalizedString(@"问题详情", "");
    
    self.num = 0;
    self.againBtn.userInteractionEnabled = NO;
    self.sendBtn.userInteractionEnabled = NO;

    
    BackBarBtnView *backview = [[BackBarBtnView alloc] init];
    backview.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backview];
    
    self.rejectBtn.layer.cornerRadius = 3;
    self.rejectBtn.clipsToBounds = YES;
    self.rejectBtn.layer.borderColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0].CGColor;
    self.rejectBtn.layer.borderWidth = 1;
    
    self.userIconBtn.layer.cornerRadius = 18;
    self.userIconBtn.clipsToBounds = YES;
    self.sendBtn.layer.cornerRadius = 5;
    self.sendBtn.clipsToBounds = YES;
    self.againBtn.layer.cornerRadius = 30;
    self.againBtn.clipsToBounds = YES;
}

//拒绝
- (IBAction)refuseBtn:(UIButton *)sender {
    
}

#pragma mark - 时间Label
- (void)startRecordTimer {
    [self.recordTimer invalidate];
    self.recordTimer = [NSTimer timerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(updateRecordCurrentTime)
                                             userInfo:nil
                                              repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
}

- (void)stopRecordTimer {
    [self.recordTimer invalidate];
    self.recordTimer = nil;
}

- (void)updateRecordCurrentTime {
    
    if (self.state) {//录音状态

        NSInteger t = [self.timeLabel.text integerValue];
        
//        t++;
//        self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",(long)t];
//        self.times = t;
        
        if (t < 60) {//不到一分钟，继续录音
            t++;
            self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",(long)t];
            self.times = t;
        }else{//到一分钟，停止录音
            
            self.num = 1;
            [self recordBtnClick:self.recordBtn];
            
        }
        
        
        
        
    }else{//播放状态
        
        NSInteger t = [self.timeLabel.text integerValue];
        t--;
        if (t == 0) {//播放完成
            [self stopRecordTimer];
            self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",(long)self.times];
            [self.recordBtn setImage:[UIImage imageNamed:@"ic_answer_play"] forState:UIControlStateNormal];
            self.num = 2;
            return;
        }
        self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",(long)t];
    }
    
    
}

#pragma mark - 开始录音
- (IBAction)recordBtnClick:(UIButton *)sender {
    
    
    if (self.num == 0) {//开始录音
        [sender setImage:[UIImage imageNamed:@"ic_answer_stop"] forState:UIControlStateNormal];
        self.num++;
        self.againBtn.userInteractionEnabled = NO;
        self.sendBtn.userInteractionEnabled = NO;
        
        self.state = YES;
        [self startRecordTimer];
        
        [AVAudioSession setCategory:AVAudioSessionCategoryRecord];
        [self.recordTool record];
        
    }else if (self.num == 1){//停止录音
        
        [sender setImage:[UIImage imageNamed:@"ic_answer_play"] forState:UIControlStateNormal];
        self.num++;
        self.againBtn.userInteractionEnabled = YES;
        self.sendBtn.userInteractionEnabled = YES;
        [self.againBtn setBackgroundColor:AGAIN_BUTTON_COLOR];
        [self.sendBtn setBackgroundColor:MAIN_RED_COLOR];
        
        [AVAudioSession setCategory:AVAudioSessionCategoryPlayback];
        [self.recordTool stopRecord];
        [self stopRecordTimer];
        
        self.playURL = [self.recordTool saveRecordingWithName:@"luyin"];
        
    }else if (self.num == 2){//播放录音
        
        [AVAudioSession setCategory:AVAudioSessionCategoryPlayback];
        if (self.recordTool.isPlaying) {
//            [self.recordTool pausePlay];
            return ;
        }
        
        [sender setImage:[UIImage imageNamed:@"ic_answer_stop"] forState:UIControlStateNormal];
        
        self.state = NO;
        [self startRecordTimer];
        
        [self.recordTool playBack:self.playURL];
    }
    
 
    
}


#pragma mark - 重录
- (IBAction)againBtnClick:(UIButton *)sender {
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Re-record will delete this record" message:@"Sure to delete and rerecord?" preferredStyle:UIAlertControllerStyleAlert];
    
    //取消
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    //重录？
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.againBtn.userInteractionEnabled = NO;
        self.sendBtn.userInteractionEnabled = NO;
        [self.againBtn setBackgroundColor:MAIN_GRAY_COLOR];
        [self.sendBtn setBackgroundColor:MAIN_GRAY_COLOR];
        [self.recordBtn setImage:[UIImage imageNamed:@"ic_answer_record"] forState:UIControlStateNormal];
        [self stopRecordTimer];
        self.num = 0;
        self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",(long)self.num];
    
        [self removeRecordState];
        
        
    }];
    
    [alertControl addAction:alertAction1];
    [alertControl addAction:alertAction2];

    [self presentViewController:alertControl animated:YES completion:nil];
                                       
}

//TODO:删除录音
-(void)removeRecordState{
    
    if (self.playURL) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager removeItemAtURL:self.playURL error:nil]) {
            NSLog(@"删除保存的录音文件成功---1");
        }else{
            
            NSLog(@"删除保存的录音文件失败---1");
        }
        
        self.recordTool = nil;
    }
    
    
    
}

#pragma mark - 发送
- (IBAction)sendBtnClick:(UIButton *)sender {
    
    
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [self removeRecordState];

}




@end
