//
//  SetPasswordVC.m
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "SetPasswordVC.h"

@interface SetPasswordVC ()
{
    UITextField* _setPasswordOne;
    UITextField* _setPasswordTwo;
    UIButton* loginBtn;
}

@end

@implementation SetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    
}
-(void)createUI
{
    UILabel* oneLab = [UILabel new];
    UILabel* twoLab = [UILabel new];
    
    oneLab.frame = CGRectMake(20, SC_HEIGHT/6, 80, 30);
    oneLab.text = @"设置密码";
    
    twoLab.frame = CGRectMake(20, SC_HEIGHT/6 + 40, 80, 30);
    twoLab.text = @"确认密码";
    
    [self.view addSubview:oneLab];
    [self.view addSubview:twoLab];
    
    
    _setPasswordOne = [UITextField new];
    _setPasswordTwo = [UITextField new];
    
    _setPasswordOne.frame = CGRectMake(100, SC_HEIGHT/6, SC_WIDTH - 200, 30);
    _setPasswordOne.placeholder = @"请输入您的密码";
    
    _setPasswordTwo.frame = CGRectMake(100, SC_HEIGHT/6 + 40, SC_WIDTH - 200, 30);
    _setPasswordTwo.placeholder = @"请再次输入您的密码";
    
    loginBtn = [UIButton new];
    loginBtn.frame = CGRectMake(20, SC_HEIGHT/6 + 100, SC_WIDTH - 40, 45);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTintColor:[UIColor whiteColor]];
    [loginBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setBackgroundColor:ColorRGB(108, 92, 231)];
    
    [self.view addSubview:_setPasswordOne];
    [self.view addSubview:_setPasswordTwo];
    [self.view addSubview:loginBtn];
   
}
#pragma mark ヾ(=･ω･=)o============== btn 点击事件 ==============Σ(((つ•̀ω•́)つ
-(void)clickLogin
{
    //判断两次密码是否相同
    if ([_setPasswordOne.text isEqualToString:_setPasswordTwo.text]) {
        NSLog(@"密码设置成功，自动登录");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        NSLog(@"两次密码不相同，请再次确认！");
    }
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
