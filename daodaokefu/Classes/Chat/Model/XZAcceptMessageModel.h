//
//  XZAcceptMessageModel.h
//  daodaokefu
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZVoiceMessageModel.h"
@interface XZAcceptMessageModel : NSObject

// 可能是消息标识之类的
@property (assign, nonatomic)NSInteger id;

// 应该是用户标识
@property (copy, nonatomic)NSString  *userId;

@property (copy, nonatomic)NSString  *adminId;

// 标识是文字还是图片 0-文字消息/1-图片消息
@property (assign, nonatomic)NSInteger  chatType;

@property (copy, nonatomic)NSString   *logTime;

@property (assign, nonatomic)Boolean  isReply;

@property (assign, nonatomic)BOOL     isProcessed;

// 会话ID
@property (assign, nonatomic)NSInteger sessionId;

@property (copy, nonatomic)NSString    *fromSite;

// 具体的消息内容
@property (copy, nonatomic)NSString    *content;

@end
