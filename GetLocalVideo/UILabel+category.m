//
//  UILabel+category.m
//  GetLocalVideo
//
//  Created by Charles.Yao on 2016/11/11.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//

#import "UILabel+category.h"

@implementation UILabel (category)
+ (instancetype)labelWithColor:(UIColor *)color text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment front:(UIFont *)font alpha:(CGFloat)alpha {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.text = text;
    label.textAlignment = textAlignment;
    label.font = font;
    label.alpha = alpha;
    [label sizeToFit];
    return label;
}
@end
