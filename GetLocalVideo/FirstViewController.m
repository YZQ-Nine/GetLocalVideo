//
//  FirstViewController.m
//  GetLocalVideo
//
//  Created by Charles.Yao on 16/9/5.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//
#import "AlbumVideoViewController.h"
#import "iTunesViewController.h"
#import "FirstViewController.h"
#import <Photos/Photos.h>
#import "Header.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor cyanColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 150, 30);
    button.center = self.view.center;
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"点击获取相册视频" forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    [button addTarget:self action:@selector(clickAlbum) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    button3.frame = CGRectMake(0, 0, 150, 30);
    button3.pvr_centerY = self.view.pvr_centerY + 100;
    button3.pvr_centerX = self.view.pvr_centerX;
    
    button3.backgroundColor = [UIColor yellowColor];
    [button3 setTitle:@"获取iTunes视频" forState:UIControlStateNormal];
    
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(clickiTunes) forControlEvents:UIControlEventTouchUpInside];

}

- (void)clickAlbum {

    AlbumVideoViewController *SATVC = [[AlbumVideoViewController alloc] init];
    [self.navigationController pushViewController:SATVC animated:YES];
}


- (void)clickiTunes {

    iTunesViewController *PVRBVC = [[iTunesViewController alloc] init];
    [self.navigationController pushViewController:PVRBVC animated:YES];
}




@end
