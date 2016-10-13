//
//  AliPlayerControlView.h
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/13.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EALiPlayerActionType){
    EALiPlayerActionTypeBack,
    EALiPlayerActionTypePlay,
};

@protocol ALiPlayerControlDelegate <NSObject>

- (void)playerControlActionHandler:(EALiPlayerActionType)aType;

@end

@interface AliPlayerControlView : UIView

@property (nonatomic, weak) id <ALiPlayerControlDelegate> delegate;

@end
