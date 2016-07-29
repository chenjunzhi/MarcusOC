//
//  MSMyViewController.m
//  MarcusOC
//
//  Created by marcus on 16/5/13.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import "MSMyViewController.h"
#import <CoreData/CoreData.h>
#import "MSTestModel.h"


@interface MSMyViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MSMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
    self.tabBarHidden = NO;

    [self createCoreDataTable];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addDataClick:(UIButton *)sender {
    [self writeDataToTable];
}

- (IBAction)readDataClick:(UIButton *)sender {
    [self readDataFromTable];
}

- (void)createCoreDataTable {
    //1、创建模型对象
    //获取模型路径
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"testModel" withExtension:@"momd"];
    //根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //2、创建持久化助理
    //利用模型对象创建助理对象
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //数据库的名称和路径
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"mySqlite.sqlite"];
    NSLog(@"path = %@", sqlPath);
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
    
    //设置数据库相关信息
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:nil];
    
    
    //3、创建上下文
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //关联持久化助理
    [self.context setPersistentStoreCoordinator:store];
    
}

- (void)writeDataToTable {
    MSTestModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"MSTestModel" inManagedObjectContext:self.context];
    model.name = @"测试数据";
    model.sex = @(1);
    model.grade = @(99);
    
    NSError *error = nil;
    [self.context save:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
}

- (void)readDataFromTable {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MSTestModel"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",@"测试数据"];
    request.predicate = pre;
    
    NSSortDescriptor *heigtSort = [NSSortDescriptor sortDescriptorWithKey:@"sex" ascending:NO];
    request.sortDescriptors = @[heigtSort];
    

    NSError *error = nil;
    NSArray *temps = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error");
    }
    
    for (MSTestModel *model in temps) {
        self.textView.text = [NSString stringWithFormat:@"%@ %@ %@",model.name,model.sex,model.grade];
    }
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
