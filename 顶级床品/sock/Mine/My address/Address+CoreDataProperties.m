//
//  Address+CoreDataProperties.m
//  sock
//
//  Created by 王浩祯 on 2018/3/19.
//  Copyright © 2018年 王浩祯. All rights reserved.
//
//

#import "Address+CoreDataProperties.h"

@implementation Address (CoreDataProperties)

+ (NSFetchRequest<Address *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Address"];
}

@dynamic address;
@dynamic addressID;
@dynamic name;
@dynamic phone;

@end
