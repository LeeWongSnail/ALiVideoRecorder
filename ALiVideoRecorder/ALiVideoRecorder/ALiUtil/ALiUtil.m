//
//  ALiUtil.m
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/12/5.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiUtil.h"

@implementation ALiUtil
#pragma mark -播放系统提示音
+ (void)playSystemTipAudioIsBegin:(BOOL)isBegin
{
    //播放系统提示音
    
    SystemSoundID soundIDTest = isBegin ? 1117 : 1118;
    AudioServicesPlaySystemSound(soundIDTest);
}
@end
