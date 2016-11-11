//
//  IWSandBoxHelper.m
//
//
//  Created by vic on 15/7/11.
//  Copyright (c) 2015年 vic All rights reserved.
//

#import "SandBoxHelper.h"

@implementation SandBoxHelper

+ (NSString *)homePath{
    return NSHomeDirectory();
}

+ (NSString *)appPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preferences"];
}

+ (NSString *)libCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)tmpPath
{return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}

+ (NSString *)iTunesVideoImagePath{

    NSString *path = [[self libCachePath] stringByAppendingFormat:@"/iTunesVideoPhoto"];
    [self hasLive:path];
    return path;
    
}
+ (NSString *)AlbumVideoImagePath{

    NSString *path = [[self libCachePath] stringByAppendingFormat:@"/albumVideoPhoto"];
    [self hasLive:path];
    return path;
}


+ (BOOL)hasLive:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}

+ (BOOL)fileExists:(NSString *)path{
    return  [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+(BOOL)deleteFile:(NSString *)path{
    if ([self fileExists:path]) {
        NSFileManager* fileManager=[NSFileManager defaultManager];
        return  [fileManager removeItemAtPath:path error:nil];
    }
    return YES;
}

+(long long)fileSizeForPath:(NSString *)path
{
    long long fileSize = 0;
    if([self fileExists:path]){
        NSError *error = nil;
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

+ (long long)freeSpace{
    NSString* path = [self docPath];
    NSFileManager* fileManager = [[NSFileManager alloc ] init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    return [freeSpace longLongValue];
}

+ (long long)totalSpace{
    NSString* path = [self docPath];
    NSFileManager* fileManager = [[NSFileManager alloc ] init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    return [totalSpace longLongValue];
}

@end
