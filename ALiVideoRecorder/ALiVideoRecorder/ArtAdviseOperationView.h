//
//  ArtAdviseOperationView.h
//  ArtBox
//
//  Created by leoliu on 15/12/31.
//  Copyright © 2015年 zhaoguogang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtAdviseOperationView : UIView

- (id)initWithTitle:(NSString *)title image:(NSString *)imageName closeBlock:(void(^)())closeBlock;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end
