//
//  XZUserinfoTableViewController.m
//  daodoakefu
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZUserinfoTableViewController.h"
#import "XZNonceUserInfoModel.h"
#import "Modificationdatum ViewController.h"

@interface XZUserinfoTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *blacklistButton;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *alias;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *origin;
@property (weak, nonatomic) IBOutlet UILabel *bindingID;
@property (weak, nonatomic) IBOutlet UILabel *affiliatedCrew;
@property (weak, nonatomic) IBOutlet UILabel *OtherInfo;

@end

@implementation XZUserinfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    #pragma mark - 布局UI
    [self setupUI];
    
    #pragma mark - 加载用户资料
    [self loadData];
}

- (void)setupUI {
    _blacklistButton.layer.cornerRadius = 10;
    self.tableView.backgroundColor =  [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
}

- (void)loadData {
    [[XZNetWorkingManager sharderinstance] getcustomerinfoSucceed:^(XZNonceUserInfoModel *model){
        self.name.text = model.name;
        self.sex.text  = model.gender == 0 ? @"女":@"男";
        self.area.text = model.area == nil ? @"暂无": model.area;
        self.origin.text = model.origin == 0 ? @"Web" : model.origin == 1 ? @"WeChat" : @"mobile";
        self.bindingID.text = model.openId;
        
    } andError:^(NSString *err) {
        
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0){
        return @"基本信息";
    }else if(section == 1){
        return @"会员信息";
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.5;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    view.tintColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.textColor = [UIColor lightGrayColor];
    headerView.textLabel.font = [UIFont systemFontOfSize:14];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 0 && indexPath.row == 1){
        
        // 跳转修改备注页面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        Modificationdatum_ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"Modificationdatum_ViewController"];
        vc.textBlock = ^(NSString *text) {
          
            self.alias.text = text;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (IBAction)laheiAction:(id)sender {
    
    [[XZNetWorkingManager sharderinstance] PulltheblackSucceed:^{
        
        [XZToolManager showSuccessWithStatus:@"拉黑成功"];
        
    } andError:^(NSString *err) {
       
        [XZToolManager showErrorWithStatus:@"出现问题，请重试"];
    }];
    
}

/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
