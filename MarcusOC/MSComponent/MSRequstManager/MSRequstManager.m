//
//  MSRequstManager.m
//  Marcus
//
//  Created by marcus on 16/4/27.
//  Copyright (c) 2015年 Marcus. All rights reserved.
//


#import "MSRequstManager.h"
#import "AFNetworking.h"

#ifdef DEBUG
#define __THRequestLog(__Url_, __Type_, __Data_, __Title_) \
NSDateFormatter* formatter = [[NSDateFormatter alloc] init]; \
[formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]]; \
formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss.SSS"; \
fprintf(stderr, "\n------- THRequestManager %s: [%s] -------\n", __Title_, [formatter stringFromDate:[NSDate date]].UTF8String); \
fprintf(stderr, "-- RequestUrl: %s\n", __Url_.UTF8String); \
fprintf(stderr, "-- Method: %s\n", __Type_.UTF8String); \
if ([__Type_ isEqualToString:@"POST"]) {\
    fprintf(stderr, "-- Params: %s\n", [NSString stringWithFormat:@"%@", __Data_].UTF8String); \
}

#define THRequestLog(__Url_, __Type_, __Data_, __ResponseData_, __ResponseTime_)   do { \
__THRequestLog(__Url_, __Type_, __Data_, "LOG") \
if (__ResponseData_) {\
fprintf(stderr, "-- ResponseTime: %s\n", [NSString stringWithFormat:@"%.3f", __ResponseTime_].UTF8String); \
fprintf(stderr, "-- ResponseData: %s\n", [NSString stringWithFormat:@"%@", __ResponseData_].UTF8String); \
} \
} while (0)

#define THRequestError(__Url_, __Type_, __Data_, __ErrorDomain_, __Error_, __ResponseData_)   do { \
__THRequestLog(__Url_, __Type_, __Data_, "ERROR") \
fprintf(stderr, "-- ErrorDomain: %s\n", __ErrorDomain_.UTF8String); \
fprintf(stderr, "-- Error: %s\n", [NSString stringWithFormat:@"%@", __Error_].UTF8String); \
if (__ResponseData_) {\
fprintf(stderr, "-- ResponseData: %s\n", [NSString stringWithFormat:@"%@", __ResponseData_].UTF8String); \
} \
} while (0)

#define THAmbushPointLog(__Url_, __Params_, __Seccuse_) do { \
NSDateFormatter* formatter = [[NSDateFormatter alloc] init]; \
[formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]]; \
formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss.SSS"; \
fprintf(stderr, "\n------- THAmbushPointLog: [%s] -------\n", [formatter stringFromDate:[NSDate date]].UTF8String); \
fprintf(stderr, "-- Params: %s\n", [NSString stringWithFormat:@"%@", __Params_].UTF8String); \
fprintf(stderr, "-- Completion: %s\n", (__Seccuse_ ? @"YES" : @"NO").UTF8String); \
} while (0)

#else
#define THRequestLog(__Url_, __Type_, __Data_, __ResponseData_, __ResponseTime_)
#define THRequestError(__Url_, __Type_, __Data_, __ErrorDomain_, __Error_, __ResponseData_)
#define THAmbushPointLog(__Url_, __Params_, __Seccuse_)
#endif

@interface MSRequstManager ()
{
    double  _lastInternetSpeed; // 记录上一次请求的网速
    NSDate  *_recordDate; // 记录网速的时间
    
    AFHTTPSessionManager        *_sessionManager;  // 通用http会话管理器
    AFHTTPSessionManager        *_ambushPointManager; // 埋点用http会话管理器
}
@end

@implementation MSRequstManager

/**
 *  创建及获取单例对象的方法
 *
 *  @return 管理请求的单例对象
 */
+ (instancetype)sharedManager
{
    static MSRequstManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MSRequstManager alloc] init];
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
    _sessionManager.securityPolicy = [self creatCustomPolicy];
    
    // *** 埋点用会话管理器 ***
    _ambushPointManager = [[AFHTTPSessionManager alloc] init];
    AFHTTPRequestSerializer *ambushPointRequestSerializer = [AFHTTPRequestSerializer serializer];
    [ambushPointRequestSerializer setValue:[NSString stringWithFormat:@"iOS %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"version"];
    _ambushPointManager.requestSerializer = ambushPointRequestSerializer;
}

#pragma mark - Public Methods

- (void)asynGET:(NSString *)url withCompeletBlock:(THURLResponseBlock)complete
{
    [self asynGET:url blockUserInteraction:NO messageDuring:0.8 withCompeletBlock:complete];
}

- (void)asynGET:(NSString *)url blockUserInteraction:(BOOL)block messageDuring:(NSTimeInterval)duration withCompeletBlock:(THURLResponseBlock)complete
{
    if (block)
    {
        [MSProgressManager showLoading];
    }
    [self asynAPIRequest:url params:nil method:@"GET" blockUserInteraction:block messageDuring:duration withCompeletBlock:complete];
}

- (void)asynPOST:(NSString *)url parameters:(NSDictionary *)parameters withCompeletBlock:(THURLResponseBlock)complete
{
    [self asynPOST:url parameters:parameters blockUserInteraction:NO messageDuring:0.8 withCompeletBlock:complete];
}

- (void)asynPOST:(NSString *)url parameters:(NSDictionary *)parameters blockUserInteraction:(BOOL)block messageDuring:(NSTimeInterval)duration withCompeletBlock:(THURLResponseBlock)complete
{
    if (block)
    {
         [MSProgressManager showLoading];
    }
    [self asynAPIRequest:url params:parameters method:@"POST" blockUserInteraction:block messageDuring:duration withCompeletBlock:complete];
}

#pragma mark - Private Methods
/**
 *  异步请求服务器接口，私有方法
 *
 *  @param url      请求的URL(如果包含参数, 则自动编辑进parameters中，会覆盖parameter中的同名参数)
 *  @param params   请求的参数列表
 *  @param method   请求方式：  ‘GET’ or ‘POST’
 *  @param duration 返回信息显示的时间, <= 0 时 不显示信息
 *  @param complete 请求完成后的回调
 */
- (void)asynAPIRequest:(NSString *)url params:(NSDictionary *)params method:(NSString *)method blockUserInteraction:(BOOL)block messageDuring:(NSTimeInterval)duration withCompeletBlock:(THURLResponseBlock)complete
{
    //  创建请求操作对象
    __block NSError *error = nil;
    //  url 长度为0是， 返回错误
    if (url.length == 0)
    {
        error = [NSError errorWithDomain:@"THRequestErrorDomain"
                                     code:MSRequstErrorCodeInvalidURL
                                 userInfo:@{
                                            @"api": url?:@"",
                                            @"param": params?:@"null",
                                            @"description": @"invalid url"
                                            }];
        THRequestError(url, method, params, error.domain, error, nil);
        if (complete) {
            complete(nil, MSRequstErrorCodeInvalidURL, error);
        }
        return;
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
        
        if (block) [MSProgressManager showLoading];
        NSInteger code = [responseObject[@"Code"] integerValue];
        
        // 清理数据中的 nsnull 对象
        responseObject = [responseObject dictionaryWithCleanNSNullValue];
        
        THRequestLog([task.currentRequest.URL.absoluteString stringByRemovingPercentEncoding], method, [self formatParametersForURL:url withParams:params], responseObject, interval);

        if (!responseObject || (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]])) // 若解析数据格式异常，返回错误
        {
            if (duration > 0)
            {
                [MSProgressManager showToastStatus:@"数据异常，请稍后重试或重启应用"];
            }
            error = [NSError errorWithDomain:@"THRequestErrorDomain"
                                        code:MSRequstErrorCodeInvalidResponse
                                    userInfo:@{
                                               @"api": url?:@"",
                                               @"param": params?:@"null",
                                               @"description": @"invalid response"
                                               }];
            if (complete)
            {
                complete(responseObject, MSRequstErrorCodeInvalidResponse, error);
            }
        }
        else // 若解析数据正常，判断API返回的code，
        {
            if (code == 0)
            {
                NSString *message = responseObject[@"Message"];
                if (message.length && duration > 0)
                {
                    [MSProgressManager showToastStatus:message];
                }
                error = [NSError errorWithDomain:@"THRequestErrorDomain"
                                            code:MSRequstErrorCodeAPIError
                                        userInfo:@{
                                                   @"api": url?:@"",
                                                   @"param": params?:@"null",
                                                   @"description": message?:@"no message"
                                                   }];
            }
            if (complete)
            {
                complete(responseObject, code, error);
            }
        }
    };
    
    // 请求失败时的回调
    void (^failureWrap)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 计算网速
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_recordDate];
        _lastInternetSpeed = (double)task.countOfBytesReceived / (NSInteger)(interval * 1000);
        
        if (block) [MSProgressManager showLoading];
        if (duration > 0)
        {
            [MSProgressManager showToastStatus:@"数据异常，请稍后重试或重启应用"];
        }
        THRequestError([task.currentRequest.URL.absoluteString stringByRemovingPercentEncoding], method, [self formatParametersForURL:url withParams:params], error.domain, error, nil);
        if (complete)
        {
            complete(nil, MSRequstErrorCodeConnectionError, error);
        }
    };
    
    // 设置请求头
    [self formatRequestHeader];
    
    if (block) [MSProgressManager showLoading];
    
    //    如果是POST请求，分离URL中的参数信息, 重建参数列表
    if ([method isEqualToString:@"POST"])
    {
        params = [self formatParametersForURL:url withParams:params];
        url = [url componentsSeparatedByString:@"?"][0];
        
        // 检查url
        if (![NSURL URLWithString:url]) {
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        
        THRequestLog(url, method, params, nil, 0.f);

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
        
        [_sessionManager POST:url
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
        THRequestLog(url, method, params, nil, 0.f);

        // 检查url
        if (![NSURL URLWithString:url]) {
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }

        [_sessionManager GET:url
                  parameters:params
                    progress:nil
                     success:successWrap
                     failure:failureWrap];
    }
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
    [_sessionManager.requestSerializer setValue: (_recordDate && [[NSDate date] timeIntervalSinceDate:_recordDate] <= 3*60)? [NSString stringWithFormat:@"%.3f", _lastInternetSpeed]: @"-1.00" forHTTPHeaderField:@"InternetSpeed"];
}

@end

@implementation MSRequstManager (TNAmbushPoint)

- (void)postAmbushPoint:(NSString *)urlString parameters:(NSDictionary *)parameters
{
    if (!urlString || !parameters)
    {
        return;
    }
    [_ambushPointManager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        THAmbushPointLog(urlString, parameters, YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        THAmbushPointLog(urlString, parameters, NO);
    }];
}

@end

