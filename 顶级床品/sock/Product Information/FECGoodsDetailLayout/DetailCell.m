//
//  DetailCell.m
//  FECGoodsDetailLayout
//
//  Created by Qinz on 16/11/4.
//  Copyright © 2016年 FEC. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

//+ (instancetype) detailCell:(UITableView *) tableView{
//    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
//    if (cell == nil) {
//
////        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailCell" owner:nil options:nil] firstObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return cell;
//}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.frame = self.bounds;
        
        [self.contentView addSubview:self.titleLable];
        
    }
    return self;
}

-(UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.font = [UIFont boldSystemFontOfSize:15];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.frame = CGRectMake(20, 0, self.contentView.bounds.size.width - 40, 40);
    }
    return _titleLable;
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
