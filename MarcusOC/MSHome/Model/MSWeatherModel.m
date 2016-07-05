//
//  MSWeatherModel.m
//  MarcusOC
//
//  Created by marcus on 16/7/5.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSWeatherModel.h"

@implementation MSWeatherModel

+ (NSDictionary *)modelCustomPropertyMapper {
    NSDictionary * dic = @{@"city_name" : @"realtime.city_name",
                           @"weather" : @"realtime.weather.info",
                           @"temperature" : @"realtime.weather.temperature",
                           @"moon" : @"realtime.moon",
                           @"date" : @"realtime.date",
                           @"time" : @"realtime.time"
                           };
    return dic;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _updteTime = [NSString stringWithFormat:@"%@ %@",_date,_time];
    NSArray * array = [[[dic objectForKey:@"life"] objectForKey:@"info"] objectForKey:@"chuanyi"];
    _dressingIndex = (array && array.count>1)?array[1]:nil;
    return YES;
}

@end
