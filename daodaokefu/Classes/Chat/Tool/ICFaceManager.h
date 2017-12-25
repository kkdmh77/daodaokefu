//
//  ICFaceManager.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/1.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <Foundation/Foundation.h>
@class ICEmotion;

@interface ICFaceManager : NSObject

+ (NSArray *)emojiEmotion;

+ (NSArray *)customEmotion;

+ (NSArray *)gifEmotion;

+ (NSMutableAttributedString *)transferMessageString:(NSString *)message
                                                font:(UIFont *)font
                                          lineHeight:(CGFloat)lineHeight;


@end
