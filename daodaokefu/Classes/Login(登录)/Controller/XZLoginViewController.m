//
//  XZLoginViewController.m
//  daodoakefu
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZLoginViewController.h"
#import "XZLoginView.h"
#import "XZTabBarController.h"
#import "DHGuidePageHUD.h"
#import <AVFoundation/AVFoundation.h>
#import "XZUserinfoModel.h"
#import "AppDelegate.h"
@interface XZLoginViewController ()<PushHomeMessageVc>

//@property(nonatomic,strong)AVPlayer *player;
@end

@implementation XZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    #pragma mark - 添加监听
    [self addNotification];
    
    #pragma mark - 设置UI相关
    [self setupUI];
    
    [self leadpage];
    
}


- (void)addNotification {
    
    // 监听键盘出现的出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
- (void)setupUI {
    
    XZLoginView *loginView = [[[NSBundle mainBundle] loadNibNamed:@"LoginViewViewController" owner:self options:nil] lastObject];

    
    self.view = loginView;
    
    loginView.delegate = self;
}

#pragma mark -  loginView delegate
- (void)PushHomeMessageVc:(NSString *)account andPassword:(NSString *)password {
    [self.view endEditing:YES];
    
    if( [self loginPushjudgeAction:account andErrorStr:@"亲你还没输入账号呐"] || [self loginPushjudgeAction:password andErrorStr:@"亲你还没输入密码呐"]) return;
    
    
    [[XZNetWorkingManager sharderinstance] firstLogin:account andPassworrd:password andSucceed:^(XZUserinfoModel *model){
       
        
        AppDelegate *sd=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        sd.uesrmodel = model;
        
        [kUserDefaults setObject:model.token forKey:@"token"];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        window.rootViewController = [[XZTabBarController alloc] init];
        
    } andError:^(NSString *err) {
       
        [XZToolManager showInfoWithStatus:@"输入密码错误，请重新登录"];
        
    }];
    
    
    
}

#pragma mark - 跳转逻辑判断
- (BOOL)loginPushjudgeAction:(NSString *)text andErrorStr:(NSString *)errorStr{
    
    if([text isEqualToString:@""]){
        
        [XZToolManager showConfirmAlertView:@"温馨提示" andMessage:errorStr andVC:self
         ];
        
        return YES;
    }
    
    return NO;
}


#pragma mark 键盘将要出现
-(void)keyboardWillShow:(NSNotification *)notifa{
    [self dealKeyboardFrame:notifa];
}
#pragma mark 键盘消失完毕
-(void)keyboardWillHide:(NSNotification *)notifa{
    [self dealKeyboardFrame:notifa];
}

#pragma mark 处理键盘的位置
-(void)dealKeyboardFrame:(NSNotification *)changeMess{
    NSDictionary *dicMess=changeMess.userInfo;//键盘改变的所有信息
    
    CGFloat keyboardMoveY=[dicMess[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y-[UIScreen mainScreen].bounds.size.height;//键盘Y值的改变(字典里面的键UIKeyboardFrameEndUserInfoKey对应的值-屏幕自己的高度)
    [UIView animateWithDuration:0.25 animations:^{ //0.25秒之后改变tableView和bgView的Y轴
        self.view.transform=CGAffineTransformMakeTranslation(0, keyboardMoveY * 0.3);
        
    }];
    
  
}

- (void)leadpage{

    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        // 视频引导页
        [self setStaticGuidePage];
    }
}

#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    // 初始化视频URL
    NSURL *videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"QQLoginVideo" ofType:@"mp4"]];
    // 创建并添加引导页
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.bounds videoURL:videoURL];
    [self.view addSubview:guidePage];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


@end
