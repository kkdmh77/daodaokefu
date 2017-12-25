//
//  ICAudioView.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/17.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICAudioView : UIView


@property (nonatomic, copy) NSString *audioName;

@property (nonatomic, copy) NSString *audioPath;

- (void)releaseTimer;


@end
