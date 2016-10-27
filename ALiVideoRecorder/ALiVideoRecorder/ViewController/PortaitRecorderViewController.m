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
#import <CoreMotion/CoreMotion.h>
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

@property (nonatomic, assign) UIInterfaceOrientation orientationLast;

@property (nonatomic, strong) CMMotionManager *motionManager;

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
    [self.bottomTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    
    [self.topTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    if (self.orientationLast == UIInterfaceOrientationLandscapeLeft) {
        
    } else if (self.orientationLast == UIInterfaceOrientationLandscapeRight) {
        
    }
}

- (void)configLandscapeRightUI
{
    [self.bottomTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    
    [self.topTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    if (self.orientationLast == UIInterfaceOrientationPortrait || self.orientationLast == UIInterfaceOrientationUnknown) {
    } else if (self.orientationLast == UIInterfaceOrientationLandscapeLeft) {
    }
}

- (void)configLandscapeLeftUI
{
    [self.bottomTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    
    [self.topTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    if (self.orientationLast == UIInterfaceOrientationLandscapeRight) {

    } else if (self.orientationLast == UIInterfaceOrientationPortrait || self.orientationLast == UIInterfaceOrientationUnknown) {
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
    [self.topTipView configTimeLabel:progress * self.recorder.maxVideoDuration];
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
