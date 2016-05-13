//
//  AppDelegate.h
//  marcus
//
//  Created by marcus on 16/5/12.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/**
 *  当前版本是否是第一次运行
 */
@property (assign, nonatomic) BOOL isCurrentVersion;


@end

