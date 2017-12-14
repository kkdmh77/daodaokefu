//
//  XZToolManager.m
//  daodoakefu
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZToolManager.h"

// 常用的工具类

@implementation XZToolManager

+ (instancetype)shardManager{
    static dispatch_once_t onceToken;
    static XZToolManager *__INSTANCE__;
    dispatch_once(&onceToken, ^{
        
        __INSTANCE__ = [XZToolManager new];
        
    });
    
    return __INSTANCE__;
}

+ (void)showConfirmAlertView:(NSString *)title andMessage:(NSString *)messageStr andVC:(UIViewController *)ViewController{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messageStr preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
    }]];
    
    [ViewController presentViewController:alert animated:true completion:nil];
    
}

+ (void)showErrorWithStatus:(NSString *)message{
    
    [self setupHUDStyle];
    [SVProgressHUD showErrorWithStatus:message];
}

+ (void)showInfoWithStatus:(NSString *)message{
    [self setupHUDStyle];
    [SVProgressHUD showInfoWithStatus:message];
}

+ (void)showSuccessWithStatus:(NSString *)message{
    [self setupHUDStyle];
    [SVProgressHUD showSuccessWithStatus:message];
}

+ (void)show{
    [self setupHUDStyle];
    [SVProgressHUD show];
}

+ (void)setupHUDStyle {

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:18]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];

}
@end

