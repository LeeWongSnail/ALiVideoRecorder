//
//  ViewController.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/12.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ViewController.h"
#import "ALiVideoRecorder.h"


@interface ViewController () <ALiVideoRecordDelegate>

@property (nonatomic, strong) ALiVideoRecorder *recorder;

@property (nonatomic, strong) UIButton *recordBtn;

@end

@implementation ViewController

#pragma mark - Custom Method
//开始和暂停录制事件
- (IBAction)recordAction:(UIButton *)sender {

    self.recordBtn.selected = !self.recordBtn.selected;
    if (self.recordBtn.selected) {
        if (self.recorder.isCapturing) {
            [self.recorder resumeRecording];
        }else {
            [self.recorder startRecording];
        }
    }else {
        [self.recorder pauseRecording];
    }
}

- (void)stopRecordingHandler
{
    if (self.recorder.videoPath.length > 0) {

        [self.recorder stopRecordingCompletion:^(UIImage *movieImage) {
//            weakSelf.playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:weakSelf.recordEngine.videoPath]];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[weakSelf.playerVC moviePlayer]];
//            [[weakSelf.playerVC moviePlayer] prepareToPlay];
//            
//            [weakSelf presentMoviePlayerViewControllerAnimated:weakSelf.playerVC];
//            [[weakSelf.playerVC moviePlayer] play];
            NSLog(@"%@",self.recorder.videoPath);
        }];
    }else {
        NSLog(@"请先录制视频~");
    }
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
    NSLog(@"%f",progress);
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
        [_recordBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.view addSubview:_recordBtn];
    }
    return _recordBtn;
}

@end
