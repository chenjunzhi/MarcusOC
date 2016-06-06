//
//  MSWeatherViewController.m
//  MarcusOC
//
//  Created by marcus on 16/6/6.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSWeatherViewController.h"
#import "MSRequstManager.h"

@interface MSWeatherViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MSWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData1];
}

#pragma mark private
- (void)loadData1 {
    NSLog(@"0000%@",self.navigationController.viewControllers);
    __weak typeof(self) tempSelf = self;
    [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?cityname=%@&key=%@",WeatherHeaderURL,@"上海",@"bad2cad16601f6a06ac442c335467961"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
        if (responseObject) {
            NSLog(@"1111%@",tempSelf.label);
        }
    }];
    
    [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?cityname=%@&key=%@",WeatherHeaderURL,@"合肥",@"bad2cad16601f6a06ac442c335467961"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
        if (responseObject) {
             sleep(4);
            NSLog(@"2222%@",tempSelf.label);
        }
    }];
    
    [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?cityname=%@&key=%@",WeatherHeaderURL,@"北京",@"bad2cad16601f6a06ac442c335467961"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
        if (responseObject) {
            NSLog(@"3333%@",tempSelf.label);
        }
    }];
    
    [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?cityname=%@&key=%@",WeatherHeaderURL,@"广州",@"bad2cad16601f6a06ac442c335467961"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
        if (responseObject) {
            NSLog(@"4444%@",tempSelf.label);
        }
    }];
    
    [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?q=%@&key=%@",NewsHeaderURL,@"北京",@"1580154996dd3f10b6fc397d0b118189"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
        if (responseObject) {
            NSLog(@"55555%@",tempSelf.label);
        }
    }];
    
    [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?q=%@&key=%@",NewsHeaderURL,@"上海",@"1580154996dd3f10b6fc397d0b118189"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
        if (responseObject) {
            NSLog(@"66666%@",tempSelf.label);
        }
    }];
}

- (void)loadData {
    NSLog(@"0000%@",self.navigationController.viewControllers);
    
    //创建监听组
    //创建并行队列
    //    dispatch_queue_t group = dispatch_get_global_queue(0, 0);
    
    __weak typeof(self) tempself = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_group_t group=dispatch_group_create();
        
        dispatch_group_enter(group);
        [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?cityname=%@&key=%@",WeatherHeaderURL,@"上海",@"bad2cad16601f6a06ac442c335467961"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
            if (responseObject) {
                NSLog(@"1111%@",tempself.navigationController.viewControllers);
                self.label.text = @"1111";
                dispatch_group_leave(group);
            }
        }];
        
        dispatch_group_enter(group);
        [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?cityname=%@&key=%@",WeatherHeaderURL,@"合肥",@"bad2cad16601f6a06ac442c335467961"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
            if (responseObject) {
                NSLog(@"2222%@",tempself.navigationController.viewControllers);
                self.label.text = @"2222";
                dispatch_group_leave(group);
            }
        }];
        
        dispatch_group_enter(group);
        [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?cityname=%@&key=%@",WeatherHeaderURL,@"北京",@"bad2cad16601f6a06ac442c335467961"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
            if (responseObject) {
                NSLog(@"3333%@",tempself.navigationController.viewControllers);
                self.label.text = @"3333";
                dispatch_group_leave(group);
            }
        }];
        
        dispatch_group_enter(group);
        [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?cityname=%@&key=%@",WeatherHeaderURL,@"广州",@"bad2cad16601f6a06ac442c335467961"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
            if (responseObject) {
                NSLog(@"4444%@",tempself.navigationController.viewControllers);
                self.label.text = @"4444";
                dispatch_group_leave(group);
            }
        }];
        
        dispatch_group_enter(group);
        [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?q=%@&key=%@",NewsHeaderURL,@"北京",@"1580154996dd3f10b6fc397d0b118189"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
            if (responseObject) {
                NSLog(@"55555%@",tempself.navigationController.viewControllers);
                self.label.text = @"5555";
                dispatch_group_leave(group);
            }
        }];
        
        dispatch_group_enter(group);
        [[MSRequstManager sharedManager] asynGET:[NSString stringWithFormat:@"%@?q=%@&key=%@",NewsHeaderURL,@"上海",@"1580154996dd3f10b6fc397d0b118189"] withCompeletBlock:^(id  _Nullable responseObject, MSRequstErrorCode code, NSError * _Nullable error) {
            if (responseObject) {
                NSLog(@"66666%@",tempself.navigationController.viewControllers);
                self.label.text = @"6666";
                dispatch_group_leave(group);
            }
        }];
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER); // 5
        dispatch_async(dispatch_get_main_queue(), ^{ // 6
            //执行操作
            NSLog(@"执行操作 done");
        });
    });
    
}

-(void)dealloc
{
    NSLog(@"dealloc %@",self);
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
