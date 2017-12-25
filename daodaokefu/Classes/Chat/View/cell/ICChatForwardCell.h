//
//  ICChatForwardCell.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/15.
//  Copyright © 2016年 gxz All rights reserved.
//

#import "ICBaseMessageCell.h"
@class ICGroup;

@interface ICChatForwardCell : ICBaseMessageCell

@property (nonatomic, strong) ICGroup *group;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
