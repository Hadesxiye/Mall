//
//  AddressCell.m
//  sock
//
//  Created by 王浩祯 on 2018/3/13.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "AddressCell.h"
#define cellwid self.contentView.bounds.size.width
@implementation AddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.bounds = self.bounds;
        
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.phoneNum];
        [self.contentView addSubview:self.address];

    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _name.frame = CGRectMake(20, 10, 100, 20);
    _phoneNum.frame = CGRectMake(120, 10, cellwid - 120, 20);
    _address.frame = CGRectMake(20, 35, cellwid-20, 40);
    
}

-(UILabel *)name{
    if (!_name) {
        _name = [UILabel new];
        _name.font = [UIFont boldSystemFontOfSize:15];
//        _name.backgroundColor = [UIColor redColor];
    }
    return _name;
}

-(UILabel *)phoneNum{
    if (!_phoneNum) {
        _phoneNum = [UILabel new];
        _phoneNum.font = [UIFont boldSystemFontOfSize:15];
//        _phoneNum.backgroundColor = [UIColor greenColor];
    }
    return _phoneNum;
}

-(UILabel *)address{
    if (!_address) {
        _address = [UILabel new];
        _address.font = [UIFont systemFontOfSize:13];
        _address.numberOfLines = 2;
//        _address.backgroundColor = [UIColor grayColor];
    }
    return _address;
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
