//
//  XZLoginView.h
//  daodoakefu
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PushHomeMessageVc <NSObject>

- (void)PushHomeMessageVc:(NSString *)account andPassword:(NSString *)password;
@end
@interface XZLoginView : UIView

@property(nonatomic,weak)id<PushHomeMessageVc> delegate;

@end
