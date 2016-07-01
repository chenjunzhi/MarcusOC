//
//  NSObject+MSCategory.m
//  MarcusOC
//
//  Created by marcus on 16/6/30.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "NSObject+MSCategory.h"

@implementation NSObject (MSCategory)

- (BOOL)isEmptyObject
{
    if (self == nil) {
        return YES;
    }
    
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
