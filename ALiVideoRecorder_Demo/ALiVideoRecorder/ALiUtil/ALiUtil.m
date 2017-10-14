//
//  ALiUtil.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/12/5.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiUtil.h"
#include <sys/param.h>
#include <sys/mount.h>

@implementation ALiUtil
#pragma mark -播放系统提示音
+ (void)playSystemTipAudioIsBegin:(BOOL)isBegin
{
    //播放系统提示音
    
    SystemSoundID soundIDTest = isBegin ? 1117 : 1118;
    AudioServicesPlaySystemSound(soundIDTest);
}

long long freeSpace() {
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    
    return freespace;
}

+ (long long)diskFreeSpace
{
    return freeSpace();
}

+(float)getTotalDiskSpaceInBytes {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    struct statfs tStats;
    statfs([[paths lastObject] cString], &tStats);
    float totalSpace = (float)(tStats.f_blocks * tStats.f_bsize);
    
    return totalSpace;
}
@end
