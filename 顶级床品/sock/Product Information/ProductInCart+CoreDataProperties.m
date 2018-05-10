//
//  ProductInCart+CoreDataProperties.m
//  sock
//
//  Created by 王浩祯 on 2018/3/23.
//  Copyright © 2018年 王浩祯. All rights reserved.
//
//

#import "ProductInCart+CoreDataProperties.h"

@implementation ProductInCart (CoreDataProperties)

+ (NSFetchRequest<ProductInCart *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ProductInCart"];
}

@dynamic title;
@dynamic sum;
@dynamic productID;
@dynamic price;
@dynamic picUrl;

@end
