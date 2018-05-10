//
//  ProductCell.m
//  sock
//
//  Created by 王浩祯 on 2018/3/13.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "ProductCell.h"
#define cellwid self.contentView.bounds.size.width
@implementation ProductCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.bounds = self.bounds;
        
        [self.contentView addSubview:self.productPic];

        [self.contentView addSubview:self.productName];
        [self.contentView addSubview:self.productSum];
        [self.contentView addSubview:self.productPrice];
        [self.contentView addSubview:self.priceLab];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _productPic.frame = CGRectMake(10, 10, 100, 100);

    _priceLab.frame = CGRectMake(120, 60, 50, 50);
    
    _productName.frame = CGRectMake(120, 10, cellwid - 140, 50);
    _productPrice.frame = CGRectMake(170, 60, (cellwid - 190)/2, 50);
    _productSum.frame = CGRectMake(CGRectGetMaxX(_productPrice.frame), 60, (cellwid - 190)/2, 50);
    
    
}
-(UIImageView *)productPic{
    if (!_productPic) {
        _productPic = [UIImageView new];
//        _productPic.backgroundColor = [UIColor redColor];
    }
    return _productPic;
}

//-(UILabel *)nameLab{
//    if (!_nameLab) {
//        _nameLab = [UILabel new];
//        _nameLab.text = @"标题：";
//        _nameLab.font = [UIFont boldSystemFontOfSize:15];
////        _nameLab.backgroundColor = [UIColor redColor];
//    }
//    return _nameLab;
//}

-(UILabel *)productName{
    if (!_productName) {
        _productName = [UILabel new];
        _productName.font = [UIFont systemFontOfSize:13];
        _productName.numberOfLines = 2;
//        _productName.backgroundColor = [UIColor greenColor];
    }
    return _productName;
}

-(UILabel *)productPrice{
    if (!_productPrice) {
        _productPrice = [UILabel new];
        _productPrice.textColor = [UIColor redColor];
        _productPrice.font = [UIFont systemFontOfSize:18];
//        _productPrice.backgroundColor = [UIColor grayColor];
    }
    return _productPrice;
}

-(UILabel *)productSum{
    if (!_productSum) {
        _productSum = [UILabel new];
        _productSum.font = [UIFont systemFontOfSize:15];
 
    }
    return _productSum;
}

-(UILabel *)priceLab{
    if (!_priceLab) {
        _priceLab = [UILabel new];
        _priceLab.text = @"价格：";
        _priceLab.font = [UIFont boldSystemFontOfSize:15];

    }
    return _priceLab;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
