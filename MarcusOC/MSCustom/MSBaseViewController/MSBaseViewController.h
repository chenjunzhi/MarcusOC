//
//  MSBaseViewController.h
//  MarcusOC
//
//  Created by marcus on 16/6/30.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSHeader.h"

@interface MSBaseViewController : UIViewController
/**
 *  navigationBar 是否隐藏 默认显示 (NO)
 */
@property (nonatomic, getter = isNavigationBarHidden) BOOL navigationBarHidden;
/**
 *  tabBar 是否隐藏 默认隐藏 (YES)
 */
@property (nonatomic, getter = isTabBarHidden) BOOL tabBarHidden;
/**
 *  navigationBar 颜色
 */
@property (nonatomic, strong) UIColor *navigationBarColor;

/**
 *  控制器第一次即将显示时调用
 *
 *  @param animated 是否显示动画
 */
- (void)viewWillFirstAppear:(BOOL)animated;

/**
 *  控制器第一次 已经显示时调用
 *
 *  @param animated 是否显示动画
 */
- (void)viewDidFirstAppear:(BOOL)animated;

/**
 *  创建左侧返回按钮
 */
- (void)createLeftBarItemWithImage;

/**
 *  创建右侧按钮 按钮 名称 或者 图片
 */
- (void)createRightBarBarItemWithTitle:(NSString *)title Image:(UIImage *)image;
@end
