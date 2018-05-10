//
//  MyOrder.h
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrder : UIViewController

//接收商品id，立即购买就传一个，购物车提交传数组
@property (nonatomic,strong) NSArray* sidArr;

@end
