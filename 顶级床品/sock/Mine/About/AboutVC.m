//
//  AboutVC.m
//  sock
//
//  Created by 周峻觉 on 2018/4/28.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "AboutVC.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "WebVC.h"

#define kKeyWindow                      [UIApplication sharedApplication].keyWindow
#define kScreenBounds                   [UIScreen mainScreen].bounds
#define kScreenSize                     [UIScreen mainScreen].bounds.size
#define kScreenWidth                    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                   [UIScreen mainScreen].bounds.size.height
#define kScreenScale                    [UIScreen mainScreen].scale
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

@interface AboutVC ()<YBAttributeTapActionDelegate>

@property(nonatomic, strong)UIImageView* logoImageView;
@property(nonatomic, strong)UILabel* title_1_Label;
@property(nonatomic, strong)UILabel* title_2_Label;
@property(nonatomic, strong)UILabel* otherLabel;
@property(nonatomic, strong)UIButton* webBtn;

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    //self.edgesForExtendedLayout = UIRectEdgeTop;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.title_1_Label];
    [self.view addSubview:self.title_2_Label];
    [self.view addSubview:self.otherLabel];
    [self.view addSubview:self.webBtn];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.logoImageView.frame = CGRectMake((kScreenWidth-60)*0.5, kStatusAndNavBarHeight + 30, 60, 60);
    self.title_1_Label.frame = CGRectMake(0, CGRectGetMaxY(self.logoImageView.frame), kScreenWidth, 80);
    self.title_2_Label.frame = CGRectMake(0, CGRectGetMaxY(self.title_1_Label.frame), kScreenWidth, 40);
    self.otherLabel.frame = CGRectMake(30, CGRectGetMaxY(self.title_2_Label.frame)+30, kScreenWidth-60, 200);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-60.png"]];
        _logoImageView.layer.cornerRadius = 5;
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.clipsToBounds = YES;
    }
    return _logoImageView;
}

- (UILabel *)title_1_Label
{
    if (!_title_1_Label) {
        _title_1_Label = [[UILabel alloc] init];
        _title_1_Label.textAlignment = NSTextAlignmentCenter;
        _title_1_Label.textColor = [UIColor blackColor];
        _title_1_Label.numberOfLines = 0;
        _title_1_Label.text = @"顶级CP床品\nv1.0.0";
    }
    return _title_1_Label;
}

- (UILabel *)title_2_Label
{
    if (!_title_2_Label) {
        _title_2_Label = [[UILabel alloc] init];
        _title_2_Label.textAlignment = NSTextAlignmentCenter;
        _title_2_Label.textColor = [UIColor blackColor];
        _title_2_Label.numberOfLines = 0;
        _title_2_Label.text = @"顶级床品线下门店使用app";
    }
    return _title_2_Label;
}

- (UILabel *)otherLabel
{
    if (!_otherLabel) {
        _otherLabel = [[UILabel alloc] init];
        _otherLabel.textAlignment = NSTextAlignmentLeft;
        _otherLabel.textColor = [UIColor blackColor];
        _otherLabel.numberOfLines = 0;
        NSString *label_text2 = @"线上相关：\n\n官网：http://www.lencier.com\n\n天猫店：兰叙家纺旗舰店（店名）\n\n京东店：兰叙家纺自营旗舰店（店名）\n\n微博：LENCIER兰叙生活";
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(10, 24)];
        _otherLabel.attributedText = attributedString2;
        _otherLabel.enabledTapEffect = NO;
        
        [_otherLabel yb_addAttributeTapActionWithStrings:@[@"http://www.lencier.com"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            WebVC* web = [WebVC new];
            [self.navigationController pushViewController:web animated:YES];
        }];
        
    }
    return _otherLabel;
}

- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    //    NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),index];
    //    YBAlertShow(message, @"取消");
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
