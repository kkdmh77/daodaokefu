//
//  XZNetWorkingManager.h
//  daodaokefu
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "XZUserinfoModel.h"
#import "XZNonceUserInfoModel.h"
#import "XZOneModel.h"
#import "XZTransferSessionModel.h"
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
- (void)GethistorySucceed:(void(^)(NSArray *DataArray))succeedBlock andError:(void(^)(NSString *err))errorBlock;


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


/**
 拉黑当前会话用户

 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)PulltheblackSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 获取当前会话客户资料

 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)getcustomerinfoSucceed:(void(^)(XZNonceUserInfoModel *model))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 修改当前会话客户备注

 @param remark       新备注名字
 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)editremark:(NSString *)remark andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 发送一条文字消息

 @param messageStr   消息内容
 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)sendMessage:(NSString *)messageStr andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 发送一条图片消息

 @param iamgPath     图片路径
 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)SendPictureMessage:(NSString *)iamgPath andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 返回快速回复列表

 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)GetquickreplySucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;

/**
 获取会话类型

 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)GetsessiontypesSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;

/**
 获取在线的客服列表
 
 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)OnlinereceptionSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
  获取当前会话的聊天记录

 @param delta        是否只返回为获取的消息
 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)Chatmsganddelta:(BOOL)delta Succeed:(void(^)(XZOneModel *model))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 下载语音文件

 @param mediaId       文件唯一标识
 @param companyId     账号标识
 @param filepath      文件储存的地址
 @param succeedBlock  成功回调
 @param errorBlock    失败回调
 */
- (void)downloadVoicemediaId:(NSString *)mediaId andcompanyId:(NSInteger)companyId andFilePath:(NSURL *)filepath andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 结束回话

 @param chatstatus   会话状态
 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)closeChatandChatStatus:(NSInteger)chatstatus andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 创建会话

 @param uid          客户id
 @param succeedBlock 成功
 @param errorBlock   失败回调
 */
- (void)ceateSessionanduid:(NSInteger)uid andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 切换会话

 @param sessionId    用户会话ID
 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)ChangeChatandsessionId:(NSInteger)sessionId andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 获取在线客服

 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)GetOnlineReceptionandSucceed:(void(^)(NSArray<XZTransferSessionthreeModel *> *DataArray))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 转接会话
 
 @param receptionId  客服ID
 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)TransferSessionandreceptionId:(NSString *)receptionId andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock;


/**
 获取历史会话列表

 @param succeedBlock 成功回调
 @param errorBlock   失败回调
 */
- (void)GetHistorySessionandSucceed:(void(^)(NSMutableArray *DataArray))succeedBlock andError:(void(^)(NSString *err))errorBlock;

@end
