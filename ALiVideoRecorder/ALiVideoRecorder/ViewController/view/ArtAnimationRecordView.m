//
//  ArtAnimationRecordView.m
//  ArtStudio
//
//  Created by lbq on 2017/2/8.
//  Copyright © 2017年 kimziv. All rights reserved.
//

#import "ArtAnimationRecordView.h"
//#import "ArtMicroVideoConfig.h"

#define kCircleLineWidth 5.
// 视频录制 时长
#define kRecordTime        11.0

@interface ArtAnimationRecordView()<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *readyImageView;
@property (nonatomic, strong) UIImageView *startImageView;
@property (nonatomic, strong) MASConstraint *startWidthConstraint;
@property (nonatomic, strong) MASConstraint *startHeightConstraint;
@property (nonatomic, strong) MASConstraint *readyWidthConstraint;
@property (nonatomic, strong) MASConstraint *readyHeightConstraint;

@property (nonatomic, assign) CFTimeInterval startTime;
//@property (nonatomic, assign) CFTimeInterval stopTime;

@property (nonatomic, strong) CAShapeLayer *arcLayer;

@end

@implementation ArtAnimationRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
   
- (void)makeUI
{
    [self.readyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.readyWidthConstraint = make.width.equalTo(@100.);
        self.readyHeightConstraint = make.height.equalTo(@100.);
        make.center.equalTo(self);
    }];
    
    [self.startImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.startWidthConstraint = make.width.equalTo(@100.);
        self.startHeightConstraint = make.height.equalTo(@100.);
        make.center.equalTo(self);
    }];
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    longpress.minimumPressDuration = 0.1;
    [self addGestureRecognizer:longpress];
}

- (void)addCircleLayer
{
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect = CGRectMake(0, 0, 120., 120.);
    [path addArcWithCenter:CGPointMake(60., 60.) radius:((rect.size.height - kCircleLineWidth)/2.) startAngle:-M_PI_2 endAngle:2*M_PI clockwise:YES];
    if (self.arcLayer) {
        [self.arcLayer removeAnimationForKey:@"CircleAnimantion"];
        [self.arcLayer removeFromSuperlayer];
        self.arcLayer = nil;
    }
    self.arcLayer = [CAShapeLayer layer];
    self.arcLayer.path = path.CGPath;//46,169,230
    self.arcLayer.fillColor = [UIColor clearColor].CGColor;
    self.arcLayer.strokeColor = [UIColor colorWithRed:50/255. green:190/255. blue:120/255. alpha:1].CGColor;
    self.arcLayer.lineWidth = kCircleLineWidth;
    self.arcLayer.frame = rect;
    [self.startImageView.layer addSublayer:self.arcLayer];
    [self drawLineAnimation];
}
//定义动画过程
-(void)drawLineAnimation
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = kRecordTime;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [self.arcLayer addAnimation:bas forKey:@"CircleAnimantion"];
}

- (void)handleGesture:(UIGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"began");
            [self startAnimation];
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"end");
            [self endAnimation];
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"cancel");
            break;
            
        default:
            break;
    }
}

- (void)startAnimation
{
    self.startWidthConstraint.equalTo(@120);
    self.startHeightConstraint.equalTo(@120);
    self.readyWidthConstraint.equalTo(@80.);
    self.readyHeightConstraint.equalTo(@80.);
    [UIView animateWithDuration:0.2 animations:^{
        self.readyImageView.alpha = 0.;
        self.startImageView.alpha = 1.0;
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self addCircleLayer];
    }];
}

- (void)endAnimation
{
    self.startWidthConstraint.equalTo(@100.);
    self.startHeightConstraint.equalTo(@100.);
    self.readyWidthConstraint.equalTo(@100.);
    self.readyHeightConstraint.equalTo(@100.);
    [self.arcLayer removeAnimationForKey:@"CircleAnimantion"];
    [self.arcLayer removeFromSuperlayer];
    [UIView animateWithDuration:0.2 animations:^{
        self.readyImageView.alpha = 1.;
        self.startImageView.alpha = 0.;
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self.arcLayer removeAnimationForKey:@"CircleAnimantion"];
        [self.arcLayer removeFromSuperlayer];
        self.arcLayer = nil;
    }];
}

//MARK: CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    self.startTime = CACurrentMediaTime();
    NSLog(@"leoliu=====didStart time = %f",self.startTime);
    
    if (self.startRecord) {
        self.startRecord();
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CFTimeInterval didStopTime = CACurrentMediaTime() - self.startTime;
    NSLog(@"leoliu=====stop flag = %tu  stopTime = %f",flag,didStopTime);
    [self endAnimation];
    if (self.completeRecord) {
        self.completeRecord(didStopTime);
    }
}

//MARK: lazy
- (UIImageView *)readyImageView
{
    if(!_readyImageView){
        _readyImageView = [[UIImageView alloc] init];
        _readyImageView.image = [UIImage imageNamed:@"record_ready"];
        _readyImageView.alpha = 1.;
        _readyImageView.userInteractionEnabled = YES;
        [self addSubview:_readyImageView];
    }
    return _readyImageView;
}

- (UIImageView *)startImageView
{
    if(!_startImageView){
        _startImageView = [[UIImageView alloc] init];
        _startImageView.image = [UIImage imageNamed:@"record_start"];
        _startImageView.alpha = 0.;
        _startImageView.userInteractionEnabled = YES;
        [self addSubview:_startImageView];
    }
    return _startImageView;
}
@end
