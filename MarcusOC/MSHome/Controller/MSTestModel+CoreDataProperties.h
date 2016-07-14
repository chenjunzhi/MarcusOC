//
//  MSTestModel+CoreDataProperties.h
//  MarcusOC
//
//  Created by marcus on 16/7/12.
//  Copyright © 2016年 marcus. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MSTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSTestModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSNumber *sex;
@property (nullable, nonatomic, retain) NSNumber *grade;

@end

NS_ASSUME_NONNULL_END
