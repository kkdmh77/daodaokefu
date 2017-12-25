//
//  ICPhotoBrowserController.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/12.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICPhotoBrowserController : UIViewController

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong,) UIImageView *imageView;


- (instancetype)initWithImage:(UIImage *)image;


@end
