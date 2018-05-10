//
//  TableHeaderView.m
//  FECGoodsDetailLayout
//
//  Created by Qinz on 16/11/4.
//  Copyright © 2016年 FEC. All rights reserved.
//

#import "TableHeaderView.h"
#import "SDCycleScrollView.h"

@implementation TableHeaderView

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        // 网络加载图片的轮播器
//        //    SDCycleScrollView *cycleScrollView = [cycleScrollViewWithFrame:frame delegate:delegate placeholderImage:placeholderImage];
//        //    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
//
//        //本地图片
//        NSArray *picArr = [NSArray arrayWithObjects:@"wlop01.jpg",@"wlop02.jpg",@"wlop04.jpg", nil];
//        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SC_WIDTH, self.frame.size.height) imageNamesGroup:picArr];
//        [self addSubview:cycleScrollView];
//        self.cycleScrollView = cycleScrollView;
//    }
//    return self;
//}

+ (instancetype)tableHeaderViewWithUrlArr:(NSArray *)arr
{
    
//    return [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] firstObject];
    TableHeaderView* header = [TableHeaderView new];
    
    // 网络加载图片的轮播器
    SDCycleScrollView* cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SC_WIDTH,SC_WIDTH) imageURLStringsGroup:arr];

    
//    NSArray *picArr = [NSArray arrayWithObjects:@"pro01.jpg",@"pro02.jpg",@"pro03.jpg", nil];
//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SC_WIDTH,SC_WIDTH) imageNamesGroup:picArr];
    [header addSubview:cycleScrollView];
    
    return header;
}

@end
