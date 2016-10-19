//
//  ALiShortVideoController.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/19.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiShortVideoController.h"
#import "ALiShortVideoPreviewController.h"
#import "AliShortVideoToolBar.h"
#import "ALiVideoRecorder.h"

@interface ALiShortVideoController () <ALiVideoRecordDelegate,ALiShortToolBarDelegate>

@property (nonatomic, strong) ALiVideoRecorder *recorder;
@property (nonatomic, strong) AliShortVideoToolBar *toolBar;

@end

@implementation ALiShortVideoController

#pragma mark - Custom Method

//开始和暂停录制事件
- (void)recordAction {
    
    if (!self.recorder.isCapturing) {
        [self.recorder startRecording];
    }else {
        [self.recorder stopRecordingCompletion:^(UIImage *movieImage) {
            NSLog(@"%@",self.recorder.videoPath);
            CGFloat duration = [self.recorder getVideoLength:[NSURL URLWithString:self.recorder.videoPath]];
            CGFloat videoSize = [self.recorder getFileSize:self.recorder.videoPath];
            NSLog(@"%f-----%f",duration,videoSize);
        }];
        
    }
}

- (void)sendVideo
{
    
    if (self.recorder.videoPath.length == 0) {
        NSLog(@"请先录制视频");
        return;
    }
    
    ALiShortVideoPreviewController *previewVc = [[ALiShortVideoPreviewController alloc] init];
    previewVc.videoPath = self.recorder.videoPath;
    [self.navigationController pushViewController:previewVc animated:YES];
}


#pragma mark - Load View
- (void)buildUI
{
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
    
}

#pragma mark - ALiShortToolBarDelegate

- (void)shortToolBarActionHandler:(EALiShortToolActionType)aType
{
    switch (aType) {
        case EALiShortToolActionTypeSend:
            [self sendVideo];
            break;
        case EALiShortToolActionTypeRecord:
            [self recordAction];
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
        CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
        _recorder.previewLayer.frame = CGRectMake(0, self.view.center.y - 150, size.width, size.height);
        [self.view.layer insertSublayer:_recorder.previewLayer atIndex:0];
    }
    return _recorder;
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
