//
//  ALiAssetReader.h
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/19.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@class ALiAssetReader;

@protocol ALiAssetReaderDelegate <NSObject>

- (void)ali_mMoveDecoder:(ALiAssetReader *)reader buffer:(NSArray *)images;

- (void)mMovieDecoderOnDecodeFinished:(ALiAssetReader *)reader;

- (void)mMovieDecoder:(ALiAssetReader *)reader onNewVideoFrameReady:(CMSampleBufferRef)videoBuffer;
@end


@interface ALiAssetReader : NSObject

@property (nonatomic, strong) NSString *videoPath;

@property (nonatomic, weak) id <ALiAssetReaderDelegate> delegate;

- (void)startDecoderVideo;

- (void)test;

+ (CGImageRef)imageFromSampleBufferRef:(CMSampleBufferRef)sampleBufferRef;

@end
