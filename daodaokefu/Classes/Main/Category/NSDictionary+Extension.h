//
//  NSDictionary+Extension.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/20.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonStr;

- (NSString*)jsonString;

@end
