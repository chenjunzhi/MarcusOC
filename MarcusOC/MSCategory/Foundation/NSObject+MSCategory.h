//
//  NSObject+MSCategory.h
//  MarcusOC
//
//  Created by marcus on 16/6/30.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MSCategory)

/**
 *  是否为空对象
 *
 *  @return nil/NSNull NSString长度为0 NSArray/NSDictionary count 为0 返回为YES
 */
- (BOOL)isEmptyObject;

@end
