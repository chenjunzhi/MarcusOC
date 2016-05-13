//
//  NSDictionary+MSCategory.m
//  marcus
//
//  Created by marcus on 16/4/27.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "NSDictionary+MSCategory.h"
#import "MSFoundation.h"

@implementation NSDictionary (MSCategory)

- (NSDictionary *)dictionaryWithCleanNSNullValue
{
    NSMutableDictionary* newDic = [@{} mutableCopy];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSNull class]])
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                [newDic setObject:[obj dictionaryWithCleanNSNullValue] forKey:key];
            }
            else if ([obj isKindOfClass:[NSArray class]])
            {
                [newDic setObject:[obj arrayWithCleanNSNullValue] forKey:key];
            }
            else if ([obj isKindOfClass:[NSSet class]])
            {
                [newDic setObject:[obj setWithCleanNSNullValue] forKey:key];
            }
            else
            {
                [newDic setObject:obj forKey:key];
            }
        }
    }];
    return newDic;
}

@end
