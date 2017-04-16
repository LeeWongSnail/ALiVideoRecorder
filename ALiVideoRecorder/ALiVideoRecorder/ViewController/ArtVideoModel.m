//
//  ArtVideoModel.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2017/4/16.
//  Copyright © 2017年 LeeWong. All rights reserved.
//

#import "ArtVideoModel.h"

@implementation ArtVideoModel
+ (instancetype)modelWithPath:(NSString *)videoPath thumPath:(NSString *)thumPath recordTime:(NSDate *)recordTime {
    ArtVideoModel *model = [[ArtVideoModel alloc] init];
    model.videoAbsolutePath = videoPath;
    model.thumAbsolutePath = thumPath;
    model.recordTime = recordTime;
    return model;
}
@end
