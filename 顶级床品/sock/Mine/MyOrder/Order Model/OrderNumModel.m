//
//  OrderNumModel.m
//  sock
//
//  Created by 王浩祯 on 2018/3/14.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "OrderNumModel.h"

@implementation OrderNumModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.sddnumber = dict[@"sddnumber"];
        self.srealname = dict[@"srealname"];
        self.sphonenumber = dict[@"sphonenumber"];
        self.saddress = dict[@"saddress"];
        self.sid = dict[@"sid"];
        self.samount = dict[@"samount"];
        self.sshoptime = dict[@"sshoptime"];
        self.state = dict[@"state"];

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
