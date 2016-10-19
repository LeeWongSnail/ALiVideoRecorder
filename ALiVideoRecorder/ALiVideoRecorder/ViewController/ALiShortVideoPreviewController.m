//
//  ALiShortVideoPreviewController.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/19.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiShortVideoPreviewController.h"
#import "AliShortVideoToolBar.h"
#import "ALiAssetReader.h"

@interface ALiShortVideoPreviewController () <ALiAssetReaderDelegate,ALiShortToolBarDelegate>

@property (nonatomic, strong) ALiAssetReader *reader;

@property (nonatomic, strong) UIView *playView;

@property (nonatomic, strong) AliShortVideoToolBar *toolBar;

@end

@implementation ALiShortVideoPreviewController

#pragma mark - Load View
- (void)buildUI
{
    
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(@300);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@80);
    }];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.reader startDecoderVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ALiAssetReaderDelegate

- (void)ali_mMoveDecoder:(ALiAssetReader *)reader buffer:(NSArray *)images
{
    NSLog(@"视频解档完成");
    // 得到媒体的资源
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.videoPath] options:nil];
    // 通过动画来播放我们的图片
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    // asset.duration.value/asset.duration.timescale 得到视频的真实时间
    animation.duration = asset.duration.value/asset.duration.timescale;
    animation.values = images;
    animation.repeatCount = MAXFLOAT;
    [self.playView.layer addAnimation:animation forKey:nil];
    // 确保内存能及时释放掉
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            obj = nil;
        }
    }];
}

- (void)mMovieDecoderOnDecodeFinished:(ALiAssetReader *)reader
{
    NSLog(@"完成");
}

- (void)mMovieDecoder:(ALiAssetReader *)reader onNewVideoFrameReady:(CMSampleBufferRef)videoBuffer
{
    NSLog(@"开始");
    
    CGImageRef ref = [ALiAssetReader imageFromSampleBufferRef:videoBuffer];
    self.playView.layer.contents = CFBridgingRelease(ref);
}


#pragma mark - ALiShortToolBarDelegate

- (void)shortToolBarActionHandler:(EALiShortToolActionType)aType
{
    switch (aType) {
        case EALiShortToolActionTypeSend:
         
            break;
        case EALiShortToolActionTypeRecord:
            [self.reader test];
            break;
        default:
            break;
    }
}
#pragma mark - Lazy Load

- (ALiAssetReader *)reader
{
    if (_reader == nil) {
        _reader = [[ALiAssetReader alloc] init];
        _reader.videoPath = self.videoPath;
        _reader.delegate = self;
    }
    return _reader;
}

- (UIView *)playView
{
    if (_playView == nil) {
        _playView = [[UIView alloc] init];
        _playView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_playView];
    }
    return _playView;
}

- (AliShortVideoToolBar *)toolBar
{
    if (_toolBar == nil) {
        _toolBar = [[AliShortVideoToolBar alloc] init];
        _toolBar.delegate = self;
        [self.view addSubview:_toolBar];
    }
    return _toolBar;
}

@end
