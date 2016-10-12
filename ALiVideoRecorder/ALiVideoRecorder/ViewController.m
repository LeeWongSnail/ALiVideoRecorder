//
//  ViewController.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/12.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ViewController.h"
#import "ALiVideoRecorder.h"
#import "Masonry.h"


@interface ViewController () <ALiVideoRecordDelegate>

@property (nonatomic, strong) ALiVideoRecorder *recorder;

@property (nonatomic, strong) UIButton *recordBtn;

@end

@implementation ViewController

#pragma mark - Custom Method
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
        [_recordBtn setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(recordAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_recordBtn];
    }
    return _recordBtn;
}

@end
