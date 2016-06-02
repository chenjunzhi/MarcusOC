//
//  UILabel+MSCategory.h
//  MarcusOC
//
//  Created by marcus on 16/5/29.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MSLabelCustomBlock)(UILabel *);

@interface UILabel (MSCategory)

+ (UILabel *)label:(UILabel *)label font:(UIFont *)font color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;

+ (UILabel *)label:(UILabel *)label font:(UIFont *)font color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment text:(NSString *)text;

+ (UILabel *)label:(UILabel *)label font:(UIFont *)font color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment text:(NSString *)text block:(MSLabelCustomBlock)block;

@end
