//
//  ShoppingCartCell.m
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "ShoppingCartCell.h"
#define cellwid self.contentView.bounds.size.width
@implementation ShoppingCartCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.frame = self.bounds;
        
        _productPic = [UIImageView new];
        _productPic.backgroundColor = [UIColor redColor];
        _backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiajian"]];
        
        [self.contentView addSubview:self.backView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.productPic];
        [self.contentView addSubview:self.priceLab];
        [self.contentView addSubview:self.sumLab];
        [self.contentView addSubview:self.addBtn];
        [self.contentView addSubview:self.minBtn];
        [self.contentView addSubview:self.chooseBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //gao 120
    _chooseBtn.frame = CGRectMake(10,50,20,20);
    _productPic.frame = CGRectMake(40, 10, 100, 100);
    _titleLab.frame = CGRectMake(CGRectGetMaxX(_productPic.frame)+10, 10, cellwid - 160, 50);
    _priceLab.frame = CGRectMake(CGRectGetMaxX(_productPic.frame)+10, 80 , (cellwid - 160)/2, 30);
    _minBtn.frame = CGRectMake(CGRectGetMaxX(_priceLab.frame), 80, (cellwid - CGRectGetMaxX(_priceLab.frame) - 10)/3 - 10, 30);
    _sumLab.frame = CGRectMake(CGRectGetMaxX(_minBtn.frame), 80, (cellwid - CGRectGetMaxX(_priceLab.frame) - 10)/3, 30);
    _addBtn.frame = CGRectMake(CGRectGetMaxX(_sumLab.frame) , 80, (cellwid - CGRectGetMaxX(_priceLab.frame) - 10)/3 - 10, 30);
    _backView.frame = CGRectMake(CGRectGetMaxX(_priceLab.frame), 80, (cellwid - CGRectGetMaxX(_priceLab.frame) - 10) - 20, 30);
}
- (UIImageView *)productPic {
    if (!_productPic) {
        _productPic = [UIImageView new];
    }
    return _productPic;
}
- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_chooseBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState: UIControlStateHighlighted];
        [_chooseBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [_chooseBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    return _chooseBtn;
}

//-(UIImageView *)productPic {
//    if (!_productPic) {
//        _productPic = [UIImageView new];
//        _productPic.backgroundColor = [UIColor redColor];
//      
//    }
//    return _productPic;
//}

-(UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.numberOfLines = 2;

    }
    return _titleLab;
}

-(UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [UILabel new];
        _priceLab.font = [UIFont systemFontOfSize:20];
        _priceLab.textColor = [UIColor redColor];
       

    }
    return _priceLab;
}

-(UILabel *)sumLab {
    if (!_sumLab) {
        _sumLab = [UILabel new];
        _sumLab.font = [UIFont systemFontOfSize:15];
        _sumLab.textColor = [UIColor blackColor];
        _sumLab.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return _sumLab;
}

-(UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton new];
     
//        [_addBtn setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
        
    }
    return _addBtn;
}

-(UIButton *)minBtn {
    if (!_minBtn) {
        _minBtn = [UIButton new];
        
//        [_minBtn setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
        
    }
    return _minBtn;
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
