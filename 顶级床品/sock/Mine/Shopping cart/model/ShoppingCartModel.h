//
//  ShoppingCartModel.h
//  sock
//
//  Created by 王浩祯 on 2018/3/12.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartModel : NSObject

@property (nonatomic,copy) NSString* picUrl;
@property (nonatomic,copy) NSString* nameStr;
@property (nonatomic,copy) NSString* priceStr;
@property (nonatomic,copy) NSString* sumStr;
@property (nonatomic,copy) NSString* isSelect;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)SimWithDict:(NSDictionary *)dict;

+(NSArray*)SimWithArray:(NSArray*)array;

@end
