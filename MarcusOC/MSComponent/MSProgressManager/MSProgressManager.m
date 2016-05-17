//
//  MSProgressManager.m
//  MarcusOC
//
//  Created by marcus on 16/5/16.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSProgressManager.h"
#import "MSHeader.h"
#import "MBProgressHUD.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface MSProgressManager()

@property (nonatomic, weak) MBProgressHUD *hud;

@end

@implementation MSProgressManager

+ (MSProgressManager *)sharedProgressManager
{
    static MSProgressManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MSProgressManager alloc] init];
    });
    return manager;
}

+ (void)showLoading {
    [self showLoadingWithStatus:nil];
}

+ (void)showLoadingWithStatus:(NSString*)status {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示
    [self show:status gifName:@"loading-hu" view:nil];
}

+ (void)showImage:(UIImage*)image status:(NSString*)status {
    [self show:status image:image view:nil];
}

+ (void)hideLoading {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //隐藏
    if ([self sharedProgressManager].hud) {
        [[self sharedProgressManager].hud hide:YES];
    }
}

+ (void)showToastStatus:(NSString *)status {
    [self show:status image:nil view:nil];
}

+ (void)showInfoWithStatus:(NSString*)status{
    [self show:status image:[[UIImage imageNamed:@"checkMark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] view:nil];
}

+ (void)showSuccessWithStatus:(NSString*)status {
    [self show:status image:[[UIImage imageNamed:@"checkMark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] view:nil];

}

+ (void)showErrorWithStatus:(NSString*)status {
    [self show:status image:[[UIImage imageNamed:@"checkMark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] view:nil];
}

+ (void)showProgress:(float)progress mode:(MSProgressMode)mode {
    [self showProgress:progress mode:mode view:nil status:nil];
}

+ (void)showProgress:(float)progress mode:(MSProgressMode)mode status:(NSString*)status {
    [self showProgress:progress mode:mode view:nil status:status];
}


/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param image 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text image:(UIImage *)image view:(UIView *)view
{
    if (!view) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD *hud;
    if (![self sharedProgressManager].hud) {
        [self sharedProgressManager].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud = [self sharedProgressManager].hud;
    hud.labelText = text;
        
    if (image) {
        // 设置图片
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0.0, 0.0, 28.0, 28.0);
        hud.customView = imageView;
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        hud.backgroundColor = color_black_alpha3;
        hud.labelColor = color_black6;
        hud.color = color_white;
        hud.square = NO;
    }else {
        hud.mode = MBProgressHUDModeText;
        hud.backgroundColor = color_clear;
        hud.color = color_black_alpha7;
        hud.labelColor = color_white;
        hud.square = NO;
    }
    // 2秒之后再消失
    [hud hide:YES afterDelay:PROGRESS_HUD_DELAY];
}

/**
 *  显示加载动画
 *
 *  @param text    动画对应的提示文字
 *  @param gifName 动画文件
 *  @param view    显示的视图
 */
+ (void)show:(NSString *)text gifName:(NSString *)gifName view:(UIView *)view {
    if (!view) {
       view = [[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD *hud;
    if (![self sharedProgressManager].hud) {
        [self sharedProgressManager].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud = [self sharedProgressManager].hud;
    // 快速显示一个提示信息
    hud.backgroundColor = [UIColor clearColor];
    hud.userInteractionEnabled = NO;
    hud.labelText = text;
    
    // 设置加载动画
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    
    
    hud.customView = imageView;
    hud.color = [UIColor clearColor];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showProgress:(float)progress mode:(MSProgressMode)mode view:(UIView *)view status:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *tempView = [[UIApplication sharedApplication].windows lastObject];
        MBProgressHUD *hud;
        if (![self sharedProgressManager].hud) {
            [self sharedProgressManager].hud = [MBProgressHUD showHUDAddedTo:tempView animated:YES];
        }
        hud = [self sharedProgressManager].hud;
        MBProgressHUDMode hudMode;
        switch (mode) {
            case MSProgressModePieChart:
                hudMode = MBProgressHUDModeDeterminate;
                break;
            case MSProgressModeHorizontalBar:
                hudMode = MBProgressHUDModeDeterminateHorizontalBar;
                break;
            case MSProgressModeRingShaped:
                hudMode = MBProgressHUDModeAnnularDeterminate;
                break;
            default:
                break;
        }
        hud.mode = hudMode;
        hud.progress = progress;
        hud.color = color_black_alpha1;
        hud.labelColor = color_black3;
        hud.activityIndicatorColor = color_black6;
        if (status && status.length>0) {
            hud.labelText = status;
        }
    });
}


@end
