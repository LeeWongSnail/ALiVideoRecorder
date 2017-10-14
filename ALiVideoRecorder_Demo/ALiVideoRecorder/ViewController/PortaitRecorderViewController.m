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
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <CoreMotion/CoreMotion.h>
#import <AVKit/AVKit.h>
#import "ALiVideoRecorder.h"
#import "ALiBottomToolView.h"
#import "ALiTopToolView.h"
#import "ALiUtil.h"

@interface PortaitRecorderViewController () <ALiVideoRecordDelegate,ALiTopToolViewDelegate,ALiBottomToolViewDelegate>

@property (nonatomic, strong) ALiVideoRecorder *recorder;

@property (nonatomic, strong) ALiTopToolView *topTipView;

@property (nonatomic, strong) ALiBottomToolView *bottomTipView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL observeEmptyDisk;

@property (nonatomic, strong) UIVisualEffectView *recordView;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) UIInterfaceOrientation orientationLast;
@property (nonatomic, strong) CTCallCenter *callCenter;
@property (nonatomic, assign) BOOL hasIncomingCall;

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation PortaitRecorderViewController

- (void)back
{
    if (self.recorder.isCapturing) {
        //正在录制 停止录制删除缓存
        [self.recorder unloadInputOrOutputDevice];
        [self.recorder cleanCache];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)stopRecording
{
    WEAKSELF(weakSelf);
    [ALiUtil playSystemTipAudioIsBegin:NO];
    [self.recorder stopRecordingCompletion:^(UIImage *movieImage) {
        NSLog(@"%@",self.recorder.videoPath);
        CGFloat duration = [self.recorder getVideoLength:[NSURL URLWithString:self.recorder.videoPath]];
        CGFloat videoSize = [self.recorder getFileSize:self.recorder.videoPath];
        NSLog(@"%f-----%f",duration,videoSize);
        [self.recorder movieToImageHandler:^(UIImage *movieImage) {
            [weakSelf.bottomTipView configVideoThumb:movieImage];
        }];
        
        self.bottomTipView.lastVideoPath = self.recorder.videoPath;
    }];

}

//监听刚进入后台 推荐如果正在录制则停止 如果未开始录制则返回上一个界面
- (void)enterBackgroundMode:(NSNotification *)noti
{
    //进入后台
    if (self.recorder.isCapturing && !self.recorder.isPaused) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopRecording];
        });
    } else {
        //非暂停状态 暂停状态不做任何操作
        dispatch_async(dispatch_get_main_queue(), ^{
            [self back];
        });
    }
}


//监听来电
- (void)detectIncomingCall
{
    self.callCenter = [[CTCallCenter alloc] init];
    WEAKSELF(weakSelf);
    self.callCenter.callEventHandler = ^(CTCall *call){
        if([call.callState isEqualToString:CTCallStateIncoming]){
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.hasIncomingCall = YES;
                [weakSelf stopRecording];
            });
        } else {
            weakSelf.hasIncomingCall = NO;
        }
    };
}

//开始和暂停录制事件
- (void)recordAction {
    
    if (!self.recorder.isCapturing) {
        [ALiUtil playSystemTipAudioIsBegin:YES];
        [self chekcDiskSpace];
        [self.recorder startRecording];
        [self configVideoOutputOrientation];
    }else {
        [self stopRecording];
    }
}


- (void)chekcDiskSpace
{
    //单位是M
    NSInteger leftSpace = [ALiUtil diskFreeSpace]/(1000*1000);
    if (leftSpace < 100) {
        if (self.timer == nil) {
            self.timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(chekcDiskSpace) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"内存不足" message:@"存储空间不足，视频录制将自动停止" preferredStyle:UIAlertControllerStyleAlert];
        WEAKSELF(weakSelf);
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf stopRecording];
        }];
        [alert addAction:action];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)configVideoOutputOrientation
{
    switch (self.orientationLast) {
        case UIInterfaceOrientationPortrait:
            self.recorder.recordOrientation = EArtRecordOrientationPortrait;
            [self.recorder adjustRecorderOrientation:AVCaptureVideoOrientationPortrait];
            break;
        case UIInterfaceOrientationLandscapeRight:
            self.recorder.recordOrientation = EArtRecordOrientationLandscapeRight;
            [self.recorder adjustRecorderOrientation:AVCaptureVideoOrientationLandscapeRight];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            self.recorder.recordOrientation = EArtRecordOrientationLandscapeLeft;
            [self.recorder adjustRecorderOrientation:AVCaptureVideoOrientationLandscapeLeft];
            break;
        default:
            NSLog(@"不支持的录制方向");
            break;
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

- (UIInterfaceOrientation)orientationChange
{
    WEAKSELF(weakSelf);
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CMAcceleration acceleration = accelerometerData.acceleration;
        UIInterfaceOrientation orientationNew;
        if (acceleration.x >= 0.75) {
            orientationNew = UIInterfaceOrientationLandscapeLeft;
        }
        else if (acceleration.x <= -0.75) {
            orientationNew = UIInterfaceOrientationLandscapeRight;
        }
        else if (acceleration.y <= -0.75) {
            orientationNew = UIInterfaceOrientationPortrait;
        }
        else if (acceleration.y >= 0.75) {
            orientationNew = UIInterfaceOrientationPortraitUpsideDown;
            return ;
        }
        else {
            // Consider same as last time
            return;
        }
        
        
        if (!weakSelf.recorder.isCapturing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (orientationNew == weakSelf.orientationLast)
                    return;
                [weakSelf configView:orientationNew];
                weakSelf.orientationLast = orientationNew;
            });
        }
    }];
    
    
    return self.orientationLast;
}

#pragma mark - Load View
- (void)configView:(UIInterfaceOrientation)aOrientation
{
    switch (aOrientation) {
        case UIInterfaceOrientationLandscapeRight:
        {
            [self configLandscapeRightUI];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            [self configLandscapeLeftUI];
        }
            break;
        case UIInterfaceOrientationPortrait:
        {
            [self configPortraitUI];
        }
            break;
        default:
        {
            NSLog(@"不支持的方向");
        }
            break;
    }
}

- (void)configPortraitUI
{
    [self.bottomTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    [self.topTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    if (self.orientationLast == UIInterfaceOrientationLandscapeLeft) {
        self.topTipView.transform = CGAffineTransformRotate(self.topTipView.transform, M_PI_2);
         [self.bottomTipView configViewWithAngle:M_PI_2];
    } else if (self.orientationLast == UIInterfaceOrientationLandscapeRight) {
         [self.bottomTipView configViewWithAngle:-M_PI_2];
        self.topTipView.transform = CGAffineTransformRotate(self.topTipView.transform, -M_PI_2);
    }
}

- (void)configLandscapeRightUI
{
    [self.bottomTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    [self.bottomTipView configViewWithAngle:M_PI_2];
    
    [self.topTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_right).offset(-32);
        make.height.equalTo(@64);
        make.width.equalTo(@(SCREEN_W));
        
    }];
    
    if (self.orientationLast == UIInterfaceOrientationPortrait || self.orientationLast == UIInterfaceOrientationUnknown) {
        self.topTipView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else if (self.orientationLast == UIInterfaceOrientationLandscapeLeft) {
        self.topTipView.transform = CGAffineTransformMakeRotation(-M_PI);
    }
}

- (void)configLandscapeLeftUI
{
    [self.bottomTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
        [self.bottomTipView configViewWithAngle:-M_PI_2];
    [self.topTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_left).offset(32);
        make.width.equalTo(@(SCREEN_W));
        make.height.equalTo(@64);
    }];
    if (self.orientationLast == UIInterfaceOrientationLandscapeRight) {
        self.topTipView.transform = CGAffineTransformMakeRotation(-M_PI);
    } else if (self.orientationLast == UIInterfaceOrientationPortrait || self.orientationLast == UIInterfaceOrientationUnknown) {
        self.topTipView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
}

- (void)configInitScreenMode
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self configView:orientation];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configInitScreenMode];
    });
    
    
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@80);
    }];
    
    [self addGenstureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundMode:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [self detectIncomingCall];
    if([self.motionManager isAccelerometerAvailable]){
        [self orientationChange];
    }
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
    [self.motionManager stopAccelerometerUpdates];
    self.motionManager = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)dealloc
{
    NSLog(@"%s",__func__);
}


#pragma mark - ALiVideoRecordDelegate

- (void)recordProgress:(CGFloat)progress
{
//    NSLog(@"%f",progress * self.recorder.maxVideoDuration);
    [self.topTipView configTimeLabel:progress * self.recorder.maxVideoDuration];
    if ((progress *self.recorder.maxVideoDuration) > 600) {
    }
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
        case EALiTipActionTypeSwitch:
            [self.recorder switchCamera];
        default:
            break;
    }
}

#pragma mark - Lazy Load

- (ALiVideoRecorder *)recorder
{
    if (_recorder == nil) {
        _recorder = [[ALiVideoRecorder alloc] init];
        _recorder.maxVideoDuration = 3600;
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

- (CMMotionManager *)motionManager
{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 1./15.;
        
    }
    return _motionManager;
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
