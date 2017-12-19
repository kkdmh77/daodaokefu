//
//  XZNonceUserInfoModel.h
//  daodaokefu
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZNonceUserInfoModel : NSObject

@property (assign, nonatomic) NSInteger id;

@property (copy, nonatomic)   NSString  *openId;

@property (copy, nonatomic)   NSString  *remark;
// 头像url
@property (copy, nonatomic)   NSString  *avatar;
// 名字
@property (copy, nonatomic)   NSString  *name;
// 性别
@property (assign, nonatomic) NSInteger gender;
// 地区
@property (copy, nonatomic)   NSString  *area;
// 是否是VIP
@property (assign, nonatomic) BOOL      isVip;

@property (copy, nonatomic)   NSString  *fromSite;
// 来源 0-web / 1-WeChat / 2- mobile
@property (assign, nonatomic) NSInteger  origin;

@property (copy, nonatomic)   NSString  *lastChatTime;

@property (assign, nonatomic) BOOL      isActive;
@end
