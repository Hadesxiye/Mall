//
//  ProductCell.h
//  sock
//
//  Created by 王浩祯 on 2018/3/13.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property (nonatomic,strong) UIImageView* productPic;
//@property (nonatomic,strong) UILabel* nameLab;
@property (nonatomic,strong) UILabel* productName;
@property (nonatomic,strong) UILabel* priceLab;
@property (nonatomic,strong) UILabel* productPrice;
@property (nonatomic,strong) UILabel* productSum;


@end
