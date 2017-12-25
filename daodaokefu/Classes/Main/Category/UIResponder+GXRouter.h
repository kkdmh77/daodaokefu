//
//  UIResponder+GXRouter.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/17.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (GXRouter)

// router message and the responder who you want will respond this method
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end
