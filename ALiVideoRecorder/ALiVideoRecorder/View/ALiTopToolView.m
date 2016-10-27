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

@property (nonatomic, strong) UILabel *timeLabel;

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
    CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width/4.;
    [self.closeRecording mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(btnWidth));
        make.height.equalTo(@64);
        make.left.equalTo(self);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(btnWidth));
        make.height.equalTo(self.closeRecording);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.closeRecording.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
}


- (void)eventHandler:(UIButton *)actionBtn
{
    if ([self.delegate respondsToSelector:@selector(tipViewActionHandler:)]) {
        [self.delegate tipViewActionHandler:actionBtn.tag - 10000];
    }
}

- (void)configTimeLabel:(CGFloat)seconds
{
    NSInteger time = ceil(seconds);
    NSInteger second = time%60;
    NSInteger minute = time/60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld : %02ld",(long)minute,(long)second];
}

//做对应的旋转
- (void)configViewWithOrientation:(CGFloat)angle
{

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

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:15.];
        _timeLabel.layer.cornerRadius = 10;
        _timeLabel.text = @"00:00";
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
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
