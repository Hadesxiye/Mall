//
//  MineVC.m
//  sock
//
//  Created by 王浩祯 on 2018/3/7.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "MineVC.h"
#import "MineCell.h"
#import "LoginVC.h"
#import "ShoppingCartVC.h"
#import "MyOrder.h"
#import "MyAddressVC.h"
#import "FeedbackVC.h"
#import "MBProgressHUD.h"
#import "AboutVC.h"

@interface MineVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView* _tableView;
    NSArray* titleArr;
    NSArray* iconArr;
    UIButton* avatarBtn;
    NSInteger loginState;
    
    UILabel* userNumber;
    UIButton* loginBtn;
    UIButton* offlineBtn;
    NSString* saveUserNumber;
    //userdefault key isLogin userNumber
}

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleArr = [NSArray arrayWithObjects:@"购物车",@"我的订单",@"我的地址",@"意见反馈",@"关于", nil];
    iconArr = [NSArray arrayWithObjects:@"购物车.png",@"订单.png",@"地址.png",@"意见反馈.png",@"关于.png", nil];
    
    
    [self createNavigationController];
    
    
    [self checkUser];
    [self createBtn];
    
    [self createTableView];
    
    
}
#pragma mark ヾ(=･ω･=)o============== 登录判断 ==============Σ(((つ•̀ω•́)つ
-(void)checkUser
{
    //定义一个用户默认数据对象
    //不需要alloc创建，用户默认数据对象单例模式
    //standardUserDefaults：获取全局唯一的实例对象
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    //先判断是否进行过初始化
    loginState = [ud integerForKey:@"isLogin"];
    
    
    if (loginState==0) {
       
//        [ud setInteger:1 forKey:@"isClick"];
        NSLog(@"未登录");
        
 
    }
    //否则对isclick判断，
    else
    {
        
        NSLog(@"%@",saveUserNumber);
        NSLog(@"已登录");
    }
    saveUserNumber = [NSString new];
    saveUserNumber = [ud stringForKey:@"userNumber"];
    NSLog(@"---%@",saveUserNumber);
}


#pragma mark ヾ(=･ω･=)o============== 创建圆形button ==============Σ(((つ•̀ω•́)つ
-(void)createBtn
{
    UIImage *imgFromUrl3;
        NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),@"headerImage"];
    if (loginState==0) {
        imgFromUrl3 = [UIImage imageNamed:@"Group"];
        
    }
    else{
        // 拿到沙盒路径图片
        imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
    }

    

    avatarBtn = [[UIButton alloc]init];
    avatarBtn.frame = CGRectMake( SC_WIDTH/2 - SC_WIDTH * 0.618/6, SC_WIDTH * 0.618/3, SC_WIDTH * 0.618/3,SC_WIDTH * 0.618/3);  //把按钮设置成正方形
    avatarBtn.layer.cornerRadius = SC_WIDTH * 0.618/6;  //设置按钮的拐角为宽的一半
    avatarBtn.layer.borderWidth = 3;  // 边框的宽
    avatarBtn.layer.borderColor = [UIColor whiteColor].CGColor;//边框的颜色
    avatarBtn.layer.masksToBounds = YES;// 这个属性很重要，把超出边框的部分去除
    avatarBtn.backgroundColor = [UIColor grayColor];
    [avatarBtn setBackgroundImage:imgFromUrl3 forState:UIControlStateNormal];
    [avatarBtn addTarget:self action:@selector(changePic) forControlEvents:UIControlEventTouchUpInside];
    avatarBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark ❀==============❂ 更换头像功能 ❂==============❀
-(void)changePic{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //把newPhono设置成头像
    [avatarBtn setBackgroundImage:newPhoto forState:UIControlStateNormal];
    //关闭当前界面，即回到主界面去
    
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/headerImage.png"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(newPhoto) writeToFile:imagePath atomically:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ヾ(=･ω･=)o============== 创建tableview ==============Σ(((つ•̀ω•́)つ
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, topHeight, SC_WIDTH, SC_HEIGHT+20) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
  
    //创建头视图
    UIView* HeadView = [[UIView alloc]init];
    _tableView.tableHeaderView = HeadView;
    HeadView.frame = CGRectMake(0, 0, SC_WIDTH, SC_WIDTH * 0.618);
    HeadView.backgroundColor = [UIColor whiteColor];
    UIImageView* background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sunshine.jpg"]];
    background.frame = CGRectMake(0, 0, SC_WIDTH, SC_WIDTH * 0.618);
  
    //创建头视图的子控件
    loginBtn = [UIButton new];
    offlineBtn = [UIButton new];
    userNumber = [UILabel new];
    
    loginBtn.frame = CGRectMake( SC_WIDTH/2 - SC_WIDTH * 0.618/6 , SC_WIDTH * 0.618/9 * 7, SC_WIDTH * 0.618/3,SC_WIDTH * 0.618/9);
    [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [loginBtn setTintColor:[UIColor whiteColor]];
    
    [loginBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
//    userNumber.text = saveUserNumber;
    userNumber.frame = CGRectMake( 0 , SC_WIDTH * 0.618/9 * 7, SC_WIDTH,SC_WIDTH * 0.618/9);
    userNumber.textAlignment = NSTextAlignmentCenter;
    userNumber.textColor = [UIColor whiteColor];
    userNumber.font = [UIFont boldSystemFontOfSize:15];
    
    offlineBtn.frame = CGRectMake(SC_WIDTH - 60, -topHeight , 50, 30);
    [offlineBtn setTitle:@"退出" forState:UIControlStateNormal];
    [offlineBtn addTarget:self action:@selector(clickOffline) forControlEvents:UIControlEventTouchUpInside];
    [offlineBtn setTintColor:[UIColor whiteColor]];
    offlineBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    background.userInteractionEnabled = YES;
    
    
    

    [background addSubview:loginBtn];
   
    [background addSubview:userNumber];
    [background addSubview:offlineBtn];
    
    
    [background addSubview:avatarBtn];
    [HeadView addSubview:background];
    
    [self.view addSubview:_tableView];
}

//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSString* cellStr =[NSString stringWithFormat:@"cellID"];
    MineCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell = [[MineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.titleLable.text = titleArr[indexPath.row];
        [cell.icon setImage:[UIImage imageNamed:iconArr[indexPath.row]]];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
#pragma mark ヾ(=･ω･=)o============== cell点击事件 ==============Σ(((つ•̀ω•́)つ
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    //先判断是否进行过初始化
    loginState = [ud integerForKey:@"isLogin"];
    if (loginState==0) {
        [self textWaiting:[NSString stringWithFormat:@"请先登录"]];
        return;
    }
    if (indexPath.row==0) {
        ShoppingCartVC* shopVC = [ShoppingCartVC new];
        shopVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopVC animated:YES];
    }
    else if (indexPath.row==1) {
        
        MyOrder* orderVC = [MyOrder new];
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    else if (indexPath.row==2) {
        
        MyAddressVC* addressVC = [MyAddressVC new];
        addressVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressVC animated:YES];
    }
    else if(indexPath.row == 3)
    {
        
        FeedbackVC* feedbackVC  = [FeedbackVC new];
        feedbackVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }else{
        AboutVC* aboutVC = [AboutVC new];
        aboutVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}
#pragma mark ヾ(=･ω･=)o============== button 点击事件 tabber隐藏==============Σ(((つ•̀ω•́)つ
-(void)clickLogin
{
    //push时hidden
    
    
    LoginVC* logVC = [LoginVC new];
    logVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:logVC animated:YES];
}
-(void)clickOffline
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:0 forKey:@"isLogin"];
    [self checkUser];
    userNumber.hidden = YES;
    offlineBtn.hidden = YES;
    loginBtn.hidden = NO;
    
}
#pragma mark ヾ(=･ω･=)o============== 设置导航栏隐藏 ==============Σ(((つ•̀ω•́)つ
//利用生命周期设置是否隐藏 navigationBar
- (void)viewWillAppear:(BOOL)animated {
    [self checkUser];
    //判断登录
    if (loginState==0){
        loginBtn.hidden = NO;
        userNumber.hidden = YES;
        offlineBtn.hidden = YES;
    }
    else{
        loginBtn.hidden = YES;
        userNumber.hidden = NO;
        offlineBtn.hidden = NO;
    }
    userNumber.text = saveUserNumber;
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
-(void)createNavigationController
{
//    self.navigationController.navigationBar.barTintColor = ColorRGB(140, 122, 230);
//    self.navigationController.navigationBar.tintColor = ColorRGB(223, 230, 233);
    //设置导航栏返回时显示的文字
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    
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
