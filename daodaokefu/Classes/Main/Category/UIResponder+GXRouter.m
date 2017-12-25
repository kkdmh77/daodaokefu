//
//  UIResponder+GXRouter.m
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/17.
//  Copyright © 2016年 gxz All rights reserved.
//

#import "UIResponder+GXRouter.h"

@implementation UIResponder (GXRouter)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
