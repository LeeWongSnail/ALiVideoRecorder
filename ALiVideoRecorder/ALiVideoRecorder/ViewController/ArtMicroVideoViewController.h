//
//  ArtMicroVideoViewController.h
//  ArtStudio
//
//  Created by lbq on 2017/2/7.
//  Copyright © 2017年 kimziv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtMicroVideoViewController : UIViewController

@property (nonatomic, assign) BOOL savePhotoAlbum;

@property (nonatomic, copy) void(^recordComplete)(NSString * aVideoUrl,NSString *aThumUrl);

@end
