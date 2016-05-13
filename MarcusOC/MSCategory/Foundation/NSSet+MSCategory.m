//
//  NSSet+MSCategory.m
//  marcus
//
//  Created by marcus on 16/4/27.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "NSSet+MSCategory.h"
#import "MSFoundation.h"

@implementation NSSet (MSCategory)

- (NSSet *)setWithCleanNSNullValue
{
    NSMutableSet* newSet = [NSMutableSet set];
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSNull class]])
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                [newSet addObject:[obj dictionaryWithCleanNSNullValue]];
            }
            else if ([obj isKindOfClass:[NSArray class]])
            {
                [newSet addObject:[obj arrayWithCleanNSNullValue]];
            }
            else if ([obj isKindOfClass:[NSArray class]])
            {
                [newSet addObject:[obj setWithCleanNSNullValue]];
            }
            else
            {
                [newSet addObject:obj];
            }
        }
    }];
    return newSet;
}

@end
