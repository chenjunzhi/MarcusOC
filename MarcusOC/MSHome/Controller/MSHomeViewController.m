//
//  MSHomeViewController.m
//  MarcusOC
//
//  Created by marcus on 16/6/6.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSHomeViewController.h"
#import "MSAPIWeatherManager.h"
#import "MSWeatherViewController.h"

@interface MSHomeViewController () <MSAPIManagerParamSourceDelegate,MSAPIManagerApiCallBackDelegate>

@property (nonatomic, strong) MSAPIWeatherManager *apiWeatherManager;
@property (nonatomic, strong) NSString *callData;

@end

@implementation MSHomeViewController


#pragma mark - view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationBarHidden = YES;
    self.tabBarHidden = NO;
    
    self.title = @"欢迎使用";
    self.apiWeatherManager = [[MSAPIWeatherManager alloc]init];
    self.apiWeatherManager.delegate = self;
    self.apiWeatherManager.paramSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"home viewWillAppear %@",self.navigationController.viewControllers);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"home viewDidAppear %@",self.navigationController.viewControllers);

}

#pragma mark - MSAPIManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(MSAPIBaseManager *)manager {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (manager == self.apiWeatherManager) {
        [params setObject:@"上海" forKey:@"cityname"];
        [params setObject:@"bad2cad16601f6a06ac442c335467961" forKey:@"key"];
    }
    return params;
}

#pragma mark - MSAPIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(MSAPIBaseManager *)manager {
    if (manager.errorType == MSAPIManagerErrorTypeSuccess) {
        self.callData = [NSString stringWithFormat:@"%@+++%@",self.callData,manager.responseObject];
    }
}


- (void)managerCallAPIDidFailed:(MSAPIBaseManager *)manager {
    
}

- (IBAction)weatherClick:(UIButton *)sender {
//    [self.apiWeatherManager loadData];
    MSWeatherViewController * weather = [[MSWeatherViewController alloc] init];
    weather.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:weather animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
