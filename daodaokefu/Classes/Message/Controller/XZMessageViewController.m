//
//  XZMessageViewController.m
//  daodoakefu
//
//  Created by 郭现壮 on 16/9/27.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import "XZMessageViewController.h"
#import "XZGroupSearchController.h"
#import "XZMessageCell.h"
#import "XZChatViewController.h"
#import "IFMMenu.h"
#import "HMScannerController.h"
#import "XZToolManager.h"
#import "XZUserinfoModel.h"
#import "AppDelegate.h"

@interface XZMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation XZMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    #pragma mark - 自动登录
    [self tokenLogin];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)tokenLogin {
    
    NSString *token =  [kUserDefaults objectForKey:@"token"];
    if(token != nil){
        
        [[XZNetWorkingManager sharderinstance] loginbytoken:token andSucceed:^(XZUserinfoModel *model){
            
            AppDelegate *sd=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            sd.uesrmodel = model;
            
            [kUserDefaults setObject:model.token forKey:@"token"];
            
            [self loadDataSource];
            
        } andError:^(NSString *err) {
            
            
        }];
    }else{
        
            [self loadDataSource];
    }
}
- (void)setupUI
{
    self.view.backgroundColor = XZRGB(0xf4f1f1);
    self.tableView.backgroundColor = XZRGB(0xf4f1f1);
    XZGroupSearchController *searchVC    = [[XZGroupSearchController alloc] init];
//    searchVC.delegate                    = self;
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:searchVC];
    [searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = searchController.searchBar;
    _searchController              = searchController;
    [searchController.searchBar setBarTintColor:BACKGROUNDCOLOR];
    [searchController.searchBar.layer setBorderWidth:0.5f];
    [searchController.searchBar.layer setBorderColor:BACKGROUNDCOLOR.CGColor];
    searchController.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    searchController.view.backgroundColor = [UIColor whiteColor];
    searchController.hidesNavigationBarDuringPresentation = YES;
    self.tableView.frame  = CGRectMake(0,0, self.view.width, SCREEN_HEIGHT);
//
    UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"加号"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    
    self.navigationItem.rightBarButtonItem = rigthItem;
    
}

- (void)loadDataSource
{
    XZGroup *group = [[XZGroup alloc] init];
    group.unReadCount = 2;
    group.gName = @"迷宫已失";
    group.lastMsgString = @"滑板和吉他🎸哪个更好那？";
    [self.dataArray addObject:group];
    
    [[XZNetWorkingManager sharderinstance] getMessageDataSucceed:^(NSMutableArray *DataArray) {
        self.dataArray = DataArray;
        [self.tableView reloadData];
    } andError:^(NSString *err) {
        
        [XZToolManager showErrorWithStatus:err];
        
    }];
    
}

- (void)rightBarButtonAction {
    
    
    __weak typeof(self) weakself = self;
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithObjects:
                                 
                                 [IFMMenuItem itemWithImage:[UIImage imageNamed:@"扫一扫"]
                                                      title:@"扫一扫"
                                                     action:^(IFMMenuItem *item) {
                                                         
                                                         [weakself openScan];
                                                         
                                                     }],
                                 [IFMMenuItem itemWithImage:[UIImage imageNamed:@"拍摄"]
                                                      title:@"拍摄"
                                                     action:^(IFMMenuItem *item) {
                                                         
                                                         [XZToolManager showConfirmAlertView:@"提示" andMessage:@"此功能正在开发当中,请敬请期待谢谢!" andVC:self];
                                                     }],
                                 [IFMMenuItem itemWithImage:[UIImage imageNamed:@"更多-3"]
                                                      title:@"创建会话"
                                                     action:^(IFMMenuItem *item) {
                                                         
                                                         [self addsession];
                                                         
                                                     }], nil];
    
    IFMMenu *menu = [[IFMMenu alloc] initWithItems:menuItems];
    menu.edgeInsets = UIEdgeInsetsMake(0, 15, 0, 20); //下拉框的内边距
    menu.gapBetweenImageTitle = 15; //图片和标题间距
    menu.minMenuItemHeight = 45;    //Item最小高度
    menu.titleFont = [UIFont systemFontOfSize:15];  //Item字体
    menu.segmenteLineColor = [UIColor darkGrayColor];   //分割线颜色

    menu.menuSegmenteLineStyle = IFMMenuSegmenteLineStylefollowContent;  //分割线类型
    
    [menu showFromNavigationController:self.navigationController WithX:self.view.frame.size.width - 60];
}

- (void)addsession {
    
    XZGroup *group = [[XZGroup alloc] init];
    group.unReadCount = 6;
    group.gName = @"张国瑞";
    group.lastMsgString = @"你看到我的九去哪里了么?";
    group.imageurl = @"https://avatars1.githubusercontent.com/u/6919743?s=400&v=4";
    [self.dataArray addObject:group];
    [self.tableView reloadData];
}

- (void)openScan{
   
    NSString *cardName = @"迷宫已失 - 土土";
    UIImage *avatar = [UIImage imageNamed:@"咖啡"];
    
    // 实例化扫描控制器
    HMScannerController *scanner = [HMScannerController scannerWithCardName:cardName avatar:avatar completion:^(NSString *stringValue) {
        
//        self.scanResultLabel.text = stringValue;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue]];
        
    }];
    
    // 设置导航栏样式
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor whiteColor]];
    
    // 展现扫描控制器
    [self showDetailViewController:scanner sender:nil];
    
}


#pragma mark - tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZMessageCell *cell = [XZMessageCell cellWithTableView:tableView];
    if (indexPath.row == self.dataArray.count - 1) {
        [cell setBottomLineStyle:CellLineStyleNone];
    }
    else {
        [cell setBottomLineStyle:CellLineStyleDefault];
    }
    cell.group = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *topTitle ,*readTitle;
    XZGroup *group  = self.dataArray[indexPath.row];
    topTitle  = group.isTop ? @"取消置顶" : @"置顶";
    readTitle = group.unReadCount ? @"标为已读" : @"标为未读";
    //设置删除按钮
    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [self deleteLocalGroup:indexPath];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }];
    //置顶
    UITableViewRowAction * topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:topTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [self setTopCellWithIndexPath:indexPath currentTop:group.isTop];
        [self.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        [self.tableView reloadData];
    }];
    //标记已读
    UITableViewRowAction * collectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:readTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [self markerReadWithIndexPath:indexPath currentUnReadCount:group.unReadCount];
        XZGroup *gp = self.dataArray[indexPath.row];
        gp.unReadCount = 0;
        self.dataArray[indexPath.row] = gp;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    collectRowAction.backgroundColor = [UIColor grayColor];
    topRowAction.backgroundColor     = [UIColor orangeColor];
    return  @[deleteRowAction,topRowAction,collectRowAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    XZGroup *group               = self.dataArray[indexPath.row];
    XZChatViewController *chatVc = [[XZChatViewController alloc] init];
    chatVc.group                 = group;
    [self.navigationController pushViewController:chatVc animated:YES];
}





#pragma mark - setter and getter

- (UITableView *)tableView
{
    if (nil == _tableView) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
}



@end
