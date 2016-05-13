//
//  NSArray+MSCategory.m
//  marcus
//
//  Created by marcus on 16/4/27.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "NSArray+MSCategory.h"
#import "MSFoundation.h"

@implementation NSArray (MSCategory)

- (NSArray *)arrayWithCleanNSNullValue
{
    NSMutableArray* newArr = [@[] mutableCopy];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSNull class]])
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                [newArr addObject:[obj dictionaryWithCleanNSNullValue]];
            }
            else if ([obj isKindOfClass:[NSArray class]])
            {
                [newArr addObject:[obj arrayWithCleanNSNullValue]];
            }
            else if ([obj isKindOfClass:[NSSet class]])
            {
                [newArr addObject:[obj setWithCleanNSNullValue]];
            }
            else
            {
                [newArr addObject:obj];
            }
        }
    }];
    return [NSArray arrayWithArray:newArr];
}

@end
