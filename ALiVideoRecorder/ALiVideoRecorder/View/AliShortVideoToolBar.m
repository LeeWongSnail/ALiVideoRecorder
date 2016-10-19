//
//  AliShortVideoToolBar.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/19.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "AliShortVideoToolBar.h"


@interface AliShortVideoToolBar ()

@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation AliShortVideoToolBar

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
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.centerY.equalTo(self.effectView.mas_centerY);
        make.centerX.equalTo(self.effectView.mas_centerX);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBtn.mas_centerY);
        make.left.equalTo(self.recordBtn.mas_right).offset(50);
        make.width.height.equalTo(@40);
    }];
    
}

#pragma mark - Event Handler

- (void)onClickHanlder:(UIButton *)aButton
{
    [aButton setSelected:!aButton.isSelected];
    if ([self.delegate respondsToSelector:@selector(shortToolBarActionHandler:)]) {
        [self.delegate shortToolBarActionHandler:aButton.tag - 10000];
    }
}


#pragma mark - Lazy Load

- (UIButton *)recordBtn
{
    if (_recordBtn == nil) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage imageNamed:@"editor_video_start_normal"] forState:UIControlStateNormal];
        [_recordBtn setImage:[UIImage imageNamed:@"editor_video_start_selected"] forState:UIControlStateSelected];
        _recordBtn.tag = EALiShortToolActionTypeRecord + 10000;
        [_recordBtn addTarget:self action:@selector(onClickHanlder:) forControlEvents:UIControlEventTouchUpInside];
        [self.effectView addSubview:_recordBtn];
    }
    return _recordBtn;
}

- (UIButton *)sendBtn
{
    if (_sendBtn == nil) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        [_sendBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateSelected];
        _sendBtn.tag = EALiShortToolActionTypeSend + 10000;
        [_sendBtn addTarget:self action:@selector(onClickHanlder:) forControlEvents:UIControlEventTouchUpInside];
        [self.effectView addSubview:_sendBtn];
    }
    return _sendBtn;
}


- (UIVisualEffectView *)effectView
{
    if (_effectView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:_effectView];
        
    }
    return _effectView;
}

@end
