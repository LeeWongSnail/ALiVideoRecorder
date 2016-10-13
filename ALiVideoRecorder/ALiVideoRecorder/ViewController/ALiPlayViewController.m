//
//  ALiPlayViewController.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/13.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "AliPlayerControlView.h"

@interface ALiPlayViewController () <ALiPlayerControlDelegate>
/**
 *  控制视频播放的控件
 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/**
 *  声明播放视频的控件属性[既可以播放视频也可以播放音频]
 */
@property (nonatomic,strong) AVPlayer *player;
/**
 *  播放的总时长
 */
@property (nonatomic,assign) CGFloat sumPlayOperation;

@property (nonatomic, strong) AliPlayerControlView *controlView;

@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation ALiPlayViewController

#pragma mark - Config Player

- (void)configPlayer
{
    //设置播放的url
    NSURL *url = [NSURL fileURLWithPath:self.videoPath];
    //设置播放的项目
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    //初始化player对象
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    //设置播放页面
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    //设置播放页面的大小
    layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    layer.backgroundColor = [UIColor cyanColor].CGColor;
    //设置播放窗口和当前视图之间的比例显示内容
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    //添加播放视图到self.view
    [self.view.layer insertSublayer:layer atIndex:0];
    //设置播放进度的默认值
    self.progressSlider.value = 0;
    //设置播放的默认音量值
    self.player.volume = 1.0f;
}

#pragma mark - Load View

- (void)buildUI
{
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self buildUI];
    [self configPlayer];
}

- (void)startPlay
{
    if (self.isPlaying) {
        [self.player pause];
        self.isPlaying = NO;
    } else {
        [self.player play];
        self.isPlaying = YES;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.player pause];
    self.player = nil;
}

- (void)dealloc
{
}

#pragma mark - ALiPlayerControlDelegate

- (void)playerControlActionHandler:(EALiPlayerActionType)aType
{
    switch (aType) {
        case EALiPlayerActionTypeBack:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case EALiPlayerActionTypePlay:
            [self startPlay];
            break;
        default:
            break;
    }
}

#pragma mark - Lazy Load
- (AliPlayerControlView *)controlView
{
    if (_controlView == nil) {
        _controlView = [[AliPlayerControlView alloc] init];
        _controlView.delegate = self;
        [self.view addSubview:_controlView];
        [self.view bringSubviewToFront:_controlView];
    }
    return _controlView;
}

@end
