//
//  NSString+MSCategory.h
//  marcus
//
//  Created by marcus on 16/4/27.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * NSStringCheckPhoneNumberLevelAccurate,  // 精确匹配手机号
 * NSStringCheckPhoneNumberLevelRough,     // 粗略匹配手机号，满足 1xxxxxxxxxxxx即可
 * NSStringCheckPhoneNumberLevelLandline,  // 匹配固定电话，
 */
typedef enum : NSUInteger {
    NSStringCheckPhoneNumberLevelAccurate,
    NSStringCheckPhoneNumberLevelRough,
    NSStringCheckPhoneNumberLevelLandline,
} NSStringCheckPhoneNumberLevel;

@interface NSString (MSCategory)

/**
 *  验证电话号码
 *
 *  @param level 匹配规则
 *
 *  @return 是否符合要求
 */
- (BOOL)isValidatePhoneNumberWithLevel:(NSStringCheckPhoneNumberLevel)level;

/**
 *  对字符串进行MD5加密
 *
 *  @return MD5加密后的字符串
 */
- (NSString *)encryptUseMD5;

/**
 *  将字符串转为16进制整数
 *
 *  @return 转换后的16进制整数
 */
- (NSInteger)hexIntegerValue;

/**
 *  DES 加密
 *
 *  @param key 加密解密的key
 *
 *  @return 经过DES加密后字符串
 */
- (NSString *)encryptUseDESWithKey:(NSString *)key;

/**
 *  DES 解密
 *
 *  @param key 加密解密的key
 *
 *  @return 解密后的字符串
 */
- (NSString *)decryptUseDESWithKey:(NSString *)key;

/**
 *  文本数据转成16进制字符串
 *
 *  @param data 待转换的文本数据
 *
 *  @return 16进制的字符串
 */
+ (NSString *)convertDataToHexStr:(NSData *)data;

/**
 *  16进制字符串转为文本数据
 *
 *  @param str 16进制的字符串
 *
 *  @return 待转换的文本数据
 */
+ (NSData *)convertHexStrToData:(NSString *)str;

@end
