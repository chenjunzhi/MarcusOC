//
//  MSNetWorkingManager.m
//  MarcusOC
//
//  Created by marcus on 16/6/27.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSNetWorkingManager.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPSessionManager.h"
#import "AFURLResponseSerialization.h"
#import "MSHeader.h"

@interface MSNetWorkingManager()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;   //通用会话管理器
@property (nonatomic, assign) double lastInternetSpeed; // 记录上一次请求的网速
@property (nonatomic, strong) NSDate *recordDate; // 记录网速的时间

@end

@implementation MSNetWorkingManager

/**
 *  创建及获取单例对象的方法
 *
 *  @return 管理请求的单例对象
 */
+ (instancetype)sharedManager
{
    static MSNetWorkingManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MSNetWorkingManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self initSessionManager];
    }
    return self;
}

- (void)initSessionManager
{
    //  *** 通用请求会话管理器 ***
    
    // 设置全局会话管理实例
    _sessionManager = [[AFHTTPSessionManager alloc] init];
    
    // 设置请求序列化器
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy; // 默认缓存策略
    requestSerializer.timeoutInterval = 30;
    [requestSerializer setValue:[NSString stringWithFormat:@"iOS %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"version"];
    //    [requestSerializer setValue:[SvUDIDTools UDID] forHTTPHeaderField:@"DeviceID"];
    //    [requestSerializer setValue:[TNAppContext currentContext].black_box?:@"" forHTTPHeaderField:@"black_box"];
    _sessionManager.requestSerializer = requestSerializer;
    
    // 设置响应序列化器，解析Json对象
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    responseSerializer.removesKeysWithNullValues = YES; // 清除返回数据的 NSNull
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/x-javascript", @"application/json", @"text/json", @"text/javascript", @"text/html", nil]; // 设置接受数据的格式
    _sessionManager.responseSerializer = responseSerializer;
    
    // 设置安全策略
    self.sessionManager.securityPolicy = [self creatCustomPolicy];
}

- (NSURLSessionDataTask *)callApiWithUrl:(NSString *)url params:(NSDictionary *)params requestType:(MSAPIManagerRequestType)requestType success:(MSCallback)success fail:(MSCallback)fail {
    //  url 长度为0是， 返回错误
    if ( !url || url.length == 0)
    {
        if (fail) {
            fail(nil,MSAPIManagerErrorTypeInvalidURL);
        }
        return nil;
    }
    // 会话管理对象为空时
    if (!_sessionManager)
    {
        [self initSessionManager];
    }
    
    // 记录请求发送前的时间，用于计算网速
    _recordDate = [NSDate date];
    
    // 请求成功时的回调
    void (^successWrap)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 计算网速
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_recordDate];
        _lastInternetSpeed = (double)task.countOfBytesReceived / (NSInteger)(interval * 1000);
        
        // 清理数据中的 nsnull 对象
        responseObject = [responseObject dictionaryWithCleanNSNullValue];
        
        //        THRequestLog([task.currentRequest.URL.absoluteString stringByRemovingPercentEncoding], method, [self formatParametersForURL:url withParams:params], responseObject, interval);
        
        if (!responseObject || (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]])) // 若解析数据格式异常，返回错误
        {
            if (fail)
            {
                fail(nil,MSAPIManagerErrorTypeNoContent);
            }
        }
        else // 若解析数据正常，判断API返回的code，
        {
            if (success) {
                success(responseObject,MSAPIManagerErrorTypeSuccess);
            }
        }
    };
    
    // 请求失败时的回调
    void (^failureWrap)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 计算网速
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_recordDate];
        _lastInternetSpeed = (double)task.countOfBytesReceived / (NSInteger)(interval * 1000);
        
        if (fail) {
            fail(nil,MSAPIManagerErrorTypeTimeout);
        }
    };
    
    // 设置请求头
    [self formatRequestHeader];
    
    //  分离URL中的参数信息, 重建参数列表
    params = [self formatParametersForURL:url withParams:params];
    url = [url componentsSeparatedByString:@"?"][0];
    NSURLSessionDataTask * urlSessionDataTask;
    
    if (requestType == MSAPIManagerRequestTypePost)
    {
        // 检查url
        if (![NSURL URLWithString:url]) {
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        
        // POST请求时，分离参数中的字符串参数和文件数据
        NSMutableDictionary *values = [params mutableCopy]; // 保存 字符串参数
        NSMutableDictionary *files = [@{} mutableCopy]; // 保存 文件数据
        [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            // 类型为 NSData 或者 UIImage 时，从参数列表中删除，添加至文件列表，并将UIImage对象转化为NSData类型
            if ([obj isKindOfClass:[NSData class]] || [obj isKindOfClass:[UIImage class]])
            {
                [values removeObjectForKey:key];
                [files setObject:[obj isKindOfClass:[UIImage class]]? UIImageJPEGRepresentation(obj, 0.3): obj forKey:key];
            }
        }];
        
       urlSessionDataTask = [_sessionManager POST:url
                   parameters:values
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 将文件列表中的数据逐个添加到请求对象中
        [files enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSData *obj, BOOL *stop) {
            [formData appendPartWithFileData:obj name:key fileName:[NSString stringWithFormat:@"%@.jpg", key] mimeType:@"image/jpg"];
        }];
    }
                     progress:nil
                      success:successWrap
                      failure:failureWrap];
    }
    else
    {
        // 检查url
        if (![NSURL URLWithString:url]) {
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        
      urlSessionDataTask = [_sessionManager GET:url
                  parameters:params
                    progress:nil
                     success:successWrap
                     failure:failureWrap];
    }
    return urlSessionDataTask;
}

#pragma mark creat request methods
- (AFSecurityPolicy *)creatCustomPolicy
{
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    policy.allowInvalidCertificates = NO;
    return policy;
}

- (NSDictionary *)formatParametersForURL:(NSString *)url withParams:(NSDictionary *)params
{
    //    清除参数中的NSNull对象
    NSMutableDictionary *fixedParams = [(params? [params dictionaryWithCleanNSNullValue]: @{}) mutableCopy];
    
    //    分离URL中的参数信息
    NSArray *urlComponents = [[url stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@"?"];
    NSArray *paramsComponets = urlComponents.count >= 2 && [urlComponents[1] length] > 0 ? [urlComponents[1] componentsSeparatedByString:@"&"] : nil;
    [paramsComponets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *paramComponets = [obj componentsSeparatedByString:@"="];
        if (!fixedParams[paramsComponets[0]])
        {
            [fixedParams setObject:(paramComponets.count>=2 ? paramComponets[1] : @"") forKey:paramComponets[0]];
        }
    }];
    
    //    检查param的个数，为0时，置为nil
    fixedParams = fixedParams.allKeys.count ? fixedParams : nil;
    return [fixedParams copy];
}

- (void)formatRequestHeader
{
    NSString *usersession = [[NSUserDefaults standardUserDefaults] valueForKey:@"usersession"];
    [_sessionManager.requestSerializer setValue:usersession?:@"0" forHTTPHeaderField:@"usersession"];
    
    /* ADD 2016-01-07 检测网络类型 和 网速 */
    //    [_sessionManager.requestSerializer setValue:[TNUtils getNetWorkStates] forHTTPHeaderField:@"InternetType"];
    [self.sessionManager.requestSerializer setValue: (self.recordDate && [[NSDate date] timeIntervalSinceDate:self.recordDate] <= 3*60)? [NSString stringWithFormat:@"%.3f", _lastInternetSpeed]: @"-1.00" forHTTPHeaderField:@"InternetSpeed"];
}

@end
