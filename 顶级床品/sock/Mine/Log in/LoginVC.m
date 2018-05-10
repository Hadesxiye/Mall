//
//  LoginVC.m
//  sock
//
//  Created by 王浩祯 on 2018/3/8.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface LoginVC ()<UITextFieldDelegate>
{
    UITextField* numberField;
    UITextField* passwordField;
    UIButton* loginBtn;
    UIButton* registerBtn;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO];
    [self createUI];
    //设置导航栏返回时显示的文字
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* numberTemp = [ud stringForKey:@"userNumber"];
    
    UIImageView* backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing"]];
    backImage.frame = CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT);
    backImage.userInteractionEnabled = YES;
    [self.view addSubview:backImage];
    
    
    UIImageView* phoneBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"textfield"]];
    phoneBackground.frame = CGRectMake(20, SC_HEIGHT/6, SC_WIDTH - 40, 60);
    [self.view addSubview:phoneBackground];
    numberField = [UITextField new];
    numberField.frame = CGRectMake(50, SC_HEIGHT/6, SC_WIDTH - 100, 60);
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    numberField.placeholder = @"请输入手机号";
    if ([numberTemp isEqualToString:@""]||numberTemp==nil) {
        
    }
    else
    {
        numberField.text = numberTemp;
    }
    
    UIImageView* passwordBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"textfield"]];
    passwordBackground.frame = CGRectMake(20, SC_HEIGHT/6 + 70, SC_WIDTH - 40, 60);
    [self.view addSubview:passwordBackground];
    passwordField = [UITextField new];
    passwordField.keyboardType = UIKeyboardTypeNumberPad;
    passwordField.frame = CGRectMake(50, SC_HEIGHT/6 + 70, SC_WIDTH - 100, 60);
    passwordField.placeholder = @"请输入验证码";
    
    
    
    loginBtn = [UIButton new];
    loginBtn.frame = CGRectMake(SC_WIDTH - 150, SC_HEIGHT/6 + 83, 110, 30);
    [loginBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"获取框"] forState:UIControlStateNormal];
    [loginBtn setTintColor:[UIColor whiteColor]];
    [loginBtn addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setBackgroundColor:[UIColor clearColor]];
    
    registerBtn = [UIButton new];
    registerBtn.frame = CGRectMake(20, SC_HEIGHT/6 + 160, SC_WIDTH - 40, 60);
    [registerBtn setTitle:@"登录" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerBtn setTintColor:[UIColor whiteColor]];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"登录框"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setBackgroundColor:[UIColor clearColor]];
    
    
    [self.view addSubview:numberField];
    [self.view addSubview:passwordField];
    [self.view addSubview:loginBtn];
    [self.view addSubview:registerBtn];
    
}
#pragma mark - ❀==============❂ 文字提示框 ❂==============❀
- (void)textWaiting:(NSString *)str {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, 1);
    
    [hud hideAnimated:YES afterDelay:2.f];
}
#pragma mark - ヾ(=･ω･=)o============== 点击事件手机号和验证码判断 ==============Σ(((つ•̀ω•́)つ
-(void)clickLogin:(UIButton *)btn
{
    //验证码按钮
    if (btn==loginBtn) {
        if (numberField.text==NULL||[numberField.text isEqualToString:@""]) {
            [self textWaiting:[NSString stringWithFormat:@"请输入账号"]];
            return;
        }
        else
        {
            [self verifyRequest];
            return;
        }
        
    }
    //登录按钮
    else{
        if (numberField.text==NULL||[numberField.text isEqualToString:@""]) {
            [self textWaiting:[NSString stringWithFormat:@"请输入账号"]];
            return;
        }
        else if(passwordField.text==NULL||[passwordField.text isEqualToString:@""]){
            [self textWaiting:[NSString stringWithFormat:@"请输入验证码"]];
            return;
        }
        else
        {
            //测试账号，免验证码
            if ([numberField.text isEqualToString:@"12345678"]&&[passwordField.text isEqualToString:@"888888"]) {
                [self textWaiting:[NSString stringWithFormat:@"登录成功"]];
                NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:numberField.text forKey:@"userNumber"];
                [ud setInteger:1 forKey:@"isLogin"];
                [ud synchronize];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [self loginRequest];
                NSLog(@" psot 进行登录!!!");
            }
        }
        
    }

}
#pragma mark - ❀==============❂ 验证码请求 ❂==============❀
-(void)verifyRequest
{
    NSString *urlString = @"http://219.235.6.7:8080/bedding/verify/verify.action";
    
    AFHTTPSessionManager *manger =[AFHTTPSessionManager manager];
    
    //post数据
    NSDictionary *dict= @{@"account":numberField.text};
    
    [manger POST:urlString parameters:dict progress:^(NSProgress * _NonnulluploadProgress){
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        //解析数据
        NSLog(@"responseObject==%@",responseObject);
        if (responseObject) {
          
//            NSString* result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSDictionary* dict = [self parseJsonStringToNSDictionary:result];
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            
            NSLog(@"dict==%@",dict);
            
            NSString* stateStr = [NSString stringWithFormat:@"%@",dict[@"state"]];
            
            if ([stateStr isEqualToString:@"1"]) {
                
                NSLog(@"验证码请求 返回登录成功");
            }
            else if ([stateStr isEqualToString:@"2"]){
                NSLog(@"验证码请求 返回登录失败");
            }
            else if ([stateStr isEqualToString:@"3"]){
                [self textWaiting:[NSString stringWithFormat:@"短信已发送"]];
                NSLog(@"验证码请求 短信已发送");
            }
            else{
                [self textWaiting:[NSString stringWithFormat:@"验证码未知错误"]];
                NSLog(@"验证码请求 未知state==%@",stateStr);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - ❀==============❂ 登录请求 ❂==============❀
-(void)loginRequest
{
    NSString *urlString = @"http://219.235.6.7:8080/bedding/verify/verify.action";
    
    AFHTTPSessionManager *manger =[AFHTTPSessionManager manager];
    
    //post数据
    NSDictionary *dict= @{
                          @"account":numberField.text,
                          @"verify":passwordField.text
                          };
    
    [manger POST:urlString parameters:dict progress:^(NSProgress * _NonnulluploadProgress){
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        //解析数据
        if (responseObject) {
            
//            NSString* result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSDictionary* dict = [self parseJsonStringToNSDictionary:result];
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            
            NSLog(@"dict==%@",dict);
            
      
            NSString* stateStr = [NSString stringWithFormat:@"%@",dict[@"state"]];
            
            if ([stateStr isEqualToString:@"1"]) {
                [self textWaiting:[NSString stringWithFormat:@"登录成功"]];
                NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:numberField.text forKey:@"userNumber"];
                [ud setInteger:1 forKey:@"isLogin"];
                [ud synchronize];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else if ([stateStr isEqualToString:@"2"]){
                [self textWaiting:[NSString stringWithFormat:@"账号或者密码错误"]];
            }
            else if ([stateStr isEqualToString:@"3"]){
                [self textWaiting:[NSString stringWithFormat:@"短信已发送"]];
            }
            else{
                [self textWaiting:[NSString stringWithFormat:@"未知错误"]];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//-(void)clickRegister
//{
//    RegisterVC* registerVC = [RegisterVC new];
//    [self.navigationController pushViewController:registerVC animated:YES];
//
//}


//利用生命周期设置是否隐藏 navigationBar
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}
#pragma mark - ❀==============❂ 转json格式数据 ❂==============❀
- (NSDictionary *)parseJsonStringToNSDictionary:(NSString *)jsonString
{
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    NSError *error2=nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error2];
    //if ([dict isValid]) {
    return dict;
    // }
//    return nil;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [numberField resignFirstResponder];
    [passwordField resignFirstResponder];
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
