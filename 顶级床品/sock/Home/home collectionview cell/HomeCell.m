//
//  HomeCell.m
//  sock
//
//  Created by 王浩祯 on 2018/3/21.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "HomeCell.h"


@implementation HomeCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    self.backgroundColor=[UIColor grayColor];
    
    _picView = [UIImageView new];
    _picView.frame = CGRectMake(0, 0 , self.contentView.bounds.size.width, self.contentView.bounds.size.width);
    _picView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_picView];
    
    _nameLab = [UILabel new];
    _priceLab = [UILabel new];
    
    _nameLab.frame = CGRectMake(0, self.contentView.bounds.size.width, self.contentView.bounds.size.width, 30);
    _nameLab.backgroundColor = [UIColor whiteColor];
    _nameLab.numberOfLines = 2;
    _priceLab.frame = CGRectMake(0, self.contentView.bounds.size.width + 30, self.contentView.bounds.size.width, 20);
    _priceLab.backgroundColor = [UIColor whiteColor];
    
    
    
    [self addSubview:_nameLab];
    [self addSubview:_priceLab];
    
    [self addSubview:self.detailLab];
 
}


#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}


- (UILabel *)detailLab
{
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] init];
        _detailLab.backgroundColor = [UIColor clearColor];
        [_detailLab setFont:[UIFont systemFontOfSize:20]];
        [_detailLab setTextColor:[UIColor grayColor]];
        _detailLab.numberOfLines = 0;
    }
    return _detailLab;
}


@end
