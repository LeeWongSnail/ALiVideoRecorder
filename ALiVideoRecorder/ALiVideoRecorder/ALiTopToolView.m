//
//  ALiTopToolView.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/13.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiTopToolView.h"

@interface ALiTopToolView ()

//关闭
@property (nonatomic, strong) UIButton *closeRecording;

//闪光灯
@property (nonatomic, strong) UIButton *flashBtn;

//切换摄像头
@property (nonatomic, strong) UIButton *switchCamera;

@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation ALiTopToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}


- (void)buildUI
{
    CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width/3.;
    [self.closeRecording mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(btnWidth));
        make.height.equalTo(@64);
        make.left.top.equalTo(self);
    }];
    
    [self.flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(btnWidth));
        make.height.equalTo(self.closeRecording);
        make.left.equalTo(self.closeRecording.mas_right);
        make.top.equalTo(self.mas_top);
    }];
    
    [self.switchCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(btnWidth));
        make.height.equalTo(self.closeRecording);
        make.left.equalTo(self.flashBtn.mas_right);
        make.top.equalTo(self.mas_top);
    }];
}


- (void)eventHandler:(UIButton *)actionBtn
{
    if ([self.delegate respondsToSelector:@selector(tipViewActionHandler:)]) {
        [self.delegate tipViewActionHandler:actionBtn.tag - 10000];
    }
}


#pragma mark - Lazy Load

- (UIButton *)closeRecording
{
    if (_closeRecording == nil) {
        _closeRecording = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeRecording setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeRecording.tag = 10000 + EALiTipActionTypeClose;
        [_closeRecording addTarget:self action:@selector(eventHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.effectView addSubview:_closeRecording];
    }
    return _closeRecording;
}

- (UIButton *)flashBtn
{
    if (_flashBtn == nil) {
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashBtn setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
        _flashBtn.tag = 10000 + EALiTipActionTypeFlash;
        [_flashBtn addTarget:self action:@selector(eventHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.effectView addSubview:_flashBtn];
    }
    return _flashBtn;
}

- (UIButton *)switchCamera
{
    if (_switchCamera == nil) {
        _switchCamera = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCamera setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
        _switchCamera.tag = 10000 + EALiTipActionTypeSwitchCamera;
        [_switchCamera addTarget:self action:@selector(eventHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.effectView addSubview:_switchCamera];
    }
    return _switchCamera;
}

- (UIVisualEffectView *)effectView
{
    if (_effectView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:_effectView];

    }
    return _effectView;
}

@end
