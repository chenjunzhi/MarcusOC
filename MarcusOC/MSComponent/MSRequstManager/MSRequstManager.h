//
//  MSRequstManager.h
//  Marcus
//
//  Created by marcus on 16/4/27.
//  Copyright (c) 2015年 marcus. All rights reserved.
//
//****************************************************************************************
//  网络请求 管理类， 封装同步和异步的请求方法，做统一的异常处理，和请求头等通用编辑
//****************************************************************************************
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MSRequstErrorCodeNoneError = 1,                       // 请求成功
    MSRequstErrorCodeAPIError = 0,                        // 请求失败，API返回失败信息
    MSRequstErrorCodeInvalidURL = 1000,                   // 请求失败， 无效的URL
    MSRequstErrorCodeInvalidResponse = 1001,              // 请求失败， 无效的返回数据
    MSRequstErrorCodeConnectionError = 1002,              // 请求失败， 链接错误
} MSRequstErrorCode;

// 请求方法的回调Block类型
typedef void(^THURLResponseBlock)(id __nullable responseObject, MSRequstErrorCode code, NSError * __nullable error);

@interface MSRequstManager : NSObject

// 获取单例的方法
+ (nonnull instancetype)sharedManager;

#pragma mark 异步GET请求
/**
 *  异步GET请求， 默认不阻断用户操作，返回信息显示0.8秒
 *
 *  @param url        请求的URL
 *  @param complete   请求完成后的回调Block，请求成功时，error为nil，responseObject为json对象，code为API返回的状态； 请求失败时，error不为nil，responseObject为nil，code为0
 */
- (void)asynGET:(nonnull NSString *)url withCompeletBlock:(nullable THURLResponseBlock)complete;
/**
 *  异步GET请求，可设置是否阻断用户操作，以及返回的信息显示多长时间
 *
 *  @param url      请求的URL
 *  @param block    是否阻断用户操作
 *  @param duration 返回信息显示的时间, <= 0 时 不显示信息
 *  @param complete 请求完成后的回调Block，请求成功时，error为nil，responsObject为json对象，code为API返回的状态； 请求失败时，error不为nil，responseObject为nil，code为0
 */
- (void)asynGET:(nonnull NSString *)url blockUserInteraction:(BOOL)block messageDuring:(NSTimeInterval)duration withCompeletBlock:(nullable THURLResponseBlock)complete;
#pragma mark 异步POST请求(上传文件或图片可用)
/**
 *  异步POST请求， 默认不阻断用户操作，返回信息显示0.8秒
 *
 *  @param url        请求的URL(如果包含参数, 则自动编辑进parameters中，会覆盖parameter中的同名参数)
 *  @param parameters post的参数列表
 *  @param complete   请求完成后的回调Block，请求成功时，error为nil，responseObject为json对象，code为API返回的状态； 请求失败时，error不为nil，responseObject为nil，code为0
 */
- (void)asynPOST:(nonnull NSString *)url parameters:(nullable NSDictionary *)parameters withCompeletBlock:(nullable THURLResponseBlock)complete;
/**
 *  异步POST请求， 默认不阻断用户操作，返回信息显示0.8秒
 *
 *  @param url        请求的URL(如果包含参数, 则自动编辑进parameters中，会覆盖parameter中的同名参数)
 *  @param parameters post的参数列表
 *  @param block    是否阻断用户操作
 *  @param duration 返回信息显示的时间, <= 0 时 不显示信息
 *  @param complete   请求完成后的回调Block，请求成功时，error为nil，responseObject为json对象，code为API返回的状态； 请求失败时，error不为nil，responseObject为nil，code为0
 */
- (void)asynPOST:(nonnull NSString *)url parameters:(nullable NSDictionary *)parameters blockUserInteraction:(BOOL)block messageDuring:(NSTimeInterval)duration withCompeletBlock:(nullable THURLResponseBlock)complete;

@end
