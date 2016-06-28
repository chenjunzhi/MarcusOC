//
//  MSNetWorkingManager.h
//  MarcusOC
//
//  Created by marcus on 16/6/27.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSHeader.h"

typedef void(^MSCallback)(id responseObject, MSAPIManagerErrorType errorType);

@interface MSNetWorkingManager : NSObject

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)callApiWithUrl:(NSString *)url params:(NSDictionary *)params requestType:(MSAPIManagerRequestType)requestType success:(MSCallback)success fail:(MSCallback)fail;

@end
