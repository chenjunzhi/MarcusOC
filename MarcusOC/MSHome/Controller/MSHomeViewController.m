//
//  MSHomeViewController.m
//  MarcusOC
//
//  Created by marcus on 16/6/6.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSHomeViewController.h"
#import "MSWeatherViewController.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"home viewWillAppear %@",self.navigationController.viewControllers);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"home viewDidAppear %@",self.navigationController.viewControllers);

}

- (IBAction)weatherClick:(UIButton *)sender {
    MSWeatherViewController * weather = [[MSWeatherViewController alloc] init];
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
