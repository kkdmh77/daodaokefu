//
//  ICTools.m
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/20.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import "ICTools.h"

@implementation ICTools

+(BOOL)hasPermissionToGetCamera
{
    BOOL hasPermission = YES;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        hasPermission = NO;
    }
    return hasPermission;
}

@end
