//
//  XZMineViewController.m
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/20.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import "XZMineViewController.h"
#import "XZLoginViewController.h"
#import "AppDelegate.h"

@interface XZMineViewController ()
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *accountNumber;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *usersex;
@property (weak, nonatomic) IBOutlet UISwitch *isloginSwitch;

@end

@implementation XZMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    #pragma mark - 设置数据
    [self setData];
}

- (void)setData {
    
    AppDelegate *sd=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.username.text = sd.uesrmodel.name;
    self.name.text = sd.uesrmodel.name;
    self.usersex.text = sd.uesrmodel.sex == 0 ? @"男":@"女";
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 3){
        
        // 登出
        [self logoutAction];
    }
    
    if(indexPath.section == 0 || indexPath.section == 2){
        
        [XZToolManager showConfirmAlertView:@"提示" andMessage:@"此功能正在开发中,请敬请期待!" andVC:self];
    }
    
    
    
}

- (IBAction)setStatusAction:(UISwitch *)sender {
    
    if(sender.isOn){
        NSString *token = [kUserDefaults objectForKey:@"token"];
        
        [[XZNetWorkingManager sharderinstance] loginbytoken:token andSucceed:^(XZUserinfoModel *model){
            
            AppDelegate *sd=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            sd.uesrmodel = model;
            
            [kUserDefaults setObject:model.token forKey:@"token"];
            
        } andError:^(NSString *err) {

            [XZToolManager showErrorWithStatus:@"出现故障请请重试"];
        }];
        
       
        
    }else{
        [[XZNetWorkingManager sharderinstance] logout];
       
    }
}

// 退出操作
- (void)logoutAction {
     [kUserDefaults setBool:NO forKey:@"Login"];
     [kUserDefaults synchronize];
    [[XZNetWorkingManager sharderinstance] logout];
    
    
    kAppWindow.rootViewController = [XZLoginViewController new];
}
@end
