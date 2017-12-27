//
//  XZNetWorkingManager.m
//  daodaokefu
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZNetWorkingManager.h"
#import "YYModel.h"
#import "XZClientModel.h"
#import "XZHomeSessionListModel.h"
#import "XZTransferSessionthreeModel.h"

typedef enum {
    Get      = 0,
    Post     = 1,
}RequestType;

@implementation XZNetWorkingManager

// 单例
+ (instancetype)sharderinstance{
    static dispatch_once_t onceToken;
    static XZNetWorkingManager *__INSTANCE__;
    dispatch_once(&onceToken, ^{
        __INSTANCE__ = [XZNetWorkingManager new];
        __INSTANCE__.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", @"text/html", nil];
    });
    return __INSTANCE__;
}

//封装的公共请求方法 私有方法外部无需关心如何使用直接调用.h封装好的方法就可以了
- (void)requestType:(RequestType)Type andRequesturl:(NSString *)url andparameters:(NSDictionary *)parameters andSucceed:(void(^)(id  _Nullable responseObject))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    if(Type == Get){ // Get请求
        [self GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString * code = responseObject[@"code"];
            if(code.intValue == 0){
                succeedBlock(responseObject);
            }else{
                errorBlock(responseObject[@"message"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorBlock([NSString stringWithFormat:@"%@",error]);
        }];
    }else{ // Post请求
        [self POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString * code = responseObject[@"code"];
            if(code.intValue == 0){
                succeedBlock(responseObject);
            }else{
                errorBlock(responseObject[@"message"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorBlock([NSString stringWithFormat:@"%@",error]);

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }];
    }
}

- (void)firstLogin:(NSString *)account andPassworrd:(NSString *)Passworrd andSucceed:(void(^)(XZUserinfoModel *model))succeedBlock andError:(void(^)(NSString *))errorBlock{
    [XZToolManager show];
    NSDictionary *dict = @{@"username":account,@"password":Passworrd};
    [self requestType:Post andRequesturl:APIfirstLogin andparameters:dict andSucceed:^(id  _Nullable responseObject) {
        // 字典转模型
        XZUserinfoModel *model = [XZUserinfoModel yy_modelWithJSON:responseObject[@"data"]];
        succeedBlock(model);
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}
- (void)logout {
    [self requestType:Post andRequesturl:APIlogOut andparameters:nil andSucceed:^(id  _Nullable responseObject){
    } andError:^(NSString *err) {
    }];
}
- (void)GethistorySucceed:(void(^)(NSArray *DataArray))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    [self requestType:Post andRequesturl:APIGetRecentUserInf andparameters:nil andSucceed:^(id  _Nullable responseObject) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XZClientModel class] json:responseObject[@"data"]];
        succeedBlock(arr);
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}
- (void)getMessageDataSucceed:(void(^)(NSMutableArray *DataArray))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    [self requestType:Post andRequesturl:APILiveSession andparameters:nil andSucceed:^(id  _Nullable responseObject) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XZHomeSessionListModel class] json:responseObject[@"data"]];
        NSMutableArray *arrM = [NSMutableArray array];
        for(XZHomeSessionListModel *model in arr) {
            XZGroup *gp      = [XZGroup new];
            gp.gName         = model.clientName;
            gp.imageurl      = model.imgUrl;
            gp.unReadCount   = model.unreadCount;
            gp.lastMsgTime   = [self StrTrunDate:model.lastChatLogTime];
            gp.lastMsgString = model.lastChatLog;
            gp.sessionId     = model.sessionId;
            gp.origin        = model.origin;
            gp.isActive      = model.isCurrent;
            [arrM addObject:gp];
        }
        succeedBlock(arrM);
    } andError:^(NSString *err) {
         errorBlock(err);
    }];
}
- (void)loginbytoken:(NSString *)token andSucceed:(void(^)(XZUserinfoModel *model))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    NSDictionary *dict = @{@"token":token};
    [self requestType:Post andRequesturl:APILoginbytoken andparameters:dict andSucceed:^(id  _Nullable responseObject) {
        XZUserinfoModel *model = [XZUserinfoModel yy_modelWithJSON:responseObject[@"data"]];
        succeedBlock(model);
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}
- (void)PulltheblackSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    [self requestType:Post andRequesturl:APIBlock_user andparameters:nil andSucceed:^(id  _Nullable responseObject) {
        succeedBlock();
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}
- (void)getcustomerinfoSucceed:(void(^)(XZNonceUserInfoModel *model))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    [self requestType:Post andRequesturl:APICustomerInfo andparameters:nil andSucceed:^(id  _Nullable responseObject) {
        
        XZNonceUserInfoModel *model = [XZNonceUserInfoModel yy_modelWithJSON:responseObject[@"data"]];
        succeedBlock(model);
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}
- (void)editremark:(NSString *)remark andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    NSDictionary *dict = @{@"remark":remark};
    [self requestType:Post andRequesturl:APIEditremark andparameters:dict andSucceed:^(id  _Nullable responseObject) {
        succeedBlock();
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}
- (void)sendMessage:(NSString *)messageStr andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    NSDictionary *dict = @{@"msg":messageStr};
    [self requestType:Post andRequesturl:APISendMessage andparameters:dict andSucceed:^(id  _Nullable responseObject) {
        succeedBlock();
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}
- (void)SendPictureMessage:(NSString *)iamgPath andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    [self POST:APISendPictureMessage parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage *img = [UIImage imageWithContentsOfFile:iamgPath];
        NSData *data = UIImageJPEGRepresentation(img, 0.5);
        [formData appendPartWithFileData:data name:@"img" fileName:iamgPath mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = responseObject[@"code"];
        if(code.intValue == 0){
            succeedBlock();
        }else{
            errorBlock(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock([NSString stringWithFormat:@"%@",error]);
    }];
}
- (void)GetquickreplySucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    [self requestType:Post andRequesturl:APIGetquickreply andparameters:nil andSucceed:^(id  _Nullable responseObject) {
        succeedBlock();
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}
- (void)Chatmsganddelta:(BOOL)delta Succeed:(void(^)(XZOneModel *model))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    bool bool_ =  delta ? true : false;
    NSDictionary *dict = @{@"delta":@(bool_)};
    [self requestType:Post andRequesturl:APIChatMessage andparameters:dict andSucceed:^(id  _Nullable responseObject) {
        XZOneModel *model =[XZOneModel yy_modelWithJSON:responseObject[@"data"]];
        succeedBlock(model);
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}

- (void)downloadVoicemediaId:(NSString *)mediaId andcompanyId:(NSInteger)companyId andFilePath:(NSURL *)filepath andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    NSDictionary *parameters = @{@"mediaId":mediaId,@"companyId":@(companyId)};
   NSMutableURLRequest *request =  [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:APIDownloadvoice parameters:parameters error:nil];
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return filepath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(error){
            errorBlock([NSString stringWithFormat:@"%@",error]);
        }else{
            succeedBlock();
        }
    }];
    [downloadTask resume];
}

- (void)closeChatandChatStatus:(NSInteger)chatstatus  andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    NSDictionary *dict =@{@"status":@(chatstatus)};
    [self requestType:Post andRequesturl:APIClosechat andparameters:dict andSucceed:^(id  _Nullable responseObject) {
        succeedBlock();
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}

- (void)ceateSessionanduid:(NSInteger)uid andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    NSDictionary *dict = @{@"uid":@(uid)};
    [self requestType:Post andRequesturl:APICreateSession andparameters:dict andSucceed:^(id  _Nullable responseObject) {
        succeedBlock();
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}

- (void)ChangeChatandsessionId:(NSInteger)sessionId andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    NSDictionary *dict = @{@"sessionId":@(sessionId)};
    [self requestType:Post andRequesturl:APIChangeChat andparameters:dict andSucceed:^(id  _Nullable responseObject) {
        succeedBlock();
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}

- (void)GetOnlineReceptionandSucceed:(void(^)(NSArray<XZTransferSessionthreeModel *> *DataArray))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    [self requestType:Post andRequesturl:APIOnline_reception andparameters:nil andSucceed:^(id  _Nullable responseObject) {
        NSString *array = responseObject[@"data"];
        NSArray<XZTransferSessionthreeModel *> *modelArray = [NSArray yy_modelArrayWithClass:[XZTransferSessionModel class] json:array];
        succeedBlock(modelArray);
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}

- (void)TransferSessionandreceptionId:(NSString *)receptionId andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    NSDictionary *dict = @{@"receptionId":receptionId};
    [self requestType:Get andRequesturl:APITransferSession andparameters:dict andSucceed:^(id  _Nullable responseObject) {
        succeedBlock();
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}

- (void)GetHistorySessionandSucceed:(void(^)(NSMutableArray *DataArray))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    [self requestType:Post andRequesturl:APIGetHistorySession andparameters:nil andSucceed:^(id  _Nullable responseObject) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XZHomeSessionListModel class] json:responseObject[@"data"]];
        NSMutableArray *arrM = [NSMutableArray array];
        for(XZHomeSessionListModel *model in arr) {
            XZGroup *gp      = [XZGroup new];
            gp.gName         = model.name;
            gp.imageurl      = model.avatar;
            gp.lastMsgTime   = [self StrTrunDate:model.lastChatLogTime];
            gp.lastMsgString = model.lastChatLog;
            gp.sessionId     = model.sessionId;
            gp.isActive      = model.isCurrent;
            gp.origin        = -1;
            [arrM addObject:gp];
        }
        succeedBlock(arrM);
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}

- (void)SessionChatLogandsessionId:(NSInteger)sessionId andSucceed:(void(^)(NSArray *model))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    NSDictionary *dict = @{@"sessionId":@(sessionId)};
    [self requestType:Post andRequesturl:APISessionChatLog andparameters:dict andSucceed:^(id  _Nullable responseObject) {
        NSArray *model =[NSArray yy_modelArrayWithClass:[XZOneModel class] json:responseObject[@"data"]];
        succeedBlock(model);
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}

- (NSString *)StrTrunDate:(NSString *)DateStr{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone         = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[DateStr doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
