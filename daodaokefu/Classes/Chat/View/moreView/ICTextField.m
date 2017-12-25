//
//  ICTextField.m
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/28.
//  Copyright © 2016年 gxz All rights reserved.
//

#import "ICTextField.h"

@implementation ICTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self becomeFirstResponder];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}








@end
