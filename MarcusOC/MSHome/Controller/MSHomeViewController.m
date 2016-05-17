//
//  MSHomeViewController.m
//  MarcusOC
//
//  Created by marcus on 16/5/13.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSHomeViewController.h"
#import "MSHeader.h"

@interface MSHomeViewController ()

@end

@implementation MSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(UIButton *)sender {
    [MSProgressManager showLoading];
}

- (IBAction)click1:(UIButton *)sender {
    
    [MSProgressManager showInfoWithStatus:@"测试数据"];

}

- (IBAction)click2:(UIButton *)sender {
    [MSProgressManager showToastStatus:@"测试数据测试数据"];
}

- (IBAction)backClick:(UIButton *)sender {
    [MSProgressManager hideLoading];
}

- (IBAction)progressClick:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        for (int i = 0; i<=10; i++) {
//            NSLog([NSString stringWithFormat:@"数据：%d",i]);
            [MSProgressManager showProgress:(i/10.0) mode:MSProgressModeRingShaped status:@"loading..."];
            sleep(1);
        }
    });
}

@end
