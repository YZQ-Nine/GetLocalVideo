//
//  UIView+PVRExtention.m
//
//
//  Created by Charles.Yao on 16/6/16.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//

#import "UIView+PVRExtention.h"

@implementation UIView (PVRExtention)
- (CGSize)pvr_size
{
    return self.frame.size;
}

- (void)setPvr_size:(CGSize)pvr_size
{
    CGRect frame = self.frame;
    frame.size = pvr_size;
    self.frame = frame;
}


- (CGFloat)pvr_width
{
    return self.frame.size.width;
}

- (CGFloat)pvr_height
{
    return self.frame.size.height;
}

- (void)setPvr_width:(CGFloat)pvr_width
{
    CGRect frame = self.frame;
    frame.size.width = pvr_width;
    self.frame = frame;
}

- (void)setPvr_height:(CGFloat)pvr_height
{
    CGRect frame = self.frame;
    frame.size.height = pvr_height;
    self.frame = frame;
}

- (CGFloat)pvr_x
{
    return self.frame.origin.x;
}

- (void)setPvr_x:(CGFloat)pvr_x
{
    CGRect frame = self.frame;
    frame.origin.x = pvr_x;
    self.frame = frame;
}

- (CGFloat)pvr_y
{
    return self.frame.origin.y;
}

- (void)setPvr_y:(CGFloat)pvr_y
{
    CGRect frame = self.frame;
    frame.origin.y = pvr_y;
    self.frame = frame;
}

- (CGFloat)pvr_centerX
{
    return self.center.x;
}

- (void)setPvr_centerX:(CGFloat)pvr_centerX
{
    CGPoint center = self.center;
    center.x = pvr_centerX;
    self.center = center;
}

- (CGFloat)pvr_centerY
{
    return self.center.y;
}

- (void)setPvr_centerY:(CGFloat)pvr_centerY
{
    CGPoint center = self.center;
    center.y = pvr_centerY;
    self.center = center;
}

- (CGFloat)pvr_right
{
    //    return self.pvr_x + self.pvr_width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)pvr_bottom
{
    //    return self.pvr_y + self.pvr_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setPvr_right:(CGFloat)pvr_right
{
    self.pvr_x = pvr_right - self.pvr_width;
}

- (void)setPvr_bottom:(CGFloat)pvr_bottom
{
    self.pvr_y = pvr_bottom - self.pvr_height;
}

@end
