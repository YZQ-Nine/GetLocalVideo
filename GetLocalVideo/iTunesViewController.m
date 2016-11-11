//
//  iTunesViewController.m
//  GetLocalVideo
//
//  Created by Charles.Yao on 16/9/18.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//

#import "iTunesViewController.h"
#import "playerViewController.h"
#import "TableViewCell.h"
#import "VideoModel.h"
#import "FileWatcher.h"
#import "Header.h"

#define CELL_ID @"CELL_ID"

@interface iTunesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation iTunesViewController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setRightNavigationBar];
    
    [self layoutSetting];
    
    [self getiTunesVideo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:RefreshiTunesUINotification object:nil];
}

- (void)setRightNavigationBar {
    
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(clickLeftBarDelete)];
    
    self.navigationItem.rightBarButtonItem = right1;
}



- (void)clickLeftBarDelete {

    [[FileWatcher shared] deleteiTunesVideo:self.dataSource];
    [[FileWatcher shared].dataSource removeAllObjects];
    [self getiTunesVideo];
}

- (void)layoutSetting {
    
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"本地视频";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:CELL_ID];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    self.label.numberOfLines = 0;
    self.label.text = @"手机没有资源，请通过iTunes导入文件到APP下";
    self.label.center = self.view.center;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    [self.view addSubview:self.label];
        
}

- (void)getiTunesVideo { //根据数据有无，判断控件的显示
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[FileWatcher shared].dataSource];
        if (self.dataSource.count > 0) {
            self.label.hidden = YES;
            self.tableView.hidden = NO;
        } else {
            self.label.hidden = NO;
            self.tableView.hidden = YES;
        }
        [self.tableView reloadData];
    });
}

- (void)refreshUI {
    [self getiTunesVideo];
}

#pragma mark 设置cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    VideoModel *videoModel = self.dataSource[indexPath.row];
    cell.model = videoModel;
    return cell;
}

#pragma mark 点击播放
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoModel *videoModel = self.dataSource[indexPath.row];
    NSURL *videoURL = [NSURL fileURLWithPath:videoModel.videoPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        playerViewController *MD = [[playerViewController alloc]init];
        MD.playerItem = [AVPlayerItem playerItemWithURL:videoURL];
        [self.navigationController pushViewController:MD animated:YES];
    });
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
