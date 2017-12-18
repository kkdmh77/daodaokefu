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
        __INSTANCE__.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
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
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
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
        XZUserinfoModel *model  = [XZUserinfoModel yy_modelWithJSON:responseObject[@"data"]];
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

- (void)GethistorySucceed:(void(^)(NSMutableArray *DataArray))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    [self requestType:Post andRequesturl:APIGetRecentUserInf andparameters:nil andSucceed:^(id  _Nullable responseObject) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XZClientModel class] json:responseObject[@"data"]];
        NSMutableArray *arrM = [NSMutableArray array];
        for(XZClientModel *model in arr) {
            XZGroup *gp = [XZGroup new];
            gp.gName = model.name;
            gp.imageurl = model.avatar;
            gp.lastMsgTime = [self StrTrunDate:model.lastChatTime];
            [arrM addObject:gp];
        }
        succeedBlock(arrM);
    } andError:^(NSString *err) {
        errorBlock(err);
    }];
}
- (void)getMessageDataSucceed:(void(^)(NSMutableArray *DataArray))succeedBlock andError:(void(^)(NSString *err))errorBlock{
    [self requestType:Post andRequesturl:APILiveSession andparameters:nil andSucceed:^(id  _Nullable responseObject) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XZHomeSessionListModel class] json:responseObject[@"data"]];
        NSMutableArray *arrM = [NSMutableArray array];
        for(XZHomeSessionListModel *model in arr) {
            XZGroup *gp = [XZGroup new];
            gp.gName = model.clientName;
            gp.imageurl = model.imgUrl;
            gp.unReadCount = model.unreadCount;
            gp.lastMsgTime = [self StrTrunDate:model.lastChatLogTime];
            gp.lastMsgString = model.lastChatLog;
            [arrM addObject:gp];
        }
        
        succeedBlock(arrM);
    } andError:^(NSString *err) {
         errorBlock(err);
    }];
}
- (NSString *)StrTrunDate:(NSString *)DateStr{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[DateStr doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
