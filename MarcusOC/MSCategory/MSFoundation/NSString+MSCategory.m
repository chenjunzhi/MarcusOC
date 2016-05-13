//
//  NSString+MSCategory.m
//  marcus
//
//  Created by marcus on 16/4/27.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "NSString+MSCategory.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (MSCategory)

// 验证是否为手机号
- (BOOL)isValidatePhoneNumberWithLevel:(NSStringCheckPhoneNumberLevel)level;
{
    /**
     * 手机号码
     * 移动：134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188
     * 联通：130 131 132 145 155 156 176 185 186
     * 电信：133 153 177 180 181 189
     * 虚拟运营商：170
     */
    NSString * MOBILE = @"^(0|86|\\+86)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029, 4位区号
     * 号码：七位或八位
     */
    NSString * PHS = @"^(0(10|2[0-5789]|\\d{3}))?([-|\\s])?\\d{7,8}$";
    /**
     *  11位手机号匹配，满足首位是1即可
     */
    NSString *C11 = @"^(0|86|\\+86)?1([3-9])\\d{9}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestlandline = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestrough = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",C11];
    
    switch (level)
    {
        case NSStringCheckPhoneNumberLevelAccurate:
        {
            return [regextestmobile evaluateWithObject:self];
        }
        case NSStringCheckPhoneNumberLevelRough:
        {
            return [regextestrough evaluateWithObject:self];
        }
        case NSStringCheckPhoneNumberLevelLandline:
        {
            return [regextestlandline evaluateWithObject:self];
        }
        default:
            return NO;
    }
}

- (NSString *)encryptUseMD5
{
    const char * cString = self.UTF8String;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cString, (CC_LONG)strlen(cString), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}

- (NSInteger)hexIntegerValue
{
    NSString *temp = [self lowercaseString];
    __block NSInteger value = 0;
    __block NSInteger  negativeSign = 1;
    [temp enumerateSubstringsInRange:NSMakeRange(0, temp.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if (substringRange.location == 0 && [substring isEqualToString:@"-"])
        {
            negativeSign = -1;
        }
        else if ([@"abcdef0123456789" rangeOfString:substring].length)
        {
            value *= 16;
            if ([substring isEqualToString:@"a"])
            {
                value += 10;
            }
            else if ([substring isEqualToString:@"b"])
            {
                value +=11;
            }
            else if ([substring isEqualToString:@"c"])
            {
                value +=12;
            }
            else if ([substring isEqualToString:@"d"])
            {
                value +=13;
            }
            else if ([substring isEqualToString:@"e"])
            {
                value +=14;
            }
            else if ([substring isEqualToString:@"f"])
            {
                value +=15;
            }
            else
            {
                value += substring.integerValue;
            }
        }
        else
        {
            *stop = YES;
        }
    }];
    return value*negativeSign;
}

- (NSString *)encryptUseDESWithKey:(NSString *)key {
    NSString *ciphertext = nil;
    NSData *textData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          nil,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;
    }
    
    return ciphertext;
}

- (NSString *)decryptUseDESWithKey:(NSString *)key {
    NSString *plaintext = nil;
    NSData *cipherdata = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          nil,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    
    return plaintext;
}

+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


@end
