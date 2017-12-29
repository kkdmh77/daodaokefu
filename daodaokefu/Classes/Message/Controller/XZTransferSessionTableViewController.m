//
//  XZTransferSessionTableViewController.m
//  daodaokefu
//
//  Created by apple on 2017/12/25.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZTransferSessionTableViewController.h"
#import "XZTransferSessionTableViewCell.h"


@interface XZTransferSessionTableViewController ()

@property (nonatomic, copy)NSArray<XZTransferSessionModel *> *listArray;

@property (nonatomic, strong)XZTransferSessionTableViewCell *cell;

@property (nonatomic, strong)UIImageView *vv;

@end

@implementation XZTransferSessionTableViewController{
    
    NSString *receptionId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    #pragma mark - 布局UI
    [self setupUI];
    
    #pragma mark - 加载数据
    [self loadData];
}


- (void)setupUI {
    
    self.title = @"其他在线客服";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.tableView.rowHeight = 80;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"XZTransferSessionTableViewCell" bundle:nil] forCellReuseIdentifier:@"XZTransferSessionTableViewCell"];
    [self.tableView addSubview:[self createButton]];
}

- (UIView *)createButton{
    
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"空数据"]];
    self.vv = imageview;
    imageview.frame = CGRectMake(0, 0, 100, 100);
    
    imageview.centerX = SCREEN_WIDTH / 2;
    imageview.centerY = (SCREEN_HEIGHT - 64) / 2 - 80;
    
    return imageview;
}


- (void)loadData {
    
    [[XZNetWorkingManager sharderinstance] GetOnlineReceptionandSucceed:^(NSArray<XZTransferSessionModel *> *DataArray){
        
        self.listArray = DataArray;
        
        self.vv.hidden = self.listArray.count == 0 ? NO : YES;
        [self.tableView reloadData];
        
    } andError:^(NSString *err) {
        
    }];
}

- (void)rightBarButtonItemAction {
    
    if(receptionId == nil) return;
    
    [[XZNetWorkingManager sharderinstance] TransferSessionandreceptionId:receptionId andSucceed:^{
        [kNotificationCenter postNotificationName:HomeRefreshdata object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } andError:^(NSString *err) {
       
        [XZToolManager showErrorWithStatus:@"操作失败请重试"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZTransferSessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZTransferSessionTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.listArray[indexPath.row];
    receptionId = self.listArray[indexPath.row].user.receptionId;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.cell.isShow = YES;
    
    XZTransferSessionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.cell = cell;
    
    cell.isShow = NO;
    
    [tableView reloadData];
}

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
