//
//  XZNetWorkingManager.h
//  daodaokefu
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "XZUserinfoModel.h"
@interface XZNetWorkingManager : AFHTTPSessionManager

/**
 初始化单例
 
 @return 返回自身
 */
+ (instancetype)sharderinstance;

/**
 退出登录API
 */
- (void)logout;

/**
 账号密码登录API

 @param account      账号
 @param Passworrd    密码
 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)firstLogin:(NSString *)account andPassworrd:(NSString *)Passworrd andSucceed:(void(^)(XZUserinfoModel *model))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 获取历史会话客户列表


 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)GethistorySucceed:(void(^)(NSMutableArray *DataArray))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 获取当前会话列表

 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)getMessageDataSucceed:(void(^)(NSMutableArray *DataArray))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 token二次登录

 @param token        登录唯一凭证token
 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)loginbytoken:(NSString *)token andSucceed:(void(^)(XZUserinfoModel *model))succeedBlock andError:(void(^)(NSString *err))errorBlock;
@end
