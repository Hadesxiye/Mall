//
//  MSOrder.m
//  LiangFengYouXin
//
//  Created by 周峻觉 on 2018/3/7.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//
//

#import "MSOrder.h"

@implementation MSOrder

+ (instancetype)orderWithDictionary:(NSDictionary *)dic
{
    return [[MSOrder alloc] initWithDictionary:dic];
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        _ID = [value integerValue];
    }else if ([key isEqualToString:@"order_number"]){
        _number = value;
    }else if ([key isEqualToString:@"order_goods"]){
        NSArray* goodsArr = value;
        for (NSDictionary* dic in goodsArr) {
            MSGoods* goods = [MSGoods goodsWithDictionary:dic];
            [self.goodsArray addObject:goods];
        }
    }else if ([key isEqualToString:@"order_money"]){
        _totalMoney = [value integerValue];
    }else if ([key isEqualToString:@"score_total"]){
        _totalScore = [value integerValue];
    }else if ([key isEqualToString:@"pay_mode"]){
      
    }else if ([key isEqualToString:@"status"]){
        _status = [value integerValue];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)addGoods:(MSGoods *)goods
{
    if (_goodsArray == nil) {
        _goodsArray = [NSMutableArray arrayWithObject:goods];
    }else{
        [_goodsArray addObject:goods];
    }
}

- (NSInteger)uid
{
    return 0;
}

- (NSString *)jsonStringOfGoods
{
    NSMutableString* jsonString = [NSMutableString stringWithFormat:@"["];
    for (int i  = 0; i < self.goodsArray.count; i++) {
        [jsonString appendString:self.goodsArray[i].jsonStringForOrder];
        if (i < self.goodsArray.count - 1) {
            [jsonString appendString:@","];
        }
    }
    [jsonString appendString:@"]"];
    return jsonString;
}

- (NSString *)goodsSetSerialezed
{
    NSMutableArray* tmpArr = [NSMutableArray array];
    for (int i  = 0; i < self.goodsArray.count; i++) {
        [tmpArr addObject:self.goodsArray[i].jsonStringForOrder];
    }
    
    return [NSString stringWithFormat:@"[%@]", [tmpArr componentsJoinedByString:@","]];
}

- (NSMutableArray<MSGoods *> *)goodsArray
{
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

@end
