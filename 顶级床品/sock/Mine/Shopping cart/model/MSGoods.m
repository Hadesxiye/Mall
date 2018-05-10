//
//  MSGoods.m
//  LiangFengYouXin
//
//  Created by 周峻觉 on 2018/2/16.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//

#import "MSGoods.h"

@implementation MSGoods

- (instancetype)copyWithZone:(NSZone *)zone
{
    MSGoods* goods = [[MSGoods alloc] init];
    goods.goodsId = [_goodsId copy];
    goods.goodsUrlString = [_goodsUrlString copy];
    goods.goodsName = [_goodsName copy];
    goods.title = [_title copy];
    goods.detail = [_detail copy];
    goods.price = _price;
    goods.score = _score;
    goods.freeRefund = _freeRefund;
    goods.freeShipping = _freeShipping;
    goods.stock = _stock;
    goods.imageUrlStrings = [_imageUrlStrings copy];
    goods.buyCount = _buyCount;
    goods.remark = [_remark copy];
    return goods;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    MSGoods* goods = [[MSGoods alloc] init];
    goods.goodsId = [_goodsId mutableCopy];
    goods.goodsUrlString = [_goodsUrlString mutableCopy];
    goods.goodsName = [_goodsName mutableCopy];
    goods.title = [_title mutableCopy];
    goods.detail = [_detail mutableCopy];
    goods.price = _price;
    goods.score = _score;
    goods.freeRefund = _freeRefund;
    goods.freeShipping = _freeShipping;
    goods.stock = _stock;
    goods.imageUrlStrings = [_imageUrlStrings mutableCopy];
    goods.buyCount = _buyCount;
    goods.remark = [_remark mutableCopy];
    return goods;
}

+ (instancetype)goodsWithDictionary:(NSDictionary *)dic
{
    return [[self alloc] initWithDictionary:dic];
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (CGFloat)totalPrice
{
    return _price * _buyCount;
}

- (CGFloat)totalScore
{
    return _score * _buyCount;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"] || [key isEqualToString:@"goods_id"]) {
        _goodsId = value;
    }else if ([key isEqualToString:@"goods_logo"]){
        _goodsUrlString = value;
    }else if ([key isEqualToString:@"goods_title"]){
        _title = value;
    }else if ([key isEqualToString:@"goods_name"]){
        _goodsName = value;
    }else if ([key isEqualToString:@"goods_detail"]){
        _detail = value;
    }else if ([key isEqualToString:@"price"] || [key isEqualToString:@"goods_price"]){
        _price = [value floatValue];
    }else if ([key isEqualToString:@"score"] || [key isEqualToString:@"goods_score"]){
        _score = [value floatValue];
    }else if ([key isEqualToString:@"is_free_refund"]){
        _freeRefund = [value boolValue];
    }else if ([key isEqualToString:@"is_free_shipping"]){
        _freeShipping = [value boolValue];
    }else if([key isEqualToString:@"buyCount"] || [key isEqualToString:@"goods_number"]){
        _buyCount = [value integerValue];
    }else if ([key isEqualToString:@"overplus_quantity"]){
        _stock = [value integerValue];
    }else if([key isEqualToString:@"goods_images"]){
        NSArray* array = value;
        for (NSDictionary* dic in array) {
            [self.imageUrlStrings addObject:dic[@"image_src"]];
        }
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSString *)jsonStringForOrder
{
//    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                _goodsId,@"goods_id",
//                                _buyCount,@"goods_number",
//                                _remark,@"remark", nil];
    NSMutableDictionary *tmpDict = [NSMutableDictionary new];
    [tmpDict addEntriesFromDictionary:@{@"goods_id":self.goodsId,
                                        @"goods_number":[NSNumber numberWithInteger:self.buyCount],
                                        @"remark":self.remark}];
    
    NSData* tmpData = [NSJSONSerialization dataWithJSONObject:tmpDict options:0 error:nil];
    NSString* tmpStr = [[NSString alloc]initWithData:tmpData encoding:NSUTF8StringEncoding];
    return tmpStr;
    
//    return [NSString stringWithFormat:@"{\"goods_id\":%@,\"goods_number\":%ld,\"remark\":\"%@\"}",_goodsId,_buyCount,_remark?:@""];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%p, goodsId:%@, goodsUrlString:%@, goodsName:%@, title:%@, detail:%@, price:%f, score:%f, freeRefund:%d, freeShipping:%d, stock:%ld, imageUrlStrings:%@, buyCount:%ld, remark:%@, totalPrice:%f, totalScore:%f>", self, _goodsId, _goodsUrlString, _goodsName, _title, _detail, _price, _score, _freeRefund, _freeShipping, _stock, _imageUrlStrings, _buyCount, _remark, [self totalPrice], [self totalScore]];
}

- (NSMutableArray *)imageUrlStrings
{
    if (!_imageUrlStrings) {
        _imageUrlStrings = [NSMutableArray array];
    }
    return _imageUrlStrings;
}

- (NSString *)remark
{
    if (!_remark) {
        _remark = @"";
    }
    return _remark;
}

@end
