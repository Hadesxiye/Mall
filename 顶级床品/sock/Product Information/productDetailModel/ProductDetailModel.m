//
//  ProductDetailModel.m
//  sock
//
//  Created by 王浩祯 on 2018/3/22.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "ProductDetailModel.h"

@implementation ProductDetailModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.samount = dict[@"samount"];
        self.scolor = dict[@"scolor"];
        self.sid = dict[@"sid"];
        self.sname = dict[@"sname"];
        self.spic1 = dict[@"spic1"];
        self.spic2 = dict[@"spic2"];
        self.spic3 = dict[@"spic3"];
        self.sprice = dict[@"sprice"];
        self.ssize = dict[@"ssize"];
        self.stexture = dict[@"stexture"];
        self.stitle = dict[@"stitle"];
        self.sproduce = dict[@"sproduce"];
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
