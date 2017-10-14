//
//  ArtAnimationRecordView.h
//  ArtStudio
//
//  Created by lbq on 2017/2/8.
//  Copyright © 2017年 kimziv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtAnimationRecordView : UIView

@property (nonatomic, copy) void(^startRecord)();
@property (nonatomic, copy) void(^completeRecord)(CFTimeInterval recordTime); //录制时长

@end
