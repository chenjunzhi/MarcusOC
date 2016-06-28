//
//  MSAPIWeatherManager.m
//  MarcusOC
//
//  Created by marcus on 16/6/28.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSAPIWeatherManager.h"
#import "MSHeader.h"

@implementation MSAPIWeatherManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestType = MSAPIManagerRequestTypeGet;
        self.url = WeatherHeaderURL;
    }
    
    return self;
}

@end
