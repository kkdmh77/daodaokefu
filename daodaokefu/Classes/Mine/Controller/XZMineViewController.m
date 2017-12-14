//
//  XZMineViewController.m
//  daodoakefu
//
//  Created by 郭现壮 on 16/9/27.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import "XZMineViewController.h"
#import "XZLoginViewController.h"

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
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 2){
        
        // 登出
        [self logoutAction];
    }
    
    [XZToolManager showConfirmAlertView:@"提示" andMessage:@"此功能正在开发中,请敬请期待!" andVC:self];
}


// 退出操作
- (void)logoutAction {
    
    kAppWindow.rootViewController = [XZLoginViewController new];
}
@end
