//
//  XZUserinfoModel.h
//  daodaokefu
//
//  Created by apple on 2017/12/15.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZUserinfoModel : NSObject
@property(nonatomic,copy)NSString *receptionId;


/**
 用户的姓名
 */
@property (nonatomic, copy) NSString *name;


@property (nonatomic, copy) NSString *chatCount;

/**
 账号创建时间
 */
@property (nonatomic, strong) NSDateInterval      *createTime;

/**
 状态
 */
@property (nonatomic, assign) NSInteger  status;

@property (nonatomic, copy)   NSString *fromSite;

@property (nonatomic, assign) NSInteger staffId;

/**
 0男1女
 */
@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) BOOL iosLogined;

@property (nonatomic, copy)   NSString *token;

@property (nonatomic, strong) NSDate *tokenCreateTime;

@property (nonatomic, strong) NSDate *lastActiveTime;

@property (nonatomic, assign) NSInteger companyId;

@property (nonatomic, assign) BOOL isOnline;

@end
