//
//  XZLoginView.m
//  daodoakefu
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZLoginView.h"
@interface XZLoginView()<UITextFieldDelegate>

/**
 账号
 */
@property (weak, nonatomic) IBOutlet UITextField *account;

/**
 密码
 */
@property (weak, nonatomic) IBOutlet UITextField *password;

/**
 登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@property (nonatomic,strong) UIButton *accountButton;

@property (nonatomic,strong) UIButton *passwordButton;
@end
@implementation XZLoginView

- (void)awakeFromNib{
    [super awakeFromNib];
    // 设置圆角
    self.loginButton.layer.cornerRadius = 10;
    
    [kNotificationCenter addObserver:self selector:@selector(textFieldDidBeginEditing:) name: UITextFieldTextDidBeginEditingNotification object:nil];
    
    UIButton *accountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 24, 20)];
    accountButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    accountButton.userInteractionEnabled = false;
    [accountButton setImage:[UIImage imageNamed:@"用户名icon-未点亮"] forState:UIControlStateNormal];
    
    self.accountButton = accountButton;
    self.account.leftViewMode = UITextFieldViewModeAlways;
    self.account.leftView = accountButton;
    
    UIButton *passwordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 24, 20)];
    passwordButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    passwordButton.userInteractionEnabled = false;
    [passwordButton setImage:[UIImage imageNamed:@"密码icon-未点亮"] forState:UIControlStateNormal];
    
    self.passwordButton = passwordButton;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.password.leftView = passwordButton;
    
    self.account.delegate = self;
    self.password.delegate = self;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(self.account.isFirstResponder){
        
        [self setAccountbuttonimage:YES];

    }else{
        
        [self setPasswordbuttonimage:YES];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(self.account.text.length == 0){
        
        [self setAccountbuttonimage:NO];
    }
    
    if(self.password.text.length == 0){
        
        [self setPasswordbuttonimage:NO];
    }
    
}

// 抽象公共方法
- (void)setAccountbuttonimage:(BOOL)isSet{
    
    [self.accountButton setImage:isSet ? [UIImage imageNamed:@"用户名icon"] : [UIImage imageNamed:@"用户名icon-未点亮"] forState:UIControlStateNormal];
    
}

- (void)setPasswordbuttonimage:(BOOL)isSet{
    
    [self.passwordButton setImage:isSet ? [UIImage imageNamed:@"密码icon"] : [UIImage imageNamed:@"密码icon-未点亮"] forState:UIControlStateNormal];
}

- (IBAction)loginclickButtonAction:(id)sender {
    
    // 验证
    if([self.delegate respondsToSelector:@selector(PushHomeMessageVc:andPassword:)]){
        
        [self.delegate PushHomeMessageVc:self.account.text andPassword:self.password.text];
    }
    
}

@end
