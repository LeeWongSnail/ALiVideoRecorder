//
//  ArtVideoModel.h
//  ALiVideoRecorder
//
//  Created by LeeWong on 2017/4/16.
//  Copyright © 2017年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtVideoModel : NSObject
/// 完整视频 本地路径
@property (nonatomic, copy) NSString *videoAbsolutePath;
/// 缩略图 路径
@property (nonatomic, copy) NSString *thumAbsolutePath;
/// 完整视频 相对路径
@property (nonatomic, copy) NSString *videoRelativePath;
/// 缩略图 相对路径
@property (nonatomic, copy) NSString *thumRelativePath;
// 录制时间
@property (nonatomic, strong) NSDate *recordTime;


+ (instancetype)modelWithPath:(NSString *)videoPath thumPath:(NSString *)thumPath recordTime:(NSDate *)recordTime;

@end
