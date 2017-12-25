//
//  ICHeadImageView.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/8.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICHeadImageView : UIView

@property (nonatomic, weak) UIImageView *imageView;

- (void)setColor:(UIColor *)color bording:(CGFloat)bording;

@end
