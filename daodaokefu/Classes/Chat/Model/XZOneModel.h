//
//  XZOneModel.h
//  daodaokefu
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZAcceptMessageModel.h"
#import "YYModel.h"

@interface XZOneModel : NSObject

//用户名字
@property(copy,nonatomic) NSString *name;

@property (nonatomic, strong)NSArray<XZAcceptMessageModel *> *chatLog;

@end
