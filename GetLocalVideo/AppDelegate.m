//
//  AppDelegate.m
//  GetLocalVideo
//
//  Created by Charles.Yao on 16/9/5.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//
#import "FirstViewController.h"
#import <Photos/Photos.h>
#import "AlbumManager.h"
#import "FileWatcher.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FileWatcher shared] startManager];
    [self getAlbumRightAndSource]; //获取相册权限和数据

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    FirstViewController *rvc = [[FirstViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:rvc];
    self.window.rootViewController = nvc;
    
    return YES;
}

- (void)getAlbumRightAndSource{
    
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusNotDetermined || author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {
        NSLog(@" 用户尚未做出选择这个应用程序的问候||此应用程序没有被授权访问的照片数据 || 用户已经明确否认了这一照片数据的应用程序访问");
    }else{
        
        [[AlbumManager shared] startManager];
        return;
    }
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [[AlbumManager shared] startManager];
                NSLog(@"相册授权开启，启动AlbumManager");
            }
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[FileWatcher shared] stopManager];
    [[AlbumManager shared] stopManager];
}

@end
