//
//  RegisterVC.m
//  sock
//
//  Created by 王浩祯 on 2018/3/8.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "RegisterVC.h"
#import "SetPasswordVC.h"

@interface RegisterVC ()<UITextFieldDelegate>
{
    UITextField* phoneNumber;
    UITextField* yanZheng;
    UIButton* getYanZhengBtn;
    UIButton* regisetrBtn;
}
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
    //设置导航栏返回时显示的文字
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    UILabel* numberLab = [UILabel new];
    UILabel* yanZhengLab = [UILabel new];
    
    numberLab.frame = CGRectMake(20, SC_HEIGHT/6, 60, 30);
    numberLab.text = @"手机号";
    
    yanZhengLab.frame = CGRectMake(20, SC_HEIGHT/6 + 40, 60, 30);
    yanZhengLab.text = @"验证码";
    
    [self.view addSubview:numberLab];
    [self.view addSubview:yanZhengLab];
    

    phoneNumber = [UITextField new];
    yanZheng = [UITextField new];
    
    phoneNumber.frame = CGRectMake(100, SC_HEIGHT/6, SC_WIDTH - 220, 30);
    phoneNumber.placeholder = @"请输入手机号";
    
    yanZheng.frame = CGRectMake(100, SC_HEIGHT/6 + 40, SC_WIDTH - 220, 30);
    yanZheng.placeholder = @"请输入验证码";
    
    getYanZhengBtn = [UIButton new];
    getYanZhengBtn.frame = CGRectMake(20, SC_HEIGHT/6 + 100, SC_WIDTH - 40, 45);
    [getYanZhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getYanZhengBtn setTintColor:[UIColor whiteColor]];
    [getYanZhengBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    [getYanZhengBtn setBackgroundColor:ColorRGB(108, 92, 231)];
    
    regisetrBtn = [UIButton new];
    regisetrBtn.frame = CGRectMake(20, SC_HEIGHT/6 + 160, SC_WIDTH - 40, 45);
    [regisetrBtn setTitle:@"确认" forState:UIControlStateNormal];
    [regisetrBtn setTintColor:[UIColor whiteColor]];
    [regisetrBtn addTarget:self action:@selector(validationVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    [regisetrBtn setBackgroundColor:ColorRGB(108, 92, 231)];
    
    [self.view addSubview:phoneNumber];
    [self.view addSubview:yanZheng];
    [self.view addSubview:getYanZhengBtn];
    [self.view addSubview:regisetrBtn];
    
}
#pragma mark ヾ(=･ω･=)o============== btn点击事件 获取验证码 验证 ==============Σ(((つ•̀ω•́)つ
//获取验证码
-(void)getVerificationCode
{
    NSLog(@"发送手机号，请求验证码");
}
//验证验证码
-(void)validationVerificationCode
{
    NSLog(@"发送验证码获取验证,返回正确与否");
    SetPasswordVC* passVC = [SetPasswordVC new];
    [self.navigationController pushViewController:passVC animated:YES];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [phoneNumber resignFirstResponder];
    [yanZheng resignFirstResponder];
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
