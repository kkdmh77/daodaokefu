//
//  XZHistorySessionTableViewController.m
//  daodaokefu
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZHistorySessionTableViewController.h"
#import "XZselectclientTableViewCell.h"
#import "XZMessageCell.h"
#import "MJChiBaoZiHeader.h"
#import "XZChatViewController.h"

@interface XZHistorySessionTableViewController ()

@property (nonatomic, strong) NSArray *listArray;

@end

@implementation XZHistorySessionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   #pragma mark - 布局UI
    [self setupUI];
    
    #pragma mark - 加载数据
    [self loadData];
}

- (void)setupUI {
    

    // 注册cell
    [self.tableView registerClass:[XZMessageCell class] forCellReuseIdentifier:@"XZMessageCell"];
    
    self.tableView.rowHeight = 67.0;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJChiBaoZiHeader*header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    self.tableView.mj_header = header;
    
}

- (void)loadData {
    
    [[XZNetWorkingManager sharderinstance] GetHistorySessionandSucceed:^(NSMutableArray *DataArray) {
        [self.tableView.mj_header endRefreshing];
        self.listArray = DataArray;
        
        [self.tableView reloadData];
    } andError:^(NSString *err) {
        [self.tableView.mj_header endRefreshing];
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
    XZMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZMessageCell" forIndexPath:indexPath];
    if (indexPath.row == self.listArray.count - 1) {
        [cell setBottomLineStyle:CellLineStyleNone];
    }
    else {
        [cell setBottomLineStyle:CellLineStyleDefault];
    }
    cell.group = self.listArray[indexPath.row];
    return cell;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     XZGroup *gp                  = self.listArray[indexPath.row];
    
        XZChatViewController *chatVc = [[XZChatViewController alloc] init];
        chatVc.isHistory             = YES;
        
        chatVc.group                 = gp;
        [self.navigationController pushViewController:chatVc animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
@end
