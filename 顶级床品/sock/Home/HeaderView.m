//
//  HeaderView.m
//  sock
//
//  Created by 王浩祯 on 2018/3/7.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "HeaderView.h"


@implementation HeaderView
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        
//    }
////     self;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 网络加载图片的轮播器
        //    SDCycleScrollView *cycleScrollView = [cycleScrollViewWithFrame:frame delegate:delegate placeholderImage:placeholderImage];
        //    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        
        //本地图片
        NSArray *picArr = [NSArray arrayWithObjects:@"画板 1.png",@"画板 2.png",@"画板 3.png", nil];
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SC_WIDTH, self.frame.size.height) imageNamesGroup:picArr];
        cycleScrollView.userInteractionEnabled = YES;
        [self addSubview:cycleScrollView];
        self.cycleScrollView = cycleScrollView;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
