//
//  AlbumManager.m
//  GetLocalVideo
//
//  Created by Charles.Yao on 2016/11/11.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//
#import "AlbumManager.h"
#import "VideoModel.h"

dispatch_queue_t album_queue() {
    static dispatch_queue_t as_album_queue;
    static dispatch_once_t onceToken_album_queue;
    dispatch_once(&onceToken_album_queue, ^{
        as_album_queue = dispatch_queue_create("getAlbumVideo.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return as_album_queue;
}

@interface AlbumManager () <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHFetchResult *assetsFetchResults;

@end

@implementation AlbumManager

singleton_implementation(AlbumManager)

- (void)startManager { //注册相册的监听
    
    dispatch_async(album_queue(), ^{
        self.dataSource = [[NSMutableArray alloc] init];
        self.assetsFetchResults = [[PHFetchResult alloc] init];
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        [self getAlbumVideo];
    });
}

- (void)stopManager { //注销相册的监听
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    });
}

#pragma mark - 实现相册监听方法
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 监听相册视频发生变化
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
        if (collectionChanges) {
            if ([collectionChanges hasIncrementalChanges]) {
                //监听相册视频的增删
                if (collectionChanges.insertedIndexes.count || collectionChanges.removedIndexes.count) {
                    [self getAlbumVideo];
                }
            }
        }
    });
}

#pragma mark - 相机授权
- (BOOL)getCameraRight {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 相册授权
- (BOOL)getAlbumRight{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {
        return NO;
    }else{
        return YES;
    }
}

//筛选的规则和范围
- (PHFetchOptions *)getFetchPhotosOptions{
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc]init];
    //排序的方式为：按时间排序
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    return allPhotosOptions;
}

- (void)getAlbumVideo{
    
    self.assetsFetchResults = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:[self getFetchPhotosOptions]];
    
    if (!self.assetsFetchResults.count) {
        [self.dataSource removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAlbumUINotification object:nil];
        return;
    }
    
    __block NSMutableArray *assetArr = [[NSMutableArray alloc] init];
    __block NSMutableArray *videoModeArr = [[NSMutableArray alloc] init];
    
    for (PHAsset *videoAsset in self.assetsFetchResults) {
        [assetArr addObject:videoAsset];
        [[PHImageManager defaultManager] requestPlayerItemForVideo:videoAsset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
            
            NSString *filePath = [info valueForKey:@"PHImageFileSandboxExtensionTokenKey"];
            if (filePath && filePath.length > 0) {
                NSArray *lyricArr = [filePath componentsSeparatedByString:@";"];
                NSString *privatePath = [lyricArr lastObject];
                if (privatePath.length > 8) {
                    NSString *videoPath = [privatePath substringFromIndex:8];
                    if (videoPath && videoPath.length > 0) {
                        NSArray *fieldArr = [videoPath componentsSeparatedByString:@"/"];
                        if (fieldArr && fieldArr.count > 0) {
                            VideoModel *model = [[VideoModel alloc] init];
                            model.videoPath = videoPath;
                            model.videoName = [fieldArr lastObject];
                            model.videoSize = [SandBoxHelper fileSizeForPath:videoPath];
                            model.videoImgPath = [self saveImg:[UIImage getThumbnailImage:videoPath] withVideoMid:model.videoName];
                            model.videoAsset = videoAsset;
                            [videoModeArr addObject:model];
                           
                            if (assetArr.count == videoModeArr.count) {
                                [self.dataSource removeAllObjects];
                                [self.dataSource addObjectsFromArray:videoModeArr];
                                [self cleanImgWithUseless];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAlbumUINotification object:nil];
                                });
                                NSLog(@"相册数据已全部请求完毕总共 %lu个文件",(unsigned long)self.dataSource.count);
                            }
                        }
                    }
                }
            }
        }];
    }
}

#pragma mark 遍历图片存储文件夹如果相册资源已删除，也要把图片删掉
- (void)cleanImgWithUseless {
    
    dispatch_async(album_queue(), ^{
        NSMutableArray *imgMarr = [[NSMutableArray alloc] init];
        for (VideoModel *model in self.dataSource) {
            NSString *videoImgName = [NSString stringWithFormat:@"%@.png",model.videoName];
            [imgMarr addObject:videoImgName];
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *fileList = [[NSArray alloc] init];
        //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
        fileList = [fileManager contentsOfDirectoryAtPath:[SandBoxHelper AlbumVideoImagePath] error:&error];
        NSLog(@"路径==%@,fileList%@",[SandBoxHelper AlbumVideoImagePath],fileList);
        if (fileList.count > 0) {
            for (NSString *file in fileList) {
                if (![imgMarr containsObject:file]) {
                    NSString *imgPath = [NSString stringWithFormat:@"%@/%@",[SandBoxHelper AlbumVideoImagePath],file];
                    [fileManager removeItemAtPath:imgPath error:nil];
                    NSLog(@"经过过滤未发现%@文件，所以删除改视频缩略图, 图片地址 = %@",file,imgPath);
                }
            }
        }
    });
}

- (NSString *)saveImg:(UIImage *)image withVideoMid:(NSString *)videoMid{
    
    //png格式
    NSData *imagedata=UIImagePNGRepresentation(image);
    
    //JEPG格式
    //NSData *imagedata=UIImageJEPGRepresentation(m_imgFore,1.0);
    
    NSString *savedImagePath = [[SandBoxHelper AlbumVideoImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", videoMid]];
    
    [imagedata writeToFile:savedImagePath atomically:YES];
    
    return savedImagePath;
}

//删除相册视频
#pragma mark 删除相册视频

- (void)deleteAlbumVideo:(NSMutableArray<PHAsset *> *)assetArr {
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        [PHAssetChangeRequest deleteAssets:assetArr];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DeleteAlbumVideoSourceNotification object:nil];
            NSLog(@"相册视频删除完毕");
        }
    }];
}
@end
