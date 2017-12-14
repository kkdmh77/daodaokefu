//
//  XZNetWorkingManager.m
//  daodaokefu
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZNetWorkingManager.h"

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


// 第一次登录
- (void)firstLogin:(NSString *)account andPassworrd:(NSString *)Passworrd andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *))errorBlock{
    
    NSDictionary *dict = @{@"username":account,@"password":Passworrd};
    
    [self requestType:Post andRequesturl:APIfirstLogin andparameters:dict andSucceed:^{
       
        succeedBlock();
        
    } andError:^(NSString *error) {
        
        errorBlock(error);
    }];
}


// 封装的公共请求方法
- (void)requestType:(RequestType)Type andRequesturl:(NSString *)url andparameters:(NSDictionary *)parameters andSucceed:(void(^)(void))succeedBlock andError:(void(^)(NSString *))errorBlock{
    
    [XZToolManager show];
    
    if(Type == Get){ // Get请求
        [self GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString * code = responseObject[@"code"];
            if(code.intValue == 0){
                
                succeedBlock();
            }else{
                
                errorBlock(responseObject[@"message"]);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            errorBlock([NSString stringWithFormat:@"%@",error]);
            
        }];
        
    }else{ // Post请求
        
        [self GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            NSString * code = responseObject[@"code"];
            if(code.intValue == 0){
                
                succeedBlock();
                
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

@end
