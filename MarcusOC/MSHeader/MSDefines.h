//
//  MSDefine.h
//  marcus
//
//  Created by marcus on 16/5/12.
//  Copyright © 2016年 marcus. All rights reserved.
//  app宏定义

#ifndef MSDefine_h
#define MSDefine_h

//最后运行的版本
#define LAST_RUN_VERSION_KEY   @"last_run_version_of_application"

//弹出显示框 显示时间
#define PROGRESS_HUD_DELAY  2.0f

//打印日志
// MSLOG
#ifdef DEBUG
#define MSLog(fmt, ...)   do { \
                                fprintf(stderr, "*************************** MSLOG ***************************\n"); \
                                static NSDateFormatter* formatter; \
                                static dispatch_once_t predicate; \
                                dispatch_once(&predicate, ^{ \
                                            formatter = [[NSDateFormatter alloc] init]; \
                                            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]]; \
                                            formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss.SSS"; \
                                }); \
                               fprintf(stderr, "[%s] <%s:%s inLine:%d>\n ", [formatter stringFromDate:[NSDate date]].UTF8String, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __FUNCTION__, __LINE__); \
                               fprintf(stderr, "%s\n", [NSString stringWithFormat:(fmt), ##__VA_ARGS__].UTF8String); \
                            } while (0)
#define Mark              MMLog(@"- MARK -");
#else
#define MSLog(fmt, ...)
#define Mark
#endif


#define WeatherHeaderURL @"http://op.juhe.cn/onebox/weather/query"
#define NewsHeaderURL    @"http://op.juhe.cn/onebox/news/query"

#endif /* MSDefine_h */
