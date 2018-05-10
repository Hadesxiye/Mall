//
//  GoodsModel.m
//  sock
//
//  Created by 王浩祯 on 2018/3/21.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.Sid = dict[@"sid"];
        self.Sname = dict[@"sname"];
        self.Sprice = dict[@"sprice"];
        self.Spicl = dict[@"spic1"];
        self.Stitle = dict[@"stitle"];
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
