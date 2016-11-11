//
//  AlbumVideoViewController.m
//  GetLocalVideo
//
//  Created by Charles.Yao on 2016/11/11.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//

#import "AlbumVideoViewController.h"
#import "playerViewController.h"
#import "TableViewCell.h"
#import "AlbumManager.h"
#import "VideoModel.h"
#import "Header.h"

#define CELL_ALBUM_ID @"CELL_ALBUM_ID"

@interface AlbumVideoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *deleteArr;

@end

@implementation AlbumVideoViewController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)deleteArr {
    
    if (!_deleteArr) {
        _deleteArr = [[NSMutableArray alloc] init];
    }
    return _deleteArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavigationBar];
    [self layoutSetting];
    [self getAlbumVideoSource];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:RefreshAlbumUINotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSuccessRefreshUI) name:DeleteAlbumVideoSourceNotification object:nil];

}

- (void)setRightNavigationBar {
    
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(clickLeftBarDelete)];
    
    self.navigationItem.rightBarButtonItem = right1;
}



- (void)clickLeftBarDelete {
    
    if ([AlbumManager shared].dataSource.count > 0) {
        [[AlbumManager shared] deleteAlbumVideo:self.deleteArr];
    }
}

- (void)deleteSuccessRefreshUI{

    [[AlbumManager shared].dataSource removeAllObjects];
    [self getAlbumVideoSource];
}

- (void)layoutSetting {
    
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"本地视频";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:CELL_ALBUM_ID];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.center = self.view.center;
    self.label.textColor = [UIColor blackColor];
    [self.view addSubview:self.label];
    
}

- (void)getAlbumVideoSource {  //根据数据有无，判断控件的显示
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataSource removeAllObjects];
        [self.deleteArr removeAllObjects];
        [self.dataSource addObjectsFromArray:[AlbumManager shared].dataSource];
        
        for (VideoModel *model in self.dataSource) {
            [self.deleteArr addObject:model.videoAsset];
        }
        
        if ([[AlbumManager shared] getAlbumRight]) {
            if (self.dataSource.count > 0) {
                self.label.hidden = YES;
                self.tableView.hidden = NO;
                
            } else {
                self.tableView.hidden = YES;
                self.label.hidden = NO;
                self.label.text = @"相册没有视频";
            }
        } else {
            self.tableView.hidden = YES;
            self.label.hidden = NO;
            self.label.text = @"没有权限";
        }
        [self.tableView reloadData];
    });
}

- (void)refreshUI {
    [self getAlbumVideoSource];
}

#pragma mark 设置cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ALBUM_ID];
    VideoModel *videoModel = self.dataSource[indexPath.row];
    cell.model = videoModel;
    return cell;
}

#pragma mark 点击播放
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *asset = self.deleteArr[indexPath.row];
    
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            playerViewController *MD = [[playerViewController alloc]init];
            MD.playerItem = playerItem;
            [self.navigationController pushViewController:MD animated:YES];
            
        });
        
    }];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
