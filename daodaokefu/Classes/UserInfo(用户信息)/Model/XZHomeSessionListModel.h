//
//  XZHomeSessionListModel.h
//  daodaokefu
//
//  Created by apple on 2017/12/18.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZHomeSessionListModel : NSObject

@property (assign, nonatomic) NSInteger sessionId;

// 用户名字
@property (copy, nonatomic) NSString *clientName;

// 用户的头像url
@property (copy, nonatomic) NSString *imgUrl;

// 未读消息数
@property (assign, nonatomic) NSInteger unreadCount;

@property (assign, nonatomic) BOOL isCurrent;

@property (assign, nonatomic) NSInteger abnormalCode;

// 最后消息内容
@property (copy, nonatomic) NSString *lastChatLog;

// 最后消息时间
@property (copy,nonatomic) NSString *lastChatLogTime;

@property (assign, nonatomic) NSInteger origin;
/*------------------------*/

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *avatar;
@end
