//
//  MineCell.m
//  sock
//
//  Created by 王浩祯 on 2018/3/8.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.frame = self.bounds;
        
        [self.contentView addSubview:self.icon];
       
        [self.contentView addSubview:self.titleLable];
        
    }
    return self;
}

-(UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.font = [UIFont boldSystemFontOfSize:15];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.frame = CGRectMake(60, 10, SC_WIDTH/3, 40);
    }
    return _titleLable;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.frame = CGRectMake(10, 10, 40, 40);
        _icon.contentMode = UIViewContentModeCenter;
    }
    return _icon;
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
