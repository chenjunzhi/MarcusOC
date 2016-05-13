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

//tabBarItem 默认 文字颜色
#define color_tabBar_text_normal              RGB(249, 249, 249)      //HexColor(@"#f9f9f9")
//tabBarItem 选中 文字颜色
#define color_tabBar_text_selected            RGB(252, 86, 86)        //HexColor(@"#fc5656")


#endif /* MSColors_h */
