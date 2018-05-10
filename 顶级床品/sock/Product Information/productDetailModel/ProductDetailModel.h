//
//  ProductDetailModel.h
//  sock
//
//  Created by 王浩祯 on 2018/3/22.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductDetailModel : NSObject

@property (nonatomic,copy) NSString* samount;
@property (nonatomic,copy) NSString* scolor;
@property (nonatomic,copy) NSString* sid;
@property (nonatomic,copy) NSString* sname;
@property (nonatomic,copy) NSString* spic1;
@property (nonatomic,copy) NSString* spic2;
@property (nonatomic,copy) NSString* spic3;
@property (nonatomic,copy) NSString* sprice;
@property (nonatomic,copy) NSString* ssize;
@property (nonatomic,copy) NSString* stexture;
@property (nonatomic,copy) NSString* stitle;
@property (nonatomic,copy) NSString* sproduce;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)SimWithDict:(NSDictionary *)dict;

+(NSArray*)SimWithArray:(NSArray*)array;

@end
