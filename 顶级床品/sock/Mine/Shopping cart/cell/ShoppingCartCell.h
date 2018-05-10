//
//  ShoppingCartCell.h
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *priceLab;
@property (nonatomic,strong) UILabel *sumLab;
@property (nonatomic,strong) UIImageView *productPic;
@property (nonatomic,strong) UIImageView *backView;

@property (nonatomic,strong) UIButton *chooseBtn;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *minBtn;



@end
