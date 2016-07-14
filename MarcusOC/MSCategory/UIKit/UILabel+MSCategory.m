//
//  UILabel+MSCategory.m
//  MarcusOC
//
//  Created by marcus on 16/5/29.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "UILabel+MSCategory.h"

@implementation UILabel (MSCategory)

+ (UILabel *)label:(UILabel *)label font:(UIFont *)font color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment {
    return [self label:label font:font color:color textAlignment:textAlignment text:nil block:nil];
}

+ (UILabel *)label:(UILabel *)label font:(UIFont *)font color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment text:(NSString *)text {
    return [self label:label font:font color:color textAlignment:textAlignment text:text block:nil];
}

+ (UILabel *)label:(UILabel *)label font:(UIFont *)font color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment text:(NSString *)text block:(MSLabelCustomBlock)block {
    if (label) {
        return label;
    }else {
        UILabel *newLabel = [[UILabel alloc]init];
        [newLabel setFont:font];
        [newLabel setTextColor:color];
        [newLabel setTextAlignment:textAlignment];
        if (text) {
            [newLabel setText:text];
        }
        if (block) {
            block(newLabel);
        }
        return newLabel;
    }
}




@end
