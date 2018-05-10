//
//  KuaiDICell.m
//  sock
//
//  Created by 王浩祯 on 2018/3/14.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "KuaiDICell.h"
#define cellwid self.contentView.bounds.size.width

@implementation KuaiDICell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.bounds = self.bounds;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.kuaiDiLab];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(20, 10, 100, 30);
    self.kuaiDiLab.frame = CGRectMake(120, 10, cellwid - 130, 30);
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];

        _titleLab.font = [UIFont systemFontOfSize:15];
    }
    return _titleLab;
}

-(UILabel *)kuaiDiLab{
    if (!_kuaiDiLab) {
        _kuaiDiLab = [UILabel new];
        _kuaiDiLab.font = [UIFont systemFontOfSize:15];
    }
    return _kuaiDiLab;
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
