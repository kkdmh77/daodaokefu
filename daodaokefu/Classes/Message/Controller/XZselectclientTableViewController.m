//
//  XZselectclientTableViewController.m
//  daodaokefu
//
//  Created by apple on 2017/12/25.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZselectclientTableViewController.h"
#import "XZselectclientTableViewCell.h"
#import "XZChatViewController.h"
@interface XZselectclientTableViewController ()

@property (strong, nonatomic) NSArray *listArray;

@property (nonatomic, strong) UIImageView *vv;

@end

@implementation XZselectclientTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   #pragma mark - 布局UI
    [self setupUI];
    
    #pragma mark - 加载数据
    [self loadDataSource];
}

- (void)setupUI {
    
    self.title = @"选择客户";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftBarButtonItemAction)];

    
    self.tableView.rowHeight = 80;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XZselectclientTableViewCell" bundle:nil] forCellReuseIdentifier:@"XZselectclientTableViewCell"];
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

- (void)loadDataSource {
    
    [[XZNetWorkingManager sharderinstance] GethistorySucceed:^(NSArray *DataArray) {
        
        self.listArray = DataArray;
        
        self.vv.hidden = self.listArray.count == 0 ? NO : YES;
        [self.tableView reloadData];
        
    } andError:^(NSString *err) {
        
        
    }];
}

- (void)leftBarButtonItemAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZselectclientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZselectclientTableViewCell" forIndexPath:indexPath];
    cell.model = self.listArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    XZClientModel *model = self.listArray[indexPath.row];
    
        XZGroup *gp      = [XZGroup new];
        gp.gName         = model.name;
        gp.imageurl      = model.avatar;
        gp.sessionId     = model.id;
    
    for (XZGroup *md in _modelArray) {
        if([model.name isEqualToString:md.gName]){
            
            [[XZNetWorkingManager sharderinstance] ChangeChatandsessionId:md.sessionId andSucceed:^{
            XZChatViewController *chatVc = [[XZChatViewController alloc] init];
                chatVc.group                 = gp;
                [self.messagevc.navigationController pushViewController:chatVc animated:NO];
                [self dismissViewControllerAnimated:YES completion:nil];
            } andError:^(NSString *err) {
                
            }];
            
            return;
        }
     }
    

        XZChatViewController *chatVc = [[XZChatViewController alloc] init];
        chatVc.group                 = gp;
        chatVc.isCreate              = YES;
        [self.messagevc.navigationController pushViewController:chatVc animated:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
        
  
   
}

@end
