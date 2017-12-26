//
//  XZTabBarController.m
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/20.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import "XZTabBarController.h"
#import "XZMineViewController.h"
#import "XZMessageViewController.h"
#import "XZHistorySessionTableViewController.h"
#import "XZDiscoverViewController.h"
#import "XZNavigationController.h"

@interface XZTabBarController ()

@end

@implementation XZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XZMessageViewController *messageVc = [[XZMessageViewController alloc] init];
    [self addChildVc:messageVc title:@"当前会话" image:@"当前会话-未点亮" selectedImage:@"当前会话-点亮"];
    
    XZHistorySessionTableViewController *contactsVc = [[XZHistorySessionTableViewController alloc] init];
    [self addChildVc:contactsVc title:@"历史会话" image:@"历史会话--未点亮" selectedImage:@"历史会话--点亮"];
    
    // 1.获取当前的StoryBoard面板
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    
    // 2.通过标识符找到对应的页面
    XZMineViewController *mineVc = [storyBoard instantiateViewControllerWithIdentifier:@"XZMineViewController"];
    
    // 3.这里以push的方式加载控制
    [self addChildVc:mineVc title:@"我" image:@"我--未点亮" selectedImage:@"我--点亮"];
    
    [self setupTabBar];
    
}


- (void)setupTabBar
{
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
}


- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = XZColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = XZColor(60, 143, 220);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    XZNavigationController *nav = [[XZNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    
}





@end
