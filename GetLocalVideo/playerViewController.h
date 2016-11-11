//
//  playerViewController.h
//  GetLocalVideo
//
//  Created by Charles.Yao on 16/9/5.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface playerViewController : UIViewController
@property (nonatomic , strong) AVPlayerItem* playerItem;
@end
