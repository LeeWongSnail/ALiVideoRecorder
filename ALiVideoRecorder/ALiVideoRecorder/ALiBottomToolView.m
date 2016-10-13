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

@property (nonatomic, strong) UILabel *timeLabel;

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
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recordBtn);
        make.bottom.equalTo(self.recordBtn.mas_top).offset(-2);
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

- (void)configTimeLabel:(CGFloat)seconds
{
    NSInteger time = ceil(seconds);
    NSInteger second = time%60;
    NSInteger minute = time/60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld : %02ld",minute,second];
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

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12.];
        _timeLabel.layer.cornerRadius = 5;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

@end
