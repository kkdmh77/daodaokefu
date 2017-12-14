//
//  XZNetWorkingManager.h
//  daodaokefu
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface XZNetWorkingManager : AFHTTPSessionManager

/**
 初始化单例
 
 @return 返回自身
 */
+ (instancetype)sharderinstance;


/**
 账号密码登录API

 @param account 账号
 @param Passworrd 密码
 @param succeedBlock 成功回调
 @param errorBlock 失败回调
 */
- (void)firstLogin:(NSString *)account andPassworrd:(NSString *)Passworrd andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *))errorBlock;
@end