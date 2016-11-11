//
//  TableViewCell.h
//  GetLocalVideo
//
//  Created by Charles.Yao on 2016/11/11.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;
@interface TableViewCell : UITableViewCell

@property(nonatomic, strong) VideoModel *model;

@end
