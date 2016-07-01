//
//  UIDevice+MSCategory.h
//  MarcusOC
//
//  Created by marcus on 16/6/30.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (MSCategory)
/**
 *  系统版本 例如：9
 *
 *  @return 系统大版本的值： 例如 9
 */
- (int)majorSystemVersion;

- (NSString *)carrierName;

- (NSString *)macAddress;

- (NSString *)fullModel;

- (NSString *)machineName;

+ (BOOL)isIphone4;

+ (BOOL)isIphone5;

@end
