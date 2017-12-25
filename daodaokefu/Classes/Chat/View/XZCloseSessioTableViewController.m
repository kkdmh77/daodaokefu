//
//  XZCloseSessioTableViewController.m
//  daodaokefu
//
//  Created by apple on 2017/12/25.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZCloseSessioTableViewController.h"

@interface XZCloseSessioTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *SessionStatusa;
@property (weak, nonatomic) IBOutlet UILabel *SessionType;
@property (weak, nonatomic) IBOutlet UISwitch *gradeSwitch;
@property (weak, nonatomic) IBOutlet UITextView *remarks;

@end

@implementation XZCloseSessioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    #pragma mark - 布局Ui
    [self setupUI];
}

- (void)setupUI {
    
    self.title = @"关闭会话";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(NavrigthBarButtonItemAction)];
    
    
}

- (void)NavrigthBarButtonItemAction {
    
    NSInteger status = [self.SessionStatusa.text isEqualToString:@"已完成状态"] ? 0 : 1;
    
    [XZToolManager show];
    
    [[XZNetWorkingManager sharderinstance] closeChatandChatStatus:status andSucceed:^{
        [kNotificationCenter postNotificationName:HomeRefreshdata object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [SVProgressHUD dismiss];
    } andError:^(NSString *err) {
        [SVProgressHUD dismiss];
        [XZToolManager showErrorWithStatus:@"提交失败,请重试"];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0){ // 弹出会话状态
        
        [self showSessionStatus];
    }else if(indexPath.row == 1){ // 弹出会话类型
        
        [self showSessionType];
    }
    
}

- (void)showSessionStatus {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *accomplish = [UIAlertAction actionWithTitle:@"已完成状态" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.SessionStatusa.text = @"已完成状态";
    }];
    
    UIAlertAction *defeated = [UIAlertAction actionWithTitle:@"未完成状态" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        self.SessionStatusa.text = @"未完成状态";
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alert addAction:accomplish];
    [alert addAction:defeated];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        
        return 20;
    }else{
        
        return 30;
    }
}

- (void)showSessionType {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}




@end
