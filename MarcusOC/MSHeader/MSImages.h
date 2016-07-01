//
//  MSImages.h
//  marcus
//
//  Created by marcus on 16/5/12.
//  Copyright © 2016年 marcus. All rights reserved.
//  app图片

#ifndef MSImages_h
#define MSImages_h

//image format
#define IMG(name)                                   [UIImage imageNamed:name]

//tabbar 首页 默认图标
#define img_icon_tabbar_home_normal                 IMG(@"icon_tabbar_home_normal")
//tabbar 首页 选中图标
#define img_icon_tabbar_home_selected               IMG(@"icon_tabbar_home_selected")

//tabbar 发现 默认图标
#define img_icon_tabbar_discovery_normal            IMG(@"icon_tabbar_discovery_normal")
//tabbar 发现 有新消息图标
#define img_icon_tabbar_discovery_newMessage        IMG(@"icon_tabbar_discovery_newMessage")
//tabbar 发现 选中图标
#define img_icon_tabbar_discovery_selected          IMG(@"icon_tabbar_discovery_selected")

//tabbar 我的 默认图标
#define img_icon_tabbar_my_normal                   IMG(@"icon_tabbar_my_normal")
//tabbar 我的 选中图标
#define img_icon_tabbar_my_selected                 IMG(@"icon_tabbar_my_selected")

//nav 返回 红色 箭头
#define img_icon_navibar_back_red                   IMG(@"icon_navibar_back_red")
//nav 返回 白色 箭头
#define img_icon_navibar_back_white                 IMG(@"icon_navibar_back_white")

#endif /* MSImages_h */
