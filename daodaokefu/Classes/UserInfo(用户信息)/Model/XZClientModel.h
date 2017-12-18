//
//  XZClientModel.h
//  daodaokefu
//
//  Created by apple on 2017/12/18.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZClientModel : NSObject

@property (assign, nonatomic) NSInteger id;

@property (copy, nonatomic) NSString *openId;

// 头像地址
@property (copy, nonatomic) NSString *avatar;

// 客户名字
@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) NSInteger gender;

// 是否是会员
@property (assign, nonatomic) BOOL isVip;

@property (copy, nonatomic) NSString *fromSite;

@property (assign, nonatomic) NSInteger origin;

// 最后消息时间
@property (copy, nonatomic) NSString *lastChatTime;

@property (assign, nonatomic) BOOL isActive;
@end
