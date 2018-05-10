//
//  TimeAndNumCell.m
//  sock
//
//  Created by 王浩祯 on 2018/3/13.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "TimeAndNumCell.h"
#define cellwid self.contentView.bounds.size.width
@implementation TimeAndNumCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.bounds = self.bounds;
        
        [self.contentView addSubview:self.numLab];
        [self.contentView addSubview:self.number];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.time];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    _numLab.frame = CGRectMake(20, 10, cellwid/3-20, 20);
    _timeLab.frame = CGRectMake(20, 40, cellwid/3-20, 20);
    _number.frame = CGRectMake(cellwid/3, 10, cellwid/3 * 2 -10, 20);
    _time.frame = CGRectMake(cellwid/3, 40, cellwid/3 * 2 -10, 20);

}

-(UILabel *)numLab{
    if (!_numLab) {
        _numLab = [UILabel new];
        _numLab.text = @"订单编号";
        _numLab.font = [UIFont systemFontOfSize:15];
//        _numLab.backgroundColor = [UIColor redColor];
    }
    return _numLab;
}

-(UILabel *)number{
    if (!_number) {
        _number = [UILabel new];
        _number.font = [UIFont systemFontOfSize:15];
//        _number.backgroundColor = [UIColor blueColor];
    }
    return _number;
}

-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.text = @"创建时间";
        _timeLab.font = [UIFont systemFontOfSize:15];
//        _timeLab.backgroundColor = [UIColor greenColor];
    }
    return _timeLab;
}

-(UILabel *)time{
    if (!_time) {
        _time = [UILabel new];
        _time.font = [UIFont systemFontOfSize:15];
//        _time.backgroundColor = [UIColor yellowColor];
    }
    return _time;
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
