//
//  FeedbackVC.m
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "FeedbackVC.h"
#import "MBProgressHUD.h"

@interface FeedbackVC ()
{
    UITextView* feedBackView;
}
@end

@implementation FeedbackVC

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self createUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
}
-(void)createUI{
    feedBackView = [UITextView new];
    UIView* backView = [UIView new];
    backView.frame = CGRectMake(0 , SC_HEIGHT, SC_WIDTH, 300);
    backView.backgroundColor = ColorRGB(241, 242, 246);
    [self.view addSubview:backView];
    feedBackView.frame = CGRectMake(0, NAVSTASTUS+10, SC_WIDTH, SC_HEIGHT - 400);
    feedBackView.font = [UIFont systemFontOfSize:20];
    feedBackView.backgroundColor = ColorRGB(241, 242, 246);
    [self.view addSubview:feedBackView];
    UIButton* postBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, SC_HEIGHT-100, SC_WIDTH - 200, 50)];
    [postBtn setBackgroundImage:[UIImage imageNamed:@"tijiao"] forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [postBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(clickPost) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:postBtn];
    
}
-(void)clickPost{
    feedBackView.text = @"";
    [self textWaiting:[NSString stringWithFormat:@"已上传"]];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textWaiting:(NSString *)str {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, 1);
    
    [hud hideAnimated:YES afterDelay:2.f];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [feedBackView resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
