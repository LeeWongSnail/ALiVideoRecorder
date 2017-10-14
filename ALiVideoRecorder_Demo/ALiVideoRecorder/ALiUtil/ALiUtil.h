//
//  ALiUtil.h
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/12/5.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALiUtil : NSObject
+ (void)playSystemTipAudioIsBegin:(BOOL)isBegin;
+ (long long)diskFreeSpace;
@end
