//
//  ArtVideoUtil.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2017/4/16.
//  Copyright © 2017年 LeeWong. All rights reserved.
//

#import "ArtVideoUtil.h"
#import "ArtVideoModel.h"
#import "NSString+ALi.h"

#define kVideoDicName      @"alivideorecorder_video"


@implementation ArtVideoUtil
+ (BOOL)existVideo {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *nameList = [fileManager subpathsAtPath:[self getVideoPath]];
    return nameList.count > 0;
}


+ (NSMutableArray *)getVideoList {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *modelList = [NSMutableArray array];
    NSArray *nameList = [fileManager subpathsAtPath:[self getVideoPath]];
    for (NSString *name in nameList) {
        if ([name hasSuffix:@".JPG"]) {
            ArtVideoModel *model = [[ArtVideoModel alloc] init];
            NSString *thumAbsolutePath = [[self getVideoPath] stringByAppendingPathComponent:name];
            model.thumAbsolutePath = thumAbsolutePath;
            
            NSString *totalVideoPath = [thumAbsolutePath stringByReplacingOccurrencesOfString:@"JPG" withString:@"mp4"];
            if ([fileManager fileExistsAtPath:totalVideoPath]) {
                model.videoAbsolutePath = totalVideoPath;
            }
            NSString *timeString = [name substringToIndex:(name.length-4)];
            NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
            dateformate.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
            NSDate *date = [dateformate dateFromString:timeString];
            model.recordTime = date;
            
            [modelList addObject:model];
        }
    }
    return modelList;
}

+ (void)saveThumImageWithVideoURL:(NSURL *)videoUrl second:(int64_t)second errorBlock:(void(^)(NSError *error))errorBlock{
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:videoUrl];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    CMTime time = CMTimeMake(second, 10);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef cgimage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    NSLog(@"actualTime ==== %lld",actualTime.value / actualTime.timescale);
    if (error) {
        NSLog(@"缩略图获取失败!:%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorBlock) {
                errorBlock(error);
            }
        });
        return;
    }
    //    UIImage *image = [UIImage imageWithCGImage:cgimage scale:0.6 orientation:UIImageOrientationRight];
    UIImage *image = [UIImage imageWithCGImage:cgimage];
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    NSString *videoPath = [videoUrl.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString: @""];
    NSString *thumPath = [videoPath stringByReplacingOccurrencesOfString:@"mp4" withString: @"JPG"];
    BOOL isok = [imgData writeToFile:thumPath atomically: YES];
    NSLog(@"缩略图获取结果:%d",isok);
    CGImageRelease(cgimage);
}

+ (ArtVideoModel *)createNewVideo {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    formate.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
    NSString *videoName = [[formate stringFromDate:currentDate] MD5String];
    NSString *videoPath = [self getVideoPath];
    
    ArtVideoModel *model = [[ArtVideoModel alloc] init];
    model.videoRelativePath = [NSString stringWithFormat:@"%@.mp4",videoName];
    model.thumRelativePath = [NSString stringWithFormat:@"%@.JPG",videoName];
    
    model.videoAbsolutePath = [videoPath stringByAppendingPathComponent:model.videoRelativePath];
    model.thumAbsolutePath = [videoPath stringByAppendingPathComponent:model.thumRelativePath];
    
    model.recordTime = currentDate;
    return model;
}

+ (void)deleteVideo:(NSString *)videoPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtPath:videoPath error:&error];
    if (error) {
        NSLog(@"删除视频失败:%@",error);
    }
    NSString *thumPath = [videoPath stringByReplacingOccurrencesOfString:@"mp4" withString:@"JPG"];
    NSError *error2 = nil;
    [fileManager removeItemAtPath:thumPath error:&error2];
    if (error2) {
        NSLog(@"删除缩略图失败:%@",error);
    }
}

+ (NSString *)getVideoPath {
    return [self getCacheSubPath:kVideoDicName];
}

//获取路径后缀
+ (NSString *)getRelativePath:(NSString *)absolutePath
{
    if (absolutePath.length <= 0) {
        return nil;
    }
    NSURL *url = [NSURL fileURLWithPath:absolutePath];
    return url.lastPathComponent;
}

//重拼绝得路径
+ (NSString *)getAbsolutePath:(NSString *)absolutedPath
{
    NSString *lastPathComponent = [ArtVideoUtil getRelativePath:absolutedPath];
    //[ArtVideoUtil getVideoPath] 这部分会因为重装应用而改变
    NSString *absolute = [[ArtVideoUtil getVideoPath] stringByAppendingPathComponent:lastPathComponent];
    return absolute;
}

+ (NSString *)createAbsolutThumPath:(NSString *)snapshotId
{
    //    model.videoRelativePath = [NSString stringWithFormat:@"%@.mp4",videoName];
    if(snapshotId.length <= 0) { return nil; };
    NSString *thumRelativePath = [NSString stringWithFormat:@"%@.JPG",[snapshotId MD5String]];
    NSString *absolute = [[ArtVideoUtil getVideoPath] stringByAppendingPathComponent:thumRelativePath];
    return absolute;
}

+ (NSString *)createAbsolutVideoPath:(NSString *)videoId
{
    if(videoId.length <= 0) { return nil; };
    NSString *videoRelativePath = [NSString stringWithFormat:@"%@.mp4",[videoId MD5String]];
    NSString *absolute = [[ArtVideoUtil getVideoPath] stringByAppendingPathComponent:videoRelativePath];
    return absolute;
}

+ (NSString *)getCacheSubPath:(NSString *)dirName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:dirName];
}

+ (void)initialize {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = [self getVideoPath];
    
    NSError *error = nil;
    [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"创建文件夹失败:%@",error);
    }
}

@end
