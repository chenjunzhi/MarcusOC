//
//  MSColors.h
//  marcus
//
//  Created by marcus on 16/5/12.
//  Copyright © 2016年 marcus. All rights reserved.
//  app颜色值

#ifndef MSColors_h
#define MSColors_h

//color format
#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//tabBar 默认 背景颜色
#define color_tabBar_background_normal              RGB(249, 249, 249)      //HexColor(@"#f9f9f9")
//tabBar 选中 背景颜色
#define color_tabBar_background_selected            RGB(252, 86, 86)        //HexColor(@"#fc5656")

//纯白色 不透明
#define color_white                                 RGB(255,255,255)        //HexColor(@"FFFFFF")
//纯黑色 不透明
#define color_black                                 RGB(0,0,0)              //HexColor(@"000000")
//纯黑色 透明度为0.7
#define color_black_alpha7                          RGBA(0,0,0,0.7)         //HexColor(@"000000")
//纯黑色 透明度为0.3
#define color_black_alpha3                          RGBA(0,0,0,0.3)         //HexColor(@"000000")
//纯黑色 透明度为0.1
#define color_black_alpha1                          RGBA(0,0,0,0.1)         //HexColor(@"000000")
//黑色
#define color_black3                                RGB(51,51,51)           //HexColor(@"333333")
//黑色
#define color_black6                                RGB(102,102,102)        //HexColor(@"666666")
//黑色
#define color_black9                                RGB(153,153,153)       //HexColor(@"999999")
//无色
#define color_clear                                 [UIColor clearColor]

#endif /* MSColors_h */
