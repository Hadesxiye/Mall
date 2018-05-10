//
//  MyOrder.m
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "MyOrder.h"
#import "ProductCell.h"
#import "AFNetworking.h"
#import "OrderNumModel.h"
#import "ProductModel.h"
#import "UIImageView+WebCache.h"
#import "OrderVC.h"

@interface MyOrder ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton* _btn1;
    UIButton* _btn2;
    UIButton* _btn3;

    UITableView* _tableView;
    
//    UIView* labelView;
//    UILabel* haveAddressLab;
  
    NSMutableArray* _orderSidArr;
    NSMutableArray* _orderProductAmountArr;
    NSMutableArray* _orderProductArr;
    //存product具体数据的数组
    NSMutableArray* _dataProductArr;
    //存订单信息的数组
    NSMutableArray* _dataArr;
    
    NSInteger _showState;
    NSString* _orderStateStr;
    
    
}

@property(nonatomic, strong)NSArray* orderArray;

@end

@implementation MyOrder

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _showState = 1;
    
    _orderStateStr = [NSString stringWithFormat:@"受理中"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    
    _orderSidArr = [NSMutableArray new];
    _orderProductAmountArr = [NSMutableArray new];
    _orderProductArr = [NSMutableArray new];
    _dataArr = [NSMutableArray new];
    _dataProductArr = [NSMutableArray new];
    
    
    [self postGetData];
    
    [self createTopBar];
    
    [self createTableView];
#ifdef __IPHONE_11_0
    if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
}
//-(void)createLabel{
//    labelView = [UIView new];
//    labelView.frame = CGRectMake(0,  100, SC_WIDTH, 100);
//    haveAddressLab = [UILabel new];
//    haveAddressLab.frame = CGRectMake(0,0, SC_WIDTH, 100);
//    haveAddressLab.textColor = [UIColor grayColor];
//    haveAddressLab.text = @"暂无商品信息";
//    haveAddressLab.textAlignment = NSTextAlignmentCenter;
//    haveAddressLab.font = [UIFont systemFontOfSize:15];
//    [labelView addSubview:haveAddressLab];
//
//}
#pragma mark ❀==============❂ 向服务器请求数据 分别存储 ❂==============❀
- (void)postGetData{
    [_orderSidArr removeAllObjects];
    [_orderProductAmountArr removeAllObjects];
    [_orderProductArr removeAllObjects];
    [_dataArr removeAllObjects];
    [_dataProductArr removeAllObjects];
    //post字典
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* accountStr = [ud objectForKey:@"userNumber"];
    NSDictionary *dict0 = @{
                            @"account":accountStr,
                            @"State":_orderStateStr
                            };
    NSString *urlString = @"http://219.235.6.7:8080/bedding/dingdan/select.action";

    AFHTTPSessionManager *manger =[AFHTTPSessionManager manager];

    //post数据
    [manger POST:urlString parameters:dict0 progress:^(NSProgress * _NonnulluploadProgress){
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        //解析数据
        NSLog(@"responseObject==%@",responseObject);
        
        if (responseObject) {
            
            NSArray* rootArr = (NSArray *)responseObject;
            self.orderArray = (NSArray *)responseObject;
            NSLog(@"arr==%@",rootArr);
            
            //对sid和samount进行解析 存入对应数组
            for (NSDictionary* dicSid in rootArr) {
                [_orderSidArr addObject:[dicSid objectForKey:@"sid"]];
                [_orderProductAmountArr addObject:[dicSid objectForKey:@"samount"]];
            }
            //解析订单数组，将每个订单内的商品数组对象，存入product数组
            for (NSDictionary* dicRoot in rootArr) {
                OrderNumModel* modelRoot = [OrderNumModel SimWithDict:dicRoot];
                
                //订单信息数组
                [_dataArr addObject:modelRoot];
                
                //将每个订单的商品数组对象存入数组
                [_orderProductArr addObject:[dicRoot objectForKey:@"ddList"]];
                
            }
            //对数组对象进行解析
            for (NSArray* productArrTemp in _orderProductArr) {
                for (NSDictionary* dicProduct in productArrTemp) {
                    ProductModel* productModel = [ProductModel SimWithDict:dicProduct];
                    
                    
                    //存储全部商品信息数组
                    [_dataProductArr addObject:productModel];
                }
            }

            [_tableView reloadData];
            }
        
        }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"error----%@",error);
    }];
   
    
}
#pragma mark ❀==============❂ 创建顶部视图 ❂==============❀
-(void)createTopBar
{
    UIView* topView = [UIView new];
    _btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH/3, 30)];
    _btn2 = [[UIButton alloc]initWithFrame:CGRectMake(SC_WIDTH/3, 0, SC_WIDTH/3, 30)];
    _btn3 = [[UIButton alloc]initWithFrame:CGRectMake(SC_WIDTH/3 * 2, 0, SC_WIDTH/3, 30)];
   
    topView.frame = CGRectMake(0, NAVSTASTUS, SC_WIDTH, 30);
    
    [_btn1 setTitle:@"受理中" forState:UIControlStateNormal];
    _btn1.titleLabel.font = [UIFont systemFontOfSize:12];
    [_btn2 setTitle:@"待收货" forState:UIControlStateNormal];
    _btn2.titleLabel.font = [UIFont systemFontOfSize:12];
    [_btn3 setTitle:@"退款" forState:UIControlStateNormal];
    _btn3.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [_btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    
    _btn1.selected = YES;
    
    [_btn1 addTarget:self action:@selector(clickReload:) forControlEvents:UIControlEventTouchUpInside];
    [_btn2 addTarget:self action:@selector(clickReload:) forControlEvents:UIControlEventTouchUpInside];
    [_btn3 addTarget:self action:@selector(clickReload:) forControlEvents:UIControlEventTouchUpInside];
  
    topView.backgroundColor = ColorRGB(252, 251, 255);
    
    [topView addSubview:_btn1];
    [topView addSubview:_btn2];
    [topView addSubview:_btn3];

    
    [self.view addSubview:topView];
    
}

#pragma mark ❀==============❂ button点击事件 ❂==============❀
-(void)clickReload:(UIButton *)btn{
    if (btn==_btn1) {
        _showState = 1;
        _btn1.selected = YES;
        _btn2.selected = NO;
        _btn3.selected = NO;
     
        _orderStateStr = [NSString stringWithFormat:@"受理中"];
        
    }
    else if(btn==_btn2){
        _showState = 2;
        _btn1.selected = NO;
        _btn2.selected = YES;
        _btn3.selected = NO;

        _orderStateStr = [NSString stringWithFormat:@"待收货"];
    }
    else{
        _showState = 3;
        _btn1.selected = NO;
        _btn2.selected = NO;
        _btn3.selected = YES;
     
        _orderStateStr = [NSString stringWithFormat:@"退款"];
    }
    [self postGetData];
}
#pragma mark ❀==============❂ 创建tableview ❂==============❀
-(void)createTableView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVSTASTUS + 30 , SC_WIDTH, SC_HEIGHT - NAVSTASTUS - 30 ) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    
    UIView *view = [[UIView alloc] init];
    
    view.frame = CGRectMake(0, 0, SC_WIDTH, 20);
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, SC_WIDTH-40, 10)];
    OrderNumModel* orderModel = [_dataArr objectAtIndex:section];
    NSString* strTemp = [NSString stringWithFormat:@"订单编号 %@",orderModel.sddnumber];
    lab.font = [UIFont systemFontOfSize:12];
    lab.text = strTemp;
    view.backgroundColor = ColorRGB(241, 242, 246);
    [view addSubview:lab];
    
    
    return view;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellStr =[NSString stringWithFormat:@"cellID"];
    ProductCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    ProductModel* productModel = [_dataProductArr objectAtIndex:indexPath.row];

    //加载图片
    NSString* tempURL = [NSString stringWithFormat:@"%@",productModel.spic1];
    [cell.productPic sd_setImageWithURL:[NSURL URLWithString:tempURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRetryFailed];
    //标题
    cell.productName.text = [NSString stringWithFormat:@"%@+%@",productModel.stitle,productModel.sname];
    //价格
    cell.productPrice.text = [NSString stringWithFormat:@"%@",productModel.sprice];
    
    //解析数量数组中的字符串
//    NSString* str = [NSString stringWithFormat:@"数量×%@",productModel.samount];
//    cell.productSum.text = str;
    cell.productSum.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark ❀==============❂ 等服务器数据 对model里的count做判断 ❂==============❀
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //解析sid和samount数组中的字符串 dataArr.count = section
    NSString* strTemp = [NSString  stringWithFormat:@"%@",_orderSidArr[section]];
    NSInteger numOfRow = 1;
    for (int i = 0; i < strTemp.length; i++) {
        NSString* temp =[NSString stringWithFormat:@"%c",[strTemp characterAtIndex:i]];
        
        if ([temp isEqualToString:@","]) {
            numOfRow = numOfRow + 1;
        }
    }
    
    return numOfRow;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_btn1.selected) {
        NSLog(@"数据上传服务器，转跳下一页");
        
        NSDictionary* orderDic = self.orderArray[indexPath.section];
        NSLog(@"orderDic:%@", orderDic);
        
        NSArray* ddList = orderDic[@"ddList"];
        
        NSMutableArray* productIDArr = [NSMutableArray array];
        NSMutableArray* titleArr = [NSMutableArray array];
        NSMutableArray* priceArr = [NSMutableArray array];
        //NSMutableArray* sumArr = [NSMutableArray array];
        NSMutableArray* picUrlArr = [NSMutableArray array];
        
        for (NSDictionary* dic in ddList) {
            [productIDArr addObject:dic[@"sid"]];
            [titleArr addObject:dic[@"stitle"]];
            [priceArr addObject:dic[@"sprice"]];
            //[sumArr addObject:dic[@""]];
            [picUrlArr addObject:dic[@"spic1"]];
        }
        
        NSString* sumArrStr = orderDic[@"samount"];
        NSArray* sumArr = [sumArrStr componentsSeparatedByString:@","];
        
        NSInteger totalMoney = 0;
        for (int i = 0; i < priceArr.count; i++) {
            totalMoney += [priceArr[i] integerValue] * [sumArr[i] integerValue];
        }
        
        OrderVC* order = [OrderVC new];
        order.orderNumber = orderDic[@"sddnumber"];
        order.shoptime = [orderDic[@"sshoptime"] integerValue];
        
        //数据传递给下一页
        order.orderProductIDArr = productIDArr;
        order.orderNameArr = titleArr;
        order.orderTitleArr = titleArr;
        order.orderPriceArr = priceArr;
        order.orderSumArr = [NSMutableArray arrayWithArray:sumArr];
        order.orderPicUrlArr = picUrlArr;
        order.priceStr = [NSString stringWithFormat:@"%ld", totalMoney];
        [self.navigationController pushViewController:order animated:YES];
    }
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
