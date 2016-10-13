//
//  ArtAdviseOperationView.m
//  ArtBox
//
//  Created by leoliu on 15/12/31.
//  Copyright © 2015年 zhaoguogang. All rights reserved.
//

#import "ArtAdviseOperationView.h"

#define v_w 160.
#define v_h 180.

static UIView *bgView;
static UIButton *closeBtn;

@interface ArtAdviseOperationView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) void(^close)();

@end

@implementation ArtAdviseOperationView

- (id)initWithTitle:(NSString *)title image:(NSString *)imageName closeBlock:(void (^)())closeBlock
{
    if (self = [super init]) {
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@20);
        }];
        
        self.imageView.image = [UIImage imageNamed:imageName];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(v_h - 20.));
        }];
        self.close = closeBlock;
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    if (!bgView) {
        bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.7;
        [view addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
    
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(v_w));
        make.height.equalTo(@(v_h));
        make.center.equalTo(view);
    }];
    
    if (!closeBtn) {
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40.);
            make.width.equalTo(@40.);
            make.top.equalTo(view.mas_top);
            make.left.equalTo(view.mas_left).offset(10.);
        }];
        
        [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    

    self.transform = CGAffineTransformMakeRotation(-M_PI/2);
}

- (void)dismiss
{
    [bgView removeFromSuperview];
    bgView = nil;
    [closeBtn removeFromSuperview];
    closeBtn = nil;
    [self removeFromSuperview];
}

- (void)closeAction:(id)sender
{
    if (self.close) {
        [UIView animateWithDuration:0.2 animations:^{
            bgView.alpha = 0.;
            closeBtn.alpha = 0.;
            self.alpha = 0.;
        }completion:^(BOOL finished) {
            [self dismiss];
            self.close();
        }];
    }
}

#pragma mark - lazy

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)imageView
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
