//
//  XZNetWorkingManager.m
//  daodaokefu
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZNetWorkingManager.h"
#import "YYModel.h"

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
                
                //                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                errorBlock(responseObject[@"message"]);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            errorBlock([NSString stringWithFormat:@"%@",error]);
            
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            
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

@end
