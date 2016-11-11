//
//  UIView+PVRExtention.h
//
//
//  Created by Charles.Yao 16/6/16.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PVRExtention)
@property (nonatomic, assign) CGSize pvr_size;
@property (nonatomic, assign) CGFloat pvr_width;
@property (nonatomic, assign) CGFloat pvr_height;
@property (nonatomic, assign) CGFloat pvr_x;
@property (nonatomic, assign) CGFloat pvr_y;
@property (nonatomic, assign) CGFloat pvr_centerX;
@property (nonatomic, assign) CGFloat pvr_centerY;

@property (nonatomic, assign) CGFloat pvr_right;
@property (nonatomic, assign) CGFloat pvr_bottom;

@end
