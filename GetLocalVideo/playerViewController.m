//
//  playerViewController.m
//  GetLocalVideo
//
//  Created by Charles.Yao on 16/9/5.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//

#import "playerViewController.h"

@interface playerViewController ()
@property (nonatomic,strong)AVPlayer *player;
@end

@implementation playerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    self.player = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //设置模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.contentsScale = [UIScreen mainScreen].scale;
    playerLayer.frame = CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.width *9/16);
    [self.view.layer addSublayer:playerLayer];
    [self.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
