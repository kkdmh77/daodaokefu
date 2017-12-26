//
//  XZTransferSessionTableViewCell.h
//  daodaokefu
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZTransferSessionModel.h"
@interface XZTransferSessionTableViewCell : UITableViewCell

@property (nonatomic ,strong) XZTransferSessionModel *model;

@property (nonatomic, assign) BOOL isShow;

@end
