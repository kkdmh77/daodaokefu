//
//  XZOneModel.m
//  daodaokefu
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZOneModel.h"

@implementation XZOneModel

//+（NSDictionary *）modelContainerPropertyGenericClass {
//    //值应该是类或类的名称。
//    return @ { @ shadows ”：[Shadow class ]，
//        @ borders ”：边框。class，
//        @“ attachments ”：@“ Attachment ” };
//}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"chatLog":[XZAcceptMessageModel class]};
}

@end
