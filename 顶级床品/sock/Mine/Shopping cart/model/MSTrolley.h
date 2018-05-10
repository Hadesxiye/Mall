//
//  MSTrolley.h
//  LiangFengYouXin
//
//  Created by 周峻觉 on 2018/2/16.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSGoods.h"

@interface MSTrolley : NSObject

+ (instancetype)shared;

- (MSGoods *)goodsWithId:(NSString *)goodsId;
- (MSGoods *)goodsWithIndex:(NSInteger)index;
- (void)addGoodsWithId:(NSString *)goodsId count:(NSInteger)count;
- (void)addGoods:(MSGoods *)model;
- (void)reduceGoodsWithId:(NSString *)goodsId count:(NSInteger)count;   //减少商品数量，如果数量==0，并没有将商品从购物车移除
- (void)reduceGoods:(MSGoods *)model;
- (void)reduceAllGoods;
- (NSInteger)countOfGoods:(MSGoods *)model;

- (NSInteger)countOfAllGoods;  //所有商品的个数
- (CGFloat)totalMoney;
- (CGFloat)totalScore;

- (NSInteger)countOfGoodsType; //商品种类的个数
- (BOOL)isEmpty;

- (void)tidyShoppingCar;  //整理购物车，将数量为0的商品从购物车移除。

@end
