//
//  XZMessageCell.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/20.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import "XZBaseTableViewCell.h"

@interface XZMessageCell : XZBaseTableViewCell

@property (nonatomic, strong) XZGroup * group;

@property (nonatomic, weak) UIButton *unreadLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
