//
//  ProductInCart+CoreDataProperties.h
//  sock
//
//  Created by 王浩祯 on 2018/3/23.
//  Copyright © 2018年 王浩祯. All rights reserved.
//
//

#import "ProductInCart+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ProductInCart (CoreDataProperties)

+ (NSFetchRequest<ProductInCart *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *sum;
@property (nullable, nonatomic, copy) NSString *productID;
@property (nullable, nonatomic, copy) NSString *price;
@property (nullable, nonatomic, copy) NSString *picUrl;

@end

NS_ASSUME_NONNULL_END
