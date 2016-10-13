//
//  PortaitRecorderViewController.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/12.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "PortaitRecorderViewController.h"
#import "ALiPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "ALiVideoRecorder.h"
#import "ALiBottomToolView.h"
#import "ALiTopToolView.h"

@interface PortaitRecorderViewController () <ALiVideoRecordDelegate,ALiTopToolViewDelegate,ALiBottomToolViewDelegate>

@property (nonatomic, strong) ALiVideoRecorder *recorder;

@property (nonatomic, strong) ALiTopToolView *topTipView;

@property (nonatomic, strong) ALiBottomToolView *bottomTipView;

@property (nonatomic, strong) UIVisualEffectView *recordView;

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation PortaitRecorderViewController

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//开始和暂停录制事件
- (void)recordAction {
    
    if (!self.recorder.isCapturing) {
        [self.recorder startRecording];
        self.topTipView.hidden = YES;
    }else {
        [self.recorder stopRecordingCompletion:^(UIImage *movieImage) {
            NSLog(@"%@",self.recorder.videoPath);
            CGFloat duration = [self.recorder getVideoLength:[NSURL URLWithString:self.recorder.videoPath]];
            CGFloat videoSize = [self.recorder getFileSize:self.recorder.videoPath];
            NSLog(@"%f-----%f",duration,videoSize);
            WEAKSELF(weakSelf);
            [self.recorder movieToImageHandler:^(UIImage *movieImage) {
                [weakSelf.bottomTipView configVideoThumb:movieImage];
            }];
            
            self.bottomTipView.lastVideoPath = self.recorder.videoPath;
            self.topTipView.hidden = NO;
        }];
        
    }
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.view addGestureRecognizer:tapGesture];
}
-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    CGPoint point= [tapGesture locationInView:self.view];
    [self.recorder setFocusCursorWithPoint:point];
}



#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@80);
    }];
    
    [self.bottomTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];

    
    [self.topTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    
    [self addGenstureRecognizer];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ALiVideoRecordDelegate

- (void)recordProgress:(CGFloat)progress
{
    NSLog(@"%f",progress * self.recorder.maxVideoDuration);
    [self.bottomTipView configTimeLabel:progress * self.recorder.maxVideoDuration];
}

#pragma mark - ALiTopToolViewDelegate

- (void)tipViewActionHandler:(EALiTopTipActionType)aType
{
    switch (aType) {
        case EALiTipActionTypeClose:
            [self back];
            break;
        case EALiTipActionTypeFlash:
            [self.recorder switchFlashLight];
            break;
        case EALiTipActionTypeSwitchCamera:
            [self.recorder switchCamera];
            break;
        default:
            break;
    }
}

#pragma mark - ALiBottomToolViewDelegate

- (void)bottomTipViewActionHandler:(EALiTipActionType)aType
{
    switch (aType) {
        case EALiTipActionTypeRecord:
            [self recordAction];
            break;
        case EALiTipActionTypePlay:
        {
            ALiPlayViewController *playVc = [[ALiPlayViewController alloc] init];
            playVc.videoPath = self.bottomTipView.lastVideoPath;
            [self presentViewController:playVc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
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

- (ALiTopToolView *)topTipView
{
    if (_topTipView == nil) {
        _topTipView = [[ALiTopToolView alloc] init];
        _topTipView.delegate = self;
        [self.view addSubview:_topTipView];
    }
    return _topTipView;
}

- (ALiBottomToolView *)bottomTipView
{
    if (_bottomTipView == nil) {
        _bottomTipView = [[ALiBottomToolView alloc] init];
        _bottomTipView.delegate = self;
        [self.view addSubview:_bottomTipView];
    }
    return _bottomTipView;
}


- (UIView *)recordView
{
    if (_recordView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _recordView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self.view addSubview:_recordView];
    }
    return _recordView;
}

@end
