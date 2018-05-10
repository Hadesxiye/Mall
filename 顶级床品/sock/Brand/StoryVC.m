//
//  StoryVC.m
//  sock
//
//  Created by 周峻觉 on 2018/4/28.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "StoryVC.h"

@interface StoryVC ()

@property(nonatomic, strong)UIScrollView* scrollView;

@end

@implementation StoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.scrollView.frame = self.view.bounds;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat contentTotalHeight = 0;
    for (int i = 1; i <= 4; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"故事%d.png", i]];
        CGFloat imageViewHeight = screenWidth * (image.size.height/image.size.width);
        UIImageView* imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentTotalHeight, screenWidth, imageViewHeight)];
        imageView.image = image;
        
        contentTotalHeight += imageViewHeight;
        [self.scrollView addSubview:imageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(screenWidth, contentTotalHeight+50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
