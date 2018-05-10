//
//  ProductModel.m
//  sock
//
//  Created by 王浩祯 on 2018/3/14.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.sname = dict[@"sname"];
        self.sprice = dict[@"sprice"];
        self.stitle = dict[@"stitle"];
        self.spic1 = dict[@"spic1"];
       
    }
    return self;
}

+(instancetype)SimWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

+(NSArray *)SimWithArray:(NSArray *)array{
    NSMutableArray* arrayM = [NSMutableArray array];
    for (NSDictionary*dict in array) {
        [arrayM addObject:[self SimWithDict:dict]];
    }
    return arrayM;
}


@end
