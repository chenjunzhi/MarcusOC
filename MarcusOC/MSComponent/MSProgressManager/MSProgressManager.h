//
//  MSProgressManager.h
//  MarcusOC
//
//  Created by marcus on 16/5/16.
//  Copyright © 2016年 marcus. All rights reserved.
/*  基于SVProgressHUD，封装 提示框显示 类

*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSProgressMode) {
    /** 饼状加载进度图*/
    MSProgressModePieChart,
    /** 横向加载进度图 */
    MSProgressModeHorizontalBar,
    /** 环形加载进度图 */
    MSProgressModeRingShaped,
};

@interface MSProgressManager : NSObject
/**
 *  显示正在加载动画,不提示任何状态
 */
+ (void)showLoading;

/**
 *  显示正在加载动画,提示状态
 *
 *  @param status 提示文字
 */
+ (void)showLoadingWithStatus:(NSString*)status;

/**
 *  隐藏正在加载动画
 */
+ (void)hideLoading;

/**
 *  提示信息 无图标仅有提示文字（类似安卓的toast）
 *
 *  @param status 提示内容
 */
+ (void)showToastStatus:(NSString *)status;

/**
 *  显示图片及状态提示
 *
 *  @param image  需要显示的图片
 *  @param status 需要显示的状态
 */
+ (void)showImage:(UIImage*)image status:(NSString*)status;

/**
 *  提示说明信息
 *
 *  @param status 提示文字
 */
+ (void)showInfoWithStatus:(NSString*)status;

/**
 *  提示成功信息
 *
 *  @param status 提示文字
 */
+ (void)showSuccessWithStatus:(NSString*)status;

/**
 *  提示错误信息
 *
 *  @param status 提示文字
 */
+ (void)showErrorWithStatus:(NSString*)status;

/**
 *  显示加载进度
 *
 *  @param progress 加载进度值 （0-1）
 *  @param mode     加载进度显示模式
 */
+ (void)showProgress:(float)progress mode:(MSProgressMode)mode;

/**
 *  显示加载进度(提示信息)
 *
 *  @param progress 加载进度值 （0-1）
 *  @param mode     加载进度显示模式
 *  @param status   提示信息
 */
+ (void)showProgress:(float)progress mode:(MSProgressMode)mode status:(NSString*)status;

/**
 *  显示加载动画
 *
 *  @param text    动画对应的提示文字
 *  @param gifName 动画文件
 *  @param view    显示的视图
 */
+ (void)show:(NSString *)text gifName:(NSString *)gifName view:(UIView *)view;

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param image 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text image:(UIImage *)image view:(UIView *)view;

@end
