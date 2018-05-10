//
//  OrderVC.h
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderVC : UIViewController

@property (nonatomic,copy) NSMutableArray* orderProductIDArr;
@property (nonatomic,copy) NSMutableArray* orderNameArr;
@property (nonatomic,copy) NSMutableArray* orderTitleArr;
@property (nonatomic,copy) NSMutableArray* orderPriceArr;
@property (nonatomic,copy) NSMutableArray* orderSumArr;
@property (nonatomic,copy) NSMutableArray* orderPicUrlArr;

@property (nonatomic,strong) NSString* priceStr;

@property (nonatomic, strong) NSString* orderNumber;
@property (nonatomic, assign) NSInteger shoptime;
@end
