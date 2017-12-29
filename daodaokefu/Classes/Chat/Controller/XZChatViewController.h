//
//  XZChatViewController.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/20.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZViewController.h"
@interface XZChatViewController :XZViewController

@property (nonatomic, strong) XZGroup *group;

@property (nonatomic, assign) BOOL isHistory;

@property (nonatomic, assign) BOOL isCreate;
@end
