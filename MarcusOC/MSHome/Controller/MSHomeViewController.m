//
//  MSHomeViewController.m
//  MarcusOC
//
//  Created by marcus on 16/5/13.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSHomeViewController.h"
#import "MSHeader.h"
#import "Masonry.h"

@interface MSHomeViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation MSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(80);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@15);
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(UIButton *)sender {
//    [MSProgressManager showLoading];

    
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
            [MSProgressManager showProgress:(i/10.0) mode:MSProgressModeRingShaped status:@"loading..."];
            sleep(1);
        }
    });
}

#pragma mark -- getter and setter

- (UILabel *)label {
    _label = [UILabel label:_label font:[UIFont systemFontOfSize:13] color:[UIColor grayColor] textAlignment:NSTextAlignmentCenter text:@"12344"];
    return _label;
}

@end
