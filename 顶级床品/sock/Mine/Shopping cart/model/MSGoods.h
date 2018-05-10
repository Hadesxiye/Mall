//
//  MSGoods.h
//  LiangFengYouXin
//
//  Created by 周峻觉 on 2018/2/16.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSGoods : NSObject<NSCopying, NSMutableCopying>

+ (instancetype)goodsWithDictionary:(NSDictionary *)dic;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

/********** 商品基本信息 **********/
/** 商品ID */
@property (nonatomic, strong) NSString* goodsId;
/** 图片URL */
@property (nonatomic, strong) NSString *goodsUrlString;
/** 商品名 */
@property (nonatomic, strong) NSString *goodsName;
/** 商品标题 */
@property (nonatomic, strong) NSString *title;
/** 商品详情 */
@property (nonatomic, strong) NSString* detail;
/** 商品价格 */
@property (nonatomic, assign) CGFloat price;
/** 商品积分 */
@property (nonatomic, assign) CGFloat score;
/** 七天无理由退货 */
@property (nonatomic, assign) BOOL freeRefund;
/** 免邮费 */
@property (nonatomic, assign) BOOL freeShipping;
/** 剩余 */
@property (nonatomic, assign) NSInteger stock;
/* 头部轮播 */
@property (nonatomic, strong) NSMutableArray *imageUrlStrings;



/********** 购买信息 **********/
/** 用户购买数量 */
@property (nonatomic, assign) NSInteger buyCount;
/** 用户备注 */
@property(nonatomic, strong)NSString* remark;
/** 总价格 */
@property (nonatomic, assign, readonly) CGFloat totalPrice;
/** 总神奇积分 */
@property (nonatomic, assign, readonly) CGFloat totalScore;

- (NSString *)jsonStringForOrder;  //提交订单时，用到的json 字符串。不需要把所有的产品属性值都编入json字符串中提交给服务器。
@end
