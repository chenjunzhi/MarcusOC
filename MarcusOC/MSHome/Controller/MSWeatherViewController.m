//
//  MSWeatherViewController.m
//  MarcusOC
//
//  Created by marcus on 16/6/6.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSWeatherViewController.h"
#import "MSRequstManager.h"
#import "MSAPIWeatherManager.h"
#import "MSWeatherModel.h"


@interface MSWeatherViewController ()<MSAPIManagerParamSourceDelegate,MSAPIManagerApiCallBackDelegate>

@property (nonatomic, strong) MSAPIWeatherManager *apiWeatherManager;
@property (nonatomic, strong) MSWeatherModel *weatherModel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dreeingIndexLabel;
@end

@implementation MSWeatherViewController

#pragma mark - view liftcycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"天气情况";
    [self createLeftBarItemWithImage];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidFirstAppear:(BOOL)animated {
    [super viewDidFirstAppear:animated];
}


#pragma mark - MSAPIManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(MSAPIBaseManager *)manager {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([manager isKindOfClass:[MSAPIWeatherManager class]]) {
        [params setObject:@"上海" forKey:@"cityname"];
        [params setObject:@"bad2cad16601f6a06ac442c335467961" forKey:@"key"];
    }
    return params;
}

#pragma mark - MSAPIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(MSAPIBaseManager *)manager {
    MSLog(@"数据请求成功 manager：%@",manager);
    if (manager.errorType == MSAPIManagerErrorTypeSuccess) {
        NSDictionary *dic = manager.responseObject;
        if ([[dic valueForKey:@"error_code"] integerValue] == 0) {
            NSDictionary *result = [dic objectForKey:@"result"];
            self.weatherModel = [MSWeatherModel yy_modelWithJSON:[result objectForKey:@"data"]];
            [self refreshView];
        }
    }
    [MSProgressManager hideLoading];
}


- (void)managerCallAPIDidFailed:(MSAPIBaseManager *)manager {
    
}

#pragma mark - private methods
- (void)loadData {
    [MSProgressManager show:@"" gifName:@"loading-hu" view:self.view];
    [self.apiWeatherManager loadData];
}

- (void)refreshView {
    self.cityNameLabel.text = self.weatherModel.city_name;
    self.weatherLabel.text = self.weatherModel.weather;
    self.updateLabel.text = [NSString stringWithFormat:@"%@",self.weatherModel.updteTime];
    self.dreeingIndexLabel.text = self.weatherModel.dressingIndex;
}



#pragma mark - getters and setter
- (MSAPIWeatherManager*)apiWeatherManager {
    if (!_apiWeatherManager) {
        _apiWeatherManager = [[MSAPIWeatherManager alloc]init];
        _apiWeatherManager.delegate = self;
        _apiWeatherManager.paramSource = self;
    }
    return _apiWeatherManager;
}

@end
