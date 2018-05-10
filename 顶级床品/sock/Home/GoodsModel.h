//
//  GoodsModel.h
//  sock
//
//  Created by 王浩祯 on 2018/3/21.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

@property (nonatomic,copy) NSString* Sid;
@property (nonatomic,copy) NSString* Sprice;
@property (nonatomic,copy) NSString* Sname;
@property (nonatomic,copy) NSString* Stitle;
@property (nonatomic,copy) NSString* Spicl;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)SimWithDict:(NSDictionary *)dict;

+(NSArray*)SimWithArray:(NSArray*)array;

@end
