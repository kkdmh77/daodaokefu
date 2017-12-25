//
//  ICChatBoxViewController.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/10.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICRecordManager.h"
#import "ICChatBoxViewControllerDelegate.h"
#import "ICChatBox.h"

@interface ICChatBoxViewController : UIViewController

@property(nonatomic, weak) id<ICChatBoxViewControllerDelegate>delegate;

@property (nonatomic, strong) ICChatBox *chatBox;

@end
