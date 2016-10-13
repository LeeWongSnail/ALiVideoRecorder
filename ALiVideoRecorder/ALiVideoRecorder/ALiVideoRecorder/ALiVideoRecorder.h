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
@property (nonatomic, assign) NSInteger maxVideoDuration;   //最长视频时长

//状态输出
@property (atomic, assign, readonly) BOOL isCapturing;//正在录制
@property (atomic, assign, readonly) BOOL isPaused;//是否暂停
@property (nonatomic, strong ,readonly) NSString *videoPath;//视频路径

@property (nonatomic, weak) id <ALiVideoRecordDelegate> delegate;

//捕获到的视频呈现的layer
- (AVCaptureVideoPreviewLayer *)previewLayer;
//启动录制功能
- (void)openPreview;
//关闭录制功能
- (void)closePreview;
//开始录制
- (void)startRecording;
//暂停录制
- (void)pauseRecording;
//停止录制
- (void)stopRecordingCompletion:(void (^)(UIImage *movieImage))handler;
//继续录制
- (void)resumeRecording;
//开启闪光灯
- (void)openFlashLight;
//关闭闪光灯
- (void)closeFlashLight;
//设置聚焦点  手动聚焦
- (void)setFocusCursorWithPoint:(CGPoint)tapPoint;
//切换前后置摄像头
- (void)changeCameraInputDeviceisFront:(BOOL)isFront;
//将mov的视频转成mp4
- (void)changeMovToMp4:(NSURL *)mediaURL dataBlock:(void (^)(UIImage *movieImage))handler;

- (CGFloat)getVideoLength:(NSURL *)URL;
- (CGFloat)getFileSize:(NSString *)path;

- (void)unloadInputOrOutputDevice;
- (void)cleanCache;
@end
