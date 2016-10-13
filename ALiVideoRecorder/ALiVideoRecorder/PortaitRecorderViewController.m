//
//  PortaitRecorderViewController.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/12.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "PortaitRecorderViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ALiVideoRecorder.h"

@interface PortaitRecorderViewController () <ALiVideoRecordDelegate>

@property (nonatomic, strong) ALiVideoRecorder *recorder;

@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@end

@implementation PortaitRecorderViewController

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//开始和暂停录制事件
- (void)recordAction:(UIButton *)sender {
    
    self.recordBtn.selected = !self.recordBtn.selected;
    if (self.recordBtn.selected) {
        if (self.recorder.isCapturing) {
            [self.recorder resumeRecording];
        }else {
            [self.recorder startRecording];
        }
    }else {
        [self.recorder stopRecordingCompletion:^(UIImage *movieImage) {
            NSLog(@"%@",self.recorder.videoPath);
            CGFloat duration = [self.recorder getVideoLength:[NSURL URLWithString:self.recorder.videoPath]];
            CGFloat videoSize = [self.recorder getFileSize:self.recorder.videoPath];
            NSLog(@"%f-----%f",duration,videoSize);
        }];
        
    }
}



#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
        make.width.height.equalTo(@80);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recordBtn);
        make.bottom.equalTo(self.recordBtn.mas_top).offset(-15);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.top.equalTo(self.view.mas_top).offset(30);
        make.left.equalTo(self.view.mas_left);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.recorder openPreview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.recorder closePreview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ALiVideoRecordDelegate

- (void)recordProgress:(CGFloat)progress
{
    NSLog(@"%f",progress * self.recorder.maxVideoDuration);
    
    NSInteger time = ceil(progress * self.recorder.maxVideoDuration);
    NSInteger second = time%60;
    NSInteger minute = time/60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld : %02ld",minute,second];
}

#pragma mark - Lazy Load

- (ALiVideoRecorder *)recorder
{
    if (_recorder == nil) {
        _recorder = [[ALiVideoRecorder alloc] init];
        _recorder.maxVideoDuration = 300;
        _recorder.delegate = self;
        _recorder.previewLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:_recorder.previewLayer atIndex:0];
    }
    return _recorder;
}

- (UIButton *)recordBtn
{
    if (_recordBtn == nil) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage imageNamed:@"editor_video_start_normal"] forState:UIControlStateNormal];
        [_recordBtn setImage:[UIImage imageNamed:@"editor_video_start_selected"] forState:UIControlStateSelected];
        [_recordBtn addTarget:self action:@selector(recordAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_recordBtn];
    }
    return _recordBtn;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor blackColor];
        _timeLabel.layer.cornerRadius = 5;
        [self.view addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIButton *)backBtn
{
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"common_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
    }
    return _backBtn;
}

//- (MPMoviePlayerController *)moviePlayer
//{
//    if (_moviePlayer == nil) {
//        _moviePlayer = [[MPMoviePlayerController alloc] init];
//        _moviePlayer.shouldAutoplay = YES;
//        [self.view addSubview:_moviePlayer.view];
//    }
//    return _moviePlayer;
//}

@end
