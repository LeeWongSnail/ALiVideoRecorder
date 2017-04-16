//
//  ArtPlayerView.h
//  ArtStudio
//
//  Created by lbq on 2017/2/8.
//  Copyright © 2017年 kimziv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtPlayerView : UIView

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl;

@property (nonatomic, strong, readonly) NSURL *videoUrl;

@property (nonatomic,assign) BOOL autoReplay; // 默认 YES

- (void)play;

- (void)stop;

@end
