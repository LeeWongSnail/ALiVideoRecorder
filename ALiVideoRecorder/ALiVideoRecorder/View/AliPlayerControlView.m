//
//  AliPlayerControlView.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/13.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "AliPlayerControlView.h"

@interface AliPlayerControlView ()
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation AliPlayerControlView

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
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@91);
        make.height.equalTo(@64);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(30);
    }];
}

#pragma mark - Event Handler

- (void)eventHandler:(UIButton *)aButton
{
    [aButton setSelected:!aButton.isSelected];
    if ([self.delegate respondsToSelector:@selector(playerControlActionHandler:)]) {
        [self.delegate playerControlActionHandler:aButton.tag - 10000];
    }
}


#pragma mark - Lazy Load

- (UIButton *)startBtn
{
    if (_startBtn == nil) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.tag = 10000 + EALiPlayerActionTypePlay;
        [_startBtn addTarget:self action:@selector(eventHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_startBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [self.effectView addSubview:_startBtn];
    }
    return _startBtn;
}

- (UIButton *)backBtn
{
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.tag = 10000 + EALiPlayerActionTypeBack;
        [_backBtn addTarget:self action:@selector(eventHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
         [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected];
        [self addSubview:_backBtn];
    }
    return _backBtn;
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
