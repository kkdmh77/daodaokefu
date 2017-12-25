//
//  ICFileButton.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/21.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICMessageModel;

@interface ICFileButton : UIButton

@property (nonatomic, strong) ICMessageModel *messageModel;

@property (nonatomic, strong) UILabel *identLabel;

@property (nonatomic, strong) UIProgressView *progressView;

@end
