//
//  VideoModel.h
//  GetLocalVideo
//
//  Created by Charles.Yao on 2016/11/11.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface VideoModel : NSObject

@property (nonatomic, copy) NSString *videoName;

@property (nonatomic, copy) NSString *videoPath;

@property (nonatomic, copy) NSString *videoImgPath;

@property (nonatomic, assign) long long videoSize;

@property (nonatomic, strong) PHAsset *videoAsset;

@end
