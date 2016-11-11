//
//  TableViewCell.m
//  GetLocalVideo
//
//  Created by Charles.Yao on 2016/11/11.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//
#import "NSString+category.h"
#import "UILabel+category.h"
#import "UIColor+category.h"
#import "TableViewCell.h"
#import "VideoModel.h"
#import "Header.h"

@interface TableViewCell ()

@property (nonatomic, strong) UIImageView *posterImageView; //缩略图

@property (nonatomic, strong) UILabel *titleLabel; //标题

@property (nonatomic, strong) UILabel *videoSize; //视频大小

@end

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self layoutSetting];
    }
    return self;
}

- (void)layoutSetting {
    
    self.posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 160, 90)];
    [self.contentView addSubview:self.posterImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(162, 5, 200, 30)];
    [self.contentView addSubview:self.titleLabel];
    
    self.videoSize = [[UILabel alloc] initWithFrame:CGRectMake(162, 40, 200, 30)];
    [self.contentView addSubview:self.videoSize];
    
}

- (void)setModel:(VideoModel *)model {
    if (_model != model) {
        _model = model;
        self.titleLabel.text = model.videoName;
        self.videoSize.text = [NSString byteUnitConvert:model.videoSize];
        self.posterImageView.image = [UIImage imageWithContentsOfFile:model.videoImgPath];
    }
}

@end
