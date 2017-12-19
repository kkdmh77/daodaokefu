//
//  Modificationdatum ViewController.m
//  daodaokefu
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "Modificationdatum ViewController.h"
#import "Masonry.h"

@interface Modificationdatum_ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation Modificationdatum_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"修改资料";
    self.saveButton.layer.cornerRadius = 15;
    
}


- (IBAction)saveAction:(id)sender {
    NSString *remarkStr = self.nameTextField.text;
    
    if([remarkStr isEqualToString:@""]) return;
    
    if(remarkStr.length >= 8){
        
        [XZToolManager showConfirmAlertView:@"提示" andMessage:@"亲最多可以输入8个字符哦！" andVC:self];
        
        return;
    }

    
    
    [XZToolManager show];
    [[XZNetWorkingManager sharderinstance] editremark:remarkStr andSucceed:^{
        
        [XZToolManager showSuccessWithStatus:@"修改成功"];
        self.textBlock(remarkStr);
        [self.navigationController popViewControllerAnimated:YES];
    } andError:^(NSString *err) {
        [XZToolManager showErrorWithStatus:@"修改失败"];
    }];
    
    
}

@end
