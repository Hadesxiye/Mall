//
//  MSOrder.h
//  LiangFengYouXin
//
//  Created by 周峻觉 on 2018/3/7.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//
//  订单

#import <Foundation/Foundation.h>
#import "MSGoods.h"

typedef enum : NSUInteger {
    MSOrderStatusWaitPay = 0,      //待付款
    MSOrderStatusWaitSend = 1,     //待发货
    MSOrderStatusWaitTake = 2,     //待收货
    MSOrderStatusReturn = 3,       //退货
    MSOrderStatusReceive = 4,      //已收货
    MSOrderStatusCancel = 5,       //订单取消
    MSOrderStatusAccomplish = 9,   //订单完成 ，包含了 退货、已收货、订单取消
    MSOrderStatusCreate,           //订单创建
    MSOrderStatusProcessing        //正在处理订单
} MSOrderStatus;

@interface MSOrder : NSObject

@property(nonatomic, assign)NSInteger ID;  //订单ID
@property(nonatomic, strong)NSString* number;  //订单编号
@property(nonatomic, strong)NSMutableArray<MSGoods *>* goodsArray;
@property(nonatomic, strong)NSString* province;
@property(nonatomic, strong)NSString* city;
@property(nonatomic, strong)NSString* address;
@property(nonatomic, strong)NSString* mobile;
@property(nonatomic, strong)NSString* consigneeName;  //收货人姓名
@property(nonatomic, assign)NSInteger uid;
@property(nonatomic, assign)MSOrderStatus status; 
@property(nonatomic, assign)NSInteger totalMoney; //订单总金额
@property(nonatomic, assign)NSInteger totalScore; //订单总神奇积分

+ (instancetype)orderWithDictionary:(NSDictionary *)dic;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (void)addGoods:(MSGoods *)goods;
- (NSString *)jsonStringOfGoods;  //弃用
- (NSString *)goodsSetSerialezed; //产品集合序列化

@end
