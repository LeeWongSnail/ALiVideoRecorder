//
//  ALiTopToolView.h
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/13.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EALiTopTipActionType){
    EALiTipActionTypeClose,
    EALiTipActionTypeFlash,
    EALiTipActionTypeSwitchCamera,
};

@protocol ALiTopToolViewDelegate <NSObject>

- (void)tipViewActionHandler:(EALiTopTipActionType)aType;

@end


@interface ALiTopToolView : UIView

@property (nonatomic, weak) id <ALiTopToolViewDelegate> delegate;

- (void)configTimeLabel:(CGFloat)seconds;

- (void)configViewWithOrientation:(CGFloat)angle;
@end
