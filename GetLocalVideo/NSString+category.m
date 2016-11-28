//
//  NSString+categorys.m
//
//
//  Created by fit-find on 15/6/10.
//  Copyright (c) 2015年 fit-find. All rights reserved.
//

#import "NSString+category.h"

@implementation NSString (Verification)

const int GB = 1024 * 1024 * 1024;//定义GB的计算常量
const int MB = 1024 * 1024;//定义MB的计算常量
const int KB = 1024;//定义KB的计算常量

+ (NSString *)byteUnitConvert:(long long)length{
    NSString *unit = @"B";
    CGFloat unitLegth = length;
    
    if (length / GB >= 1){//如果当前Byte的值大于等于1GB
        unit = @"GB";
        unitLegth = 1.0f*length / GB;
    }else if (length / MB >= 1){//如果当前Byte的值大于等于1MB
        if(length / MB >= 1000){
            unit = @"GB";
            unitLegth = 1.0f*length / GB;
        }else{
            unit = @"MB";
            unitLegth = 1.0f*length / MB;
        }
    }else if (length / KB >= 1){//如果当前Byte的值大于等于1KB
        if(length / KB >= 1000){
            unit = @"MB";
            unitLegth = 1.0f*length / MB;
        }else{
            unit = @"KB";
            unitLegth = 1.0f*length / KB;
        }
    }else{
        if(length >= 1000){
            unit = @"KB";
            unitLegth = 1.0f*length / KB;
        }
    }
    return [NSString stringWithFormat:@"%.2f%@",unitLegth,unit];
}

+ (NSString *)uuid{
    // create a new UUID which you own
    CFUUIDRef uuidref = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    CFStringRef uuid = CFUUIDCreateString(kCFAllocatorDefault, uuidref);
    
    NSString *result = (__bridge NSString *)uuid;
    //release the uuidref
    CFRelease(uuidref);
    // release the UUID
    CFRelease(uuid);
    
    return result;
}

@end
