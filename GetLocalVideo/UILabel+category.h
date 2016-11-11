//
//  UILabel+category.h
//  GetLocalVideo
//
//  Created by Charles.Yao on 2016/11/11.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (category)

+ (instancetype)labelWithColor:(UIColor *)color text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment front:(UIFont *)font alpha:(CGFloat)alpha;

@end
