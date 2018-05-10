//
//  Address+CoreDataProperties.h
//  sock
//
//  Created by 王浩祯 on 2018/3/19.
//  Copyright © 2018年 王浩祯. All rights reserved.
//
//

#import "Address+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Address (CoreDataProperties)

+ (NSFetchRequest<Address *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *addressID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *phone;

@end

NS_ASSUME_NONNULL_END
