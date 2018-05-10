//
//  ShoppingCartModel.m
//  sock
//
//  Created by 王浩祯 on 2018/3/12.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "ShoppingCartModel.h"

@implementation ShoppingCartModel


-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.picUrl = dict[@"picUrl"];
        self.nameStr = dict[@"name"];
        self.priceStr = dict[@"price"];
        self.sumStr = dict[@"sum"];
        self.isSelect = dict[@"isSelect"];
    }
    return self;
}

+(instancetype)SimWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

+(NSArray*)SimWithArray:(NSArray *)array
{
    NSMutableArray* arrayM = [NSMutableArray array];
    for (NSDictionary*dict in array) {
        [arrayM addObject:[self SimWithDict:dict]];
    }
    return arrayM;
}


@end
