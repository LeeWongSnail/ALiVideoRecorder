//
//  ALiAssetReader.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/19.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiAssetReader.h"

@interface ALiAssetReader ()

@property (nonatomic, strong) AVAssetReader *reader;

@property (nonatomic, strong) AVURLAsset *asset;

@property (nonatomic, strong) AVAssetReaderTrackOutput *videoReaderOutput;

@property (nonatomic, strong) AVAssetTrack *videoTrack;

@end

@implementation ALiAssetReader

- (void)test
{
    NSError *error = nil;
    
    AVAssetReader* reader = [[AVAssetReader alloc] initWithAsset:self.asset error:&error];
    NSArray* videoTracks = [self.asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack* videoTrack = [videoTracks objectAtIndex:0];
    // 视频播放时，m_pixelFormatType=kCVPixelFormatType_32BGRA
    // 其他用途，如视频压缩，m_pixelFormatType=kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
    
    int m_pixelFormatType;
    //     视频播放时，
    m_pixelFormatType = kCVPixelFormatType_32BGRA;
    // 其他用途，如视频压缩
    //    m_pixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
    
    NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:
                                                                (int)m_pixelFormatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVAssetReaderTrackOutput* videoReaderOutput = [[AVAssetReaderTrackOutput alloc]
                                                   initWithTrack:videoTrack outputSettings:options];
    [reader addOutput:videoReaderOutput];
    [reader startReading];
    // 要确保nominalFrameRate>0，之前出现过android拍的0帧视频
    
    while ([reader status] == AVAssetReaderStatusReading && videoTrack.nominalFrameRate > 0) {
        // 读取video sample
        CMSampleBufferRef videoBuffer = [videoReaderOutput copyNextSampleBuffer];
        [self.delegate mMovieDecoder:self onNewVideoFrameReady:videoBuffer];
         CFRelease(videoBuffer);
         // 根据需要休眠一段时间；比如上层播放视频时每帧之间是有间隔的
         [NSThread sleepForTimeInterval:0.0001];
    }
         
         // 告诉上层视频解码结束
    [self.delegate mMovieDecoderOnDecodeFinished:self];
}

#pragma mark - Public Method

- (void)startDecoderVideo
{
    [self.reader addOutput:self.videoReaderOutput];
    [self.reader startReading];
    
    NSMutableArray *images = [NSMutableArray array];
    
    // 要确保nominalFrameRate>0，之前出现过android拍的0帧视频
    while ([self.reader status] == AVAssetReaderStatusReading && self.videoTrack.nominalFrameRate > 0) {
        // 读取 video sample
        CMSampleBufferRef videoBuffer = [self.videoReaderOutput copyNextSampleBuffer];
        
        NSArray *image = [self loadVideoImages:videoBuffer];
        [images addObject:image];
        
        NSLog(@"----------读取视频图片-----------");
        
        if (images.count == 0) {
            NSLog(@"视频读取失败");
        }
        
        // 根据需要休眠一段时间；比如上层播放视频时每帧之间是有间隔的,这里的 sampleInternal 我设置为0.001秒
        [NSThread sleepForTimeInterval:0.001];
    }
    
    
    
    if (images.count > 0 && [self.delegate respondsToSelector:@selector(ali_mMoveDecoder:buffer:)]) {
        [self.delegate ali_mMoveDecoder:self buffer:images];
    }
    
}


#pragma mark Private Method

- (NSArray *)loadVideoImages:(CMSampleBufferRef)videoBuffer
{
    NSMutableArray *images = [NSMutableArray array];
    CGImageRef cgimage = [ALiAssetReader imageFromSampleBufferRef:videoBuffer];
    if (!(__bridge id)(cgimage)) { return nil; }
    [images addObject:((__bridge id)(cgimage))];
    CGImageRelease(cgimage);
    
    return [images copy];
}

//创建CGImageRef不会做图片数据的内存拷贝，它只会当 Core Animation执行 Transaction::commit() 触发 layer -display时，才把图片数据拷贝到 layer buffer里。简单点的意思就是说不会消耗太多的内存！
// AVFoundation 捕捉视频帧，很多时候都需要把某一帧转换成 image
+ (CGImageRef)imageFromSampleBufferRef:(CMSampleBufferRef)sampleBufferRef
{
    // 为媒体数据设置一个CMSampleBufferRef
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBufferRef);
    // 锁定 pixel buffer 的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // 得到 pixel buffer 的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // 得到 pixel buffer 的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到 pixel buffer 的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 创建一个依赖于设备的 RGB 颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphic context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    //根据这个位图 context 中的像素创建一个 Quartz image 对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁 pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    // 释放 context 和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // 用 Quzetz image 创建一个 UIImage 对象
    // UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放 Quartz image 对象
    //    CGImageRelease(quartzImage);
    
    return quartzImage;
    
}


#pragma mark - Lazy Load

- (AVAssetReader *)reader
{
    if (_reader == nil) {
        NSError *error = nil;
        _reader = [[AVAssetReader alloc] initWithAsset:self.asset error:&error];
        
    }
    return _reader;
}

- (AVAssetReaderTrackOutput *)videoReaderOutput
{
    if (_videoReaderOutput == nil) {
        int m_pixelFormatType;
        //     视频播放时，
        m_pixelFormatType = kCVPixelFormatType_32BGRA;
        // 其他用途，如视频压缩
        //    m_pixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        [options setObject:@(m_pixelFormatType) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        _videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:self.videoTrack outputSettings:options];
    }
    return _videoReaderOutput;
}

- (AVAssetTrack *)videoTrack
{
    if (_videoTrack == nil) {
        NSArray *videoTracks = [self.asset tracksWithMediaType:AVMediaTypeVideo];
        _videoTrack =[videoTracks objectAtIndex:0];
    }
    return _videoTrack;
}

- (AVURLAsset *)asset
{
    if (_asset == nil) {
        NSURL *fileUrl = [NSURL fileURLWithPath:self.videoPath];
        _asset = [[AVURLAsset alloc] initWithURL:fileUrl options:nil];
    }
    return _asset;
}

@end
