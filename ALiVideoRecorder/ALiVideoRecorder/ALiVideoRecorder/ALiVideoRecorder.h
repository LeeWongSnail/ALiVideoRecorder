//
//  ALiVideoRecorder.h
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/12.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ALiVideoRecordDelegate <NSObject>

- (void)recordProgress:(CGFloat)progress;

@end

@interface ALiVideoRecorder : NSObject

@property (atomic, strong) NSString *videoPath;//视频路径

@property (nonatomic, assign) NSInteger maxVideoDuration;   //最长视频时长

@property (nonatomic, weak) id <ALiVideoRecordDelegate> delegate;

//捕获到的视频呈现的layer
- (AVCaptureVideoPreviewLayer *)previewLayer;
//启动录制功能
- (void)startUp;
//关闭录制功能
- (void)shutdown;
//开始录制
- (void) startCapture;
//暂停录制
- (void) pauseCapture;
//停止录制
- (void) stopCaptureHandler:(void (^)(UIImage *movieImage))handler;
//继续录制
- (void) resumeCapture;
//开启闪光灯
- (void)openFlashLight;
//关闭闪光灯
- (void)closeFlashLight;
//切换前后置摄像头
- (void)changeCameraInputDeviceisFront:(BOOL)isFront;
//将mov的视频转成mp4
- (void)changeMovToMp4:(NSURL *)mediaURL dataBlock:(void (^)(UIImage *movieImage))handler;



@end
