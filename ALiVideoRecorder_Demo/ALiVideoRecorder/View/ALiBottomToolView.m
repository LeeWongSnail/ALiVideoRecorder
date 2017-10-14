//
//  ALiBottomToolView.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/13.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiBottomToolView.h"

@interface ALiBottomToolView ()

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, strong) UIButton *videoThumb;





//切换摄像头
@property (nonatomic, strong) UIButton *switchCamera;

@end


@implementation ALiBottomToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self buildUI];
    }
    return self;
}


- (void)buildUI
{
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.videoThumb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@50);
    }];
    
    [self.switchCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.recordBtn.mas_centerY);
    }];
}

- (void)actionHandler:(UIButton *)aBtn
{
    [aBtn setSelected:!aBtn.isSelected];
    if ([self.delegate respondsToSelector:@selector(bottomTipViewActionHandler:)]) {
        [self.delegate bottomTipViewActionHandler:aBtn.tag - 10000];
    }
}

- (void)configVideoThumb:(UIImage *)thumbImage
{
    [self.videoThumb setImage:thumbImage forState:UIControlStateNormal];
}

//做对应的旋转
- (void)configViewWithAngle:(CGFloat)angle
{
    self.videoThumb.transform = CGAffineTransformRotate(self.videoThumb.transform,angle);
    self.switchCamera.transform = CGAffineTransformRotate(self.switchCamera.transform,angle);
}

#pragma mark - Lazy Load

- (UIVisualEffectView *)effectView
{
    if (_effectView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:_effectView];
        
    }
    return _effectView;
}

- (UIButton *)videoThumb
{
    if (_videoThumb == nil) {
        _videoThumb = [UIButton buttonWithType:UIButtonTypeCustom];
        _videoThumb.tag = 10000 + EALiTipActionTypePlay;
        [_videoThumb setBackgroundColor:[UIColor blackColor]];
        [_videoThumb addTarget:self action:@selector(actionHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_videoThumb];
    }
    return _videoThumb;
}

- (UIButton *)recordBtn
{
    if (_recordBtn == nil) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage imageNamed:@"editor_video_start_normal"] forState:UIControlStateNormal];
        [_recordBtn setImage:[UIImage imageNamed:@"editor_video_start_selected"] forState:UIControlStateSelected];
        _recordBtn.tag = 10000 + EALiTipActionTypeRecord;
        [_recordBtn addTarget:self action:@selector(actionHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_recordBtn];
    }
    return _recordBtn;
}

- (UIButton *)switchCamera
{
    if (_switchCamera == nil) {
        _switchCamera = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCamera setBackgroundImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
        _switchCamera.tag = 10000 + EALiTipActionTypeRecord;
        [_switchCamera addTarget:self action:@selector(actionHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.effectView addSubview:_switchCamera];
    }
    return _switchCamera;
}



@end
