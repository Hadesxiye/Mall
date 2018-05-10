//
//  ProductModel.h
//  sock
//
//  Created by 王浩祯 on 2018/3/14.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

//名字
@property (nonatomic,copy) NSString* sname;
//图片
@property (nonatomic,copy) NSString* spic1;
//价格
@property (nonatomic,copy) NSString* sprice;
//标题
@property (nonatomic,copy) NSString* stitle;



-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)SimWithDict:(NSDictionary *)dict;

+(NSArray*)SimWithArray:(NSArray*)array;

@end
