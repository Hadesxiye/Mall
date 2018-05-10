//
//  MSTrolley.m
//  LiangFengYouXin
//
//  Created by 周峻觉 on 2018/2/16.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//

#import "MSTrolley.h"

@interface MSTrolley ()

@property(nonatomic, strong)NSMutableDictionary<id, MSGoods *>* goodsDic;

@end

@implementation MSTrolley

+ (instancetype)shared
{
    static MSTrolley* car = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        car = [[MSTrolley alloc] init];
    });
    return car;
}

- (MSGoods *)goodsWithId:(NSString *)goodsId
{
    MSGoods* m = self.goodsDic[goodsId];
    return m;
}

- (MSGoods *)goodsWithIndex:(NSInteger)index
{
    NSArray* keys = self.goodsDic.allKeys;
    if (index > keys.count-1) {
        return nil;
    }
    NSString* goodsId = [keys objectAtIndex:index];
    MSGoods* m = self.goodsDic[goodsId];
    return m;
}

- (void)addGoodsWithId:(NSString *)goodsId count:(NSInteger)count
{
    MSGoods* m = self.goodsDic[goodsId];
    if (m) {
        m.buyCount = m.buyCount + count;
    }
}

- (void)addGoods:(MSGoods *)model
{
    NSLog(@"%@", model);
    if (model == nil) {
        return;
    }
    MSGoods* m = self.goodsDic[model.goodsId];
    if (m) {
        m.buyCount = m.buyCount + model.buyCount;
    }else{
        [self.goodsDic setObject:model forKey:model.goodsId];
    }
}

- (void)reduceGoodsWithId:(NSString *)goodsId count:(NSInteger)count
{
    MSGoods* m = self.goodsDic[goodsId];
    if (m && m.buyCount > 0) {
        m.buyCount = m.buyCount - count;
        if (m.buyCount < 0) {
            m.buyCount = 0;
        }
    }
}

- (void)reduceGoods:(MSGoods *)model
{
    MSGoods* m = self.goodsDic[model.goodsId];
    if (m && m.buyCount > 0) {
        m.buyCount = m.buyCount - model.buyCount;
        if (m.buyCount < 0) {
            m.buyCount = 0;
        }
    }
}

- (void)reduceAllGoods
{
    [self.goodsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, MSGoods * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.buyCount = 0;
        //[self.goodsDic setObject:obj forKey:key];
    }];
}

- (NSInteger)countOfGoods:(MSGoods *)model
{
    MSGoods* m = self.goodsDic[model.goodsId];
    if (m) {
        return m.buyCount;
    }else{
        return 0;
    }
}

- (NSInteger)countOfAllGoods
{
    __block NSInteger count = 0;
    [self.goodsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, MSGoods * _Nonnull obj, BOOL * _Nonnull stop) {
        count = count + obj.buyCount;
    }];
    return count;
}

- (CGFloat)totalMoney
{
    __block CGFloat totalPrice = 0;
    [self.goodsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, MSGoods * _Nonnull obj, BOOL * _Nonnull stop) {
        totalPrice = totalPrice + obj.price*obj.buyCount;
    }];
    return totalPrice;
}
- (CGFloat)totalScore
{
    __block CGFloat totalScore = 0;
    [self.goodsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, MSGoods * _Nonnull obj, BOOL * _Nonnull stop) {
        totalScore = totalScore + obj.score*obj.buyCount;
    }];
    return totalScore;
}

- (NSInteger)countOfGoodsType
{
    return self.goodsDic.count;
}

- (BOOL)isEmpty
{
    if ([self countOfAllGoods] == 0) {
        return YES;
    }
    return NO;
}

- (void)tidyShoppingCar
{
    [self.goodsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, MSGoods * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.buyCount == 0) {
            [self.goodsDic removeObjectForKey:key];
        }
    }];
}

#pragma mark - 懒加载
- (NSMutableDictionary<id, MSGoods *>*)goodsDic
{
    if (!_goodsDic) {
        _goodsDic = [NSMutableDictionary dictionary];
    }
    return _goodsDic;
}

@end
