//
//  ArtVideoUtil.h
//  ALiVideoRecorder
//
//  Created by LeeWong on 2017/4/16.
//  Copyright © 2017年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ArtVideoModel;

@interface ArtVideoUtil : NSObject
/*!
 *  有视频的存在
 */
+ (BOOL)existVideo;

/*!
 *  保存缩略图
 *
 *  @param videoUrl 视频路径
 *  @param second   第几秒的缩略图
 *  @param errorBlock 发生错误时的的回调
 */
+ (void)saveThumImageWithVideoURL:(NSURL *)videoUrl second:(int64_t)second errorBlock:(void(^)(NSError *error))errorBlock;

/*!
 *  产生新的对象
 */
+ (ArtVideoModel *)createNewVideo;

/*!
 *  删除视频
 */
+ (void)deleteVideo:(NSString *)videoPath;

/*
 * 视频路径 /cache/artstudio_im_video
 */
+ (NSString *)getVideoPath;

+ (NSString *)getRelativePath:(NSString *)absolutePath;

//重拼绝得路径
+ (NSString *)getAbsolutePath:(NSString *)absolutedPath;

//用视频ID 创建视频绝对路径
+ (NSString *)createAbsolutVideoPath:(NSString *)videoId;

//用图片ID 创建图片绝对路径
+ (NSString *)createAbsolutThumPath:(NSString *)snapshotId;



@end
