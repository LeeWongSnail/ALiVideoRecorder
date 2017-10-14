//
//  ALiBottomToolView.h
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/13.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EALiTipActionType){
    EALiTipActionTypeRecord,
    EALiTipActionTypePlay,
    EALiTipActionTypeSwitch,
};

@protocol ALiBottomToolViewDelegate <NSObject>

- (void)bottomTipViewActionHandler:(EALiTipActionType)aType;

@end

@interface ALiBottomToolView : UIView

@property (nonatomic, weak) id <ALiBottomToolViewDelegate> delegate;

@property (nonatomic, strong) NSString *lastVideoPath;

- (void)configVideoThumb:(UIImage *)thumbImage;

- (void)configViewWithAngle:(CGFloat)angle;

@end
