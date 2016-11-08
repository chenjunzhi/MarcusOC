//
//  MSAPIBaseManager.m
//  MarcusOC
//
//  Created by marcus on 16/6/27.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSAPIBaseManager.h"
#import "MSNetWorkingManager.h"

@interface MSAPIBaseManager()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) MSAPIManagerErrorType errorType;

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSURLSessionTask *task;
@end

@implementation MSAPIBaseManager

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = nil;
        self.paramSource = nil;
        self.task = nil;
        self.params = nil;
        self.errorType = MSAPIManagerErrorTypeDefault;
        self.responseObject = nil;
    }
    return self;
}

- (void)loadData {
    if (self.paramSource) {
        if ([self.paramSource respondsToSelector:@selector(paramsForApi:)]) {
            self.params = [self.paramSource paramsForApi:self];
        }
    }
    
   __weak __typeof(self)weakSelf = self;
    self.task = [[MSNetWorkingManager sharedManager]callApiWithUrl:self.url params:self.params?:@{} requestType:self.requestType success:^(id responseObject, MSAPIManagerErrorType errorType) {
        if (weakSelf.delegate) {
            if (errorType == MSAPIManagerErrorTypeSuccess) {
                weakSelf.errorType = MSAPIManagerErrorTypeSuccess;
                if ([weakSelf.delegate respondsToSelector:@selector(managerCallAPIDidSuccess:)] ) {
                    weakSelf.responseObject = responseObject;
                    [weakSelf.delegate managerCallAPIDidSuccess:weakSelf];
                    weakSelf.task = nil;
                }
            }else {
                weakSelf.errorType = errorType;
                if ([weakSelf.delegate respondsToSelector:@selector(managerCallAPIDidFailed:)]) {
                    [weakSelf.delegate managerCallAPIDidFailed:weakSelf];
                    weakSelf.task = nil;
                }
            }

        }
    } fail:^(id responseObject, MSAPIManagerErrorType errorType) {
        if (weakSelf.delegate) {
            if ([weakSelf.delegate respondsToSelector:@selector(managerCallAPIDidFailed:)]) {
                [weakSelf.delegate managerCallAPIDidFailed:weakSelf];
                weakSelf.task = nil;
            }
        }
    }];
}

- (void)dealloc {
    [self cancelAllRequest];
}

- (void)cancelAllRequest {
    if (self.task) {
        NSLog(@"取消数据请求 %@",self.task);
        [self.task cancel];
        self.task = nil;
    }
}


@end
