//
//  XZToolManager.h
//  daodoakefu
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZToolManager : NSObject

+ (instancetype)shardManager;

/**
 弹出确定的AlertView
 
 @param title 标题
 @param messageStr 消息内容
 */
+ (void)showConfirmAlertView:(NSString *)title andMessage:(NSString *)messageStr andVC:(UIViewController *)ViewController;


/**
 自定义样式的HUD

 @param message 要显示的内容
 */
+ (void)showErrorWithStatus:(NSString *)message;


/**
 自定义样式的HUD

 @param message 要显示的内容
 */
+ (void)showInfoWithStatus:(NSString *)message;


/**
 自定义样式的HUD

 @param message 要显示的内容
 */
+ (void)showSuccessWithStatus:(NSString *)message;


/**
 自定义样式的HUD
 */
+ (void)show;
@end
