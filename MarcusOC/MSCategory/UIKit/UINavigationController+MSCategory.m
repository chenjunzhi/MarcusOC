//
//  UINavigationController+MSCategory.m
//  MarcusOC
//
//  Created by marcus on 16/7/5.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "UINavigationController+MSCategory.h"

@implementation UINavigationController (MSCategory)

- (id)getTopViewControllerOfClass:(Class)targetClass
{
    UIViewController *currentController = self.topViewController;
    NSArray *stack = [self.viewControllers mutableCopy];
    __block UIViewController *targetController = nil;
    __block BOOL start = NO;
    [stack enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        if (vc == currentController)
        {
            start = YES;
        }
        else if (start)
        {
            if ([vc isKindOfClass:targetClass])
            {
                targetController = vc;
                *stop = YES;
            }
        }
    }];
    return targetController;
}

- (NSArray *)poptoTargetViewControllerOfClass:(Class)targetClass animated:(BOOL)animated
{
    UIViewController *targetVC = [self getTopViewControllerOfClass:targetClass];
    if (targetVC) {
        return [self popToViewController:targetVC animated:animated];
    }
    else
    {
        return nil;
    }
}

- (NSArray *)popPassViewControllerClass:(Class)passClass animated:(BOOL)animated
{
    UIViewController *currentController = self.topViewController;
    NSArray *stack = [self.viewControllers mutableCopy];
    __block UIViewController *targetController = nil;
    __block BOOL start = NO;
    [stack enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        if (vc == currentController)
        {
            start = YES;
        }
        else if (start)
        {
            if (![vc isKindOfClass:passClass])
            {
                targetController = vc;
                *stop = YES;
            }
        }
    }];
    return [self popToViewController:targetController animated:animated];
}

- (NSArray *)popPassViewControllerClasses:(NSArray*)passClasses animated:(BOOL)animated
{
    UIViewController *currentController = self.topViewController;
    NSArray *stack = [self.viewControllers mutableCopy];
    __block UIViewController *targetController = nil;
    __block BOOL start = NO;
    [stack enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        if (vc == currentController)
        {
            start = YES;
        }
        else if (start)
        {
            if (![passClasses containsObject:[vc class]])
            {
                targetController = vc;
                *stop = YES;
            }
        }
    }];
    return [self popToViewController:targetController animated:animated];
    
}


@end
