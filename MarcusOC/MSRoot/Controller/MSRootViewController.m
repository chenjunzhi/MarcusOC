//
//  MSRootViewController.m
//  MarcusOC
//
//  Created by marcus on 16/5/13.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSRootViewController.h"
#import "MSHeader.h"
#import "MSHomeViewController.h"
#import "MSDiscoveryViewController.h"
#import "MSMyViewController.h"

@interface MSRootViewController ()<UITabBarControllerDelegate>

@end

@implementation MSRootViewController

#pragma mark - view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - private method
//加载tabbar上的ViewController
- (void)loadSubView {
    //首页
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:[[MSHomeViewController alloc] init]];
    //发现
    UINavigationController *discoveryNav = [[UINavigationController alloc]initWithRootViewController:[[MSDiscoveryViewController alloc] init]];
    //我的
    UINavigationController *myNav = [[UINavigationController alloc]initWithRootViewController:[[MSMyViewController alloc] init]];
    
    self.viewControllers = @[homeNav,discoveryNav,myNav];
    
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];
    
    [self tabBarItem:tabBarItem0 title:NSLocalizedString(@"tabBarHome", nil) image:img_icon_tabbar_home_normal selectedImage:img_icon_tabbar_home_selected];
    [self tabBarItem:tabBarItem1 title:NSLocalizedString(@"tabBarDiscovery", nil) image:img_icon_tabbar_discovery_normal selectedImage:img_icon_tabbar_discovery_selected];
    [self tabBarItem:tabBarItem2 title:NSLocalizedString(@"tabBarMy", nil) image:img_icon_tabbar_my_normal selectedImage:img_icon_tabbar_my_selected];
    
    self.tabBar.backgroundColor = color_tabBar_text_normal;
    self.tabBar.tintColor = color_tabBar_text_selected;
    
    self.selectedIndex = 0;

}



#pragma mark - UITabBarControllerDelegate
/**
 *  设置tabBarItem相关属性
 *
 *  @param tabBarItem    需要设置的tabBarItem
 *  @param title         tabBarItem 标题
 *  @param image         tabBarItem 默认图
 *  @param selectedImage tabBarItem 选中图
 */
- (void)tabBarItem:(UITabBarItem *)tabBarItem title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    tabBarItem.title = title;
    tabBarItem.image = image;
    tabBarItem.selectedImage = selectedImage;
}

@end
