//
//  MyAddressVC.h
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  类型自定义
 */
typedef void (^ReturnAddressBlock) (NSString* nameStr,NSString* phoneStr,NSString* addressStr);

@interface MyAddressVC : UIViewController
/**
 *  声明一个ReturnValueBlock属性，这个Block是获取传值的界面传进来的
 */
@property (nonatomic,copy) ReturnAddressBlock returnAddressBlock;
@property (nonatomic,strong) NSString* isSelected;

@end
