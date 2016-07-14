//
//  MSWeatherModel.h
//  MarcusOC
//
//  Created by marcus on 16/7/5.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSWeatherModel : NSObject

@property (nonatomic, strong) NSString *city_name;
@property (nonatomic, strong) NSString *updteTime;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *weather;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *moon;
@property (nonatomic, strong) NSString *dressingIndex;

@end

