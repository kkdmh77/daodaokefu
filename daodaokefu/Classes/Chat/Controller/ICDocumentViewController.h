//
//  ICDocumentViewController.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/29.
//  Copyright © 2016年 gxz All rights reserved.
//

#import "ICDocumentViewController.h"

@protocol ICDocumentDelegate <NSObject>

- (void)selectedFileName:(NSString *)fileName;

@end

@interface ICDocumentViewController : UIViewController

@property (nonatomic, weak) id <ICDocumentDelegate>delegate;

@end
