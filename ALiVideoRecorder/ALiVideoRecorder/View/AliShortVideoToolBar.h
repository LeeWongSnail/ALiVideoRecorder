//
//  AliShortVideoToolBar.h
//  ALiVideoRecorder
//
//  Created by LeeWong on 2016/10/19.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EALiShortToolActionType){
    EALiShortToolActionTypeRecord,
    EALiShortToolActionTypeSend,
};

@protocol ALiShortToolBarDelegate <NSObject>

- (void)shortToolBarActionHandler:(EALiShortToolActionType)aType;

@end


@interface AliShortVideoToolBar : UIView

@property (nonatomic, weak) id <ALiShortToolBarDelegate> delegate;

@end
