//
//  MSBaseViewController.m
//  MarcusOC
//
//  Created by marcus on 16/6/30.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSBaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

typedef NS_ENUM(NSInteger, MSViewControllerState) {
    MSViewControllerStateNone = 0,
    MSViewControllerStateWillAppear,
    MSViewControllerStateDidAppear,
    MSViewControllerStateWillDisappear,
    MSViewControllerStateDidDisappear,
};

@interface MSBaseViewController ()

@property (nonatomic) BOOL firstAppeared;

@property (nonatomic) MSViewControllerState state;


@end

@implementation MSBaseViewController

#pragma mark - view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化 默认值
    self.firstAppeared = YES;
    self.navigationBarHidden = NO;
    self.tabBarHidden = YES;
    self.navigationBarColor = color_navBar_Tint;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: color_white,
                                                                    NSFontAttributeName: [UIFont boldSystemFontOfSize:18]};
    self.state = MSViewControllerStateNone;    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if (self.state == MSViewControllerStateWillAppear || self.state == MSViewControllerStateDidAppear) {
//        return;
//    }
//    self.state = MSViewControllerStateWillAppear;
    
    if (self.navigationController.navigationBarHidden != self.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:self.isNavigationBarHidden animated:animated];
    }
    
    if (self.tabBarController.tabBar.hidden != self.isTabBarHidden) {
        self.tabBarController.tabBar.hidden = self.isTabBarHidden;
    }
    
    if (self.navigationBarColor) {
        if ([UIDevice currentDevice].majorSystemVersion < 7) {
            self.navigationController.navigationBar.tintColor = self.navigationBarColor;
        } else {
            self.navigationController.navigationBar.barTintColor = self.navigationBarColor;
        }
    } else {
        if ([UIDevice currentDevice].majorSystemVersion < 7) {
            self.navigationController.navigationBar.tintColor = [UINavigationBar appearance].tintColor;
        }
    }
    
    if (self.firstAppeared) {
        [self viewWillFirstAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (self.state == MSViewControllerStateDidAppear) {
//        return;
//    }
//    self.state = MSViewControllerStateDidAppear;
    
    if (self.firstAppeared) {
        self.firstAppeared = NO;
        [self viewDidFirstAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    if (self.state == MSViewControllerStateNone || self.state == MSViewControllerStateDidDisappear || self.state == MSViewControllerStateWillDisappear) {
//        return;
//    }
//    self.state = MSViewControllerStateWillDisappear;
    
    if (self.navigationBarColor) {
        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            self.navigationController.navigationBar.barTintColor = [UINavigationBar appearance].barTintColor;
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    if (self.state == MSViewControllerStateNone || self.state == MSViewControllerStateDidDisappear) {
//        return;
//    }
//    self.state = MSViewControllerStateDidDisappear;
}


- (void)viewWillFirstAppear:(BOOL)animated {
}

- (void)viewDidFirstAppear:(BOOL)animated{
}

#pragma mark - event response
- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarAction:(UIBarButtonItem *)sender {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    _navigationBarHidden = navigationBarHidden;
    if ([self respondsToSelector:@selector(setFd_prefersNavigationBarHidden:)])
    {
        self.fd_prefersNavigationBarHidden = navigationBarHidden;
    }
}


- (void)createLeftBarItemWithImage {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:img_icon_navibar_back_white style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
    backButton.tintColor = color_navBarItem_Tint;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)createRightBarBarItemWithTitle:(NSString *)title Image:(UIImage *)image {
    UIBarButtonItem* rightBarButton;
    if (![title isEmptyObject]) {
        rightBarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)];
    }
    if (!image) {
        rightBarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)];
    }
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

@end
