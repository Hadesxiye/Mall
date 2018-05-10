//
//  NormalCell.m
//  sock
//
//  Created by 王浩祯 on 2018/3/13.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "NormalCell.h"
#define cellwid self.contentView.bounds.size.width

@implementation NormalCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.bounds = self.bounds;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.payIcon];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(20, 10, 100, 30);
    self.payIcon.frame = CGRectMake(cellwid- 50, 10, 30, 30);
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15];
    }
    
    return _titleLab;
}

-(UIImageView *)payIcon{
    if (!_payIcon) {
        _payIcon = [UIImageView new];
        [_payIcon setImage:[UIImage imageNamed:@"zhifubao"]];
    }
   
    return _payIcon;
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
