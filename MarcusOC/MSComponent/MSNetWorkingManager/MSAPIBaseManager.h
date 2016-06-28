//
//  MSAPIBaseManager.h
//  MarcusOC
//
//  Created by marcus on 16/6/27.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSNetWorkingManager.h"
#import "MSHeader.h"

@class MSAPIBaseManager;

//让manager能够获取调用API所需要的数据
@protocol MSAPIManagerParamSourceDelegate <NSObject>
@required
- (NSDictionary *)paramsForApi:(MSAPIBaseManager *)manager;
@end

//api回调
@protocol MSAPIManagerApiCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(MSAPIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(MSAPIBaseManager *)manager;
@end


@interface MSAPIBaseManager : NSObject
/****************************************入参*********************************************************/
/**
 *  网络请求url (可拼接参数，但不建议)
 *  不建议拼接请求参数，请求参数建议通过 MSAPIManagerParamSourceDelegate 赋值
 *  如果拼接了参数，同样的参数在MSAPIManagerParamSourceDelegate也赋值了，则会取MSAPIManagerParamSourceDelegate里的值
 */
@property (nonatomic, strong) NSString *url;
/**
 *  网络请求类型
 */
@property (nonatomic, assign) MSAPIManagerRequestType requestType;

/**
 *  请求回调delegate
 */
@property (nonatomic, weak) id<MSAPIManagerApiCallBackDelegate> delegate;
/**
 *  请求参数delegate
 */
@property (nonatomic, weak) id<MSAPIManagerParamSourceDelegate> paramSource;
/***************************************入参**********************************************************/

/*
 baseManager是不会去设置errorMessage的，派生的子类manager可能需要给controller提供错误信息。所以为了统一外部调用的入口，设置了这个变量。
 派生的子类需要通过extension来在保证errorMessage在对外只读的情况下使派生的manager子类对errorMessage具有写权限。 .m文件定义为可读写
 */
@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, readonly) MSAPIManagerErrorType errorType;
@property (nonatomic, strong) id responseObject;

//尽量使用loadData这个方法,这个方法会通过param source来获得参数，这使得参数的生成逻辑位于controller中的固定位置
- (void)loadData;

- (void)cancelAllRequest;

@end
