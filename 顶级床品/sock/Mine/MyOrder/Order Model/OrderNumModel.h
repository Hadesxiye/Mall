//
//  OrderNumModel.h
//  sock
//
//  Created by 王浩祯 on 2018/3/14.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderNumModel : NSObject


@property (nonatomic,copy) NSString* sddnumber;
//地址信息
@property (nonatomic,copy) NSString* srealname;
@property (nonatomic,copy) NSString* saddress;
@property (nonatomic,copy) NSString* sphonenumber;

//订单信息 ，隔开
@property (nonatomic,copy) NSString* samount;
@property (nonatomic,copy) NSString* sid;

@property (nonatomic,copy) NSString* sshoptime;
@property (nonatomic,copy) NSString* state;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)SimWithDict:(NSDictionary *)dict;

+(NSArray*)SimWithArray:(NSArray*)array;

@end
