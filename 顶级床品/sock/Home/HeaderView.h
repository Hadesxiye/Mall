//
//  HeaderView.h
//  sock
//
//  Created by 王浩祯 on 2018/3/7.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface HeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@end
