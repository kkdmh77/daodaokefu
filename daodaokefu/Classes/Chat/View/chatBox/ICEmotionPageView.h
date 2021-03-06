//
//  ICEmotionPageView.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/6.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZEmotion.h"


#define ICEmotionMaxRows 3
#define ICEmotionMaxCols 7
#define ICEmotionPageSize ((ICEmotionMaxRows * ICEmotionMaxCols) - 1)

@interface ICEmotionPageView : UIView

@property (nonatomic, strong) NSArray *emotions;

@end
