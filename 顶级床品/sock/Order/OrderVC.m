//
//  OrderVC.m
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "OrderVC.h"
#import "TimeAndNumCell.h"
#import "ProductCell.h"
#import "AddressCell.h"
#import "KuaiDICell.h"
#import "NormalCell.h"
#import "ProductVC.h"
#import "MyAddressVC.h"
#import "Address+CoreDataClass.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface OrderVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSString* _createTime;
    NSString* _orederTime;
    NSString* _orderNum;
    
    UILabel* leftLab;
    UIButton* rightBtn;
    UIView* buttomView;
    
    NSString* nameTempStr;
    NSString* phoneTempStr;
    NSString* addressTempStr;
    
    NSManagedObjectContext *context;
    NSMutableArray* _nameArr;
    NSMutableArray* _phoneArr;
    NSMutableArray* _addressArr;
    
    //地址信息
//    NSString* _addressName;
//    NSString* _addressPhone;
//    NSString* _address;
    
}
@end

@implementation OrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"填写订单";
    _nameArr = [NSMutableArray new];
    _phoneArr = [NSMutableArray new];
    _addressArr = [NSMutableArray new];
    
    [self getData];
    [self inquireOperation];
    
    [self createButtomView];
    
    [self getOrderNumAndTime];
    
    [self createTableview];
    
}

#pragma mark ---- 将时间戳转换成时间
- (NSString *)getTimeFromTimestampWithTime:(NSInteger)time{
    //将对象类型的时间转换为NSDate类型
    
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

#pragma mark - ❀==============❂ 获取订单编号和时间 ❂==============❀
-(void)getOrderNumAndTime
{
    if (_orderNumber) {
        _orderNum = _orderNumber;
        _createTime = [self getTimeFromTimestampWithTime:_shoptime];
    }else{
    //获取当前时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents  *components  =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMinute | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitSecond | NSCalendarUnitDay fromDate:[NSDate date]];
    NSLog(@"%ld月%ld日%ld时%ld分" ,(long)components.month,(long)components.day,(long)components.hour,(long)components.minute);
    _createTime = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",(long)components.year,(long)components.month,(long)components.day,(long)components.hour,(long)components.minute,(long)components.second];
//    _createTime = [NSString stringWithFormat:@"%ld月%ld日%ld时%ld分" ,(long)components.month,(long)components.day,(long)components.hour,(long)components.minute];
    _orderNum =[NSString stringWithFormat:@"%ld%02ld%02ld%02ld%02ld%02ld%@",(long)components.year,(long)components.month,(long)components.day,(long)components.hour,(long)components.minute,(long)components.second,[self getRandomStringWithNum:6]];
    }
    
}
#pragma mark - ❀==============❂ 生成数字字母随机数 ❂==============❀
- (NSString *)getRandomStringWithNum:(NSInteger)num
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}
#pragma mark - ❀==============❂ 底部view ❂==============❀
-(void)createButtomView
{
    buttomView = [UIView new];
    buttomView.frame = CGRectMake(0, SC_HEIGHT-buttonHeight, SC_WIDTH, buttonHeight);
    
    leftLab = [UILabel new];
    rightBtn = [UIButton new];
    
    leftLab.frame = CGRectMake(0, 0, SC_WIDTH/2, buttonHeight);
    rightBtn.frame = CGRectMake(SC_WIDTH/2, 0, SC_WIDTH/2, buttonHeight);
    
    leftLab.textAlignment = NSTextAlignmentCenter;
    leftLab.backgroundColor = ColorRGB(251, 197, 49);

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_priceStr];
    
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 4)];
    
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(4, _priceStr.length - 4)];
    
    leftLab.text = [NSString stringWithFormat:@"¥：%@",_priceStr] ;
    leftLab.textColor = [UIColor whiteColor];
    
    [rightBtn setTitle:@"支付" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:ColorRGB(232, 65, 24)];
    [rightBtn addTarget:self action:@selector(clickPay) forControlEvents:UIControlEventTouchUpInside];
    
    [buttomView addSubview:leftLab];
    [buttomView addSubview:rightBtn];
    [self.view addSubview:buttomView];
}
#pragma mark - ❀==============❂ 按钮点击事件 ❂==============❀
-(void)clickPay
{
    [self postDataGetUrl];
    
//    UIAlertAction* action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self postDataGetUrl];
//    }];
//    
//    UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:@"请咨询店员是否有优惠折扣。" preferredStyle:UIAlertControllerStyleAlert];
//    [ac addAction:action];
//    [self presentViewController:ac animated:YES completion:nil];
    
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
#pragma mark - ❀==============❂ 向服务器提交订单请求支付 ❂==============❀
-(void)postDataGetUrl{
    
    
    NSString *urlString = @"http://219.235.6.7:8080/bedding/dingdan/insert.action";
    
    AFHTTPSessionManager *manger =[AFHTTPSessionManager manager];
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* accountStr = [ud objectForKey:@"userNumber"];
    if (accountStr==nil) {
        [self textWaiting:[NSString stringWithFormat:@"请先登录"]];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
//    if (nameTempStr==nil) {
//        [self textWaiting:[NSString stringWithFormat:@"请选择收货地址"]];
//        return;
//    }
    
    //将数组转为字符串
    NSString* _orderProductIDStr;
    NSString* _orderProductSumStr;
    
    _orderProductIDStr = [NSString new];
    _orderProductSumStr = [NSString new];

    for (int i = 0; i < _orderProductIDArr.count; i++) {
        if (i==_orderProductIDArr.count - 1) {
            NSString* temp = [NSString stringWithFormat:@"%@",_orderProductIDArr[i]];
            NSString* temp1 = [NSString stringWithFormat:@"%@",_orderSumArr[i]];
                
            _orderProductIDStr = [_orderProductIDStr stringByAppendingString:temp];
            _orderProductSumStr = [_orderProductSumStr stringByAppendingString:temp1];
        }
        else{
            NSString* temp = [NSString stringWithFormat:@"%@,",_orderProductIDArr[i]];
            NSString* temp1 = [NSString stringWithFormat:@"%@,",_orderSumArr[i]];
            
            _orderProductSumStr = [_orderProductSumStr stringByAppendingString:temp1];
            _orderProductIDStr = [_orderProductIDStr stringByAppendingString:temp];
        }
    }

    NSLog(@"%@==%@",_orderProductIDStr,_orderProductSumStr);
    
    NSString* state = [NSString stringWithFormat:@"受理中"];
    //post字典
    NSDictionary *dict0 = @{
                    //商品id    数组
                    @"Sid":_orderProductIDStr,
                    //上页传值 数组
                    @"Samount":_orderProductSumStr,
                    //year-mounth-day hour:minute:second
                    @"Sshoptime":_createTime,
                    @"State":state,
                    @"Saddress":addressTempStr ?:@"",
                    @"account":accountStr,
                    @"Sphonenumber":phoneTempStr ?:@"",
                    @"Sddnumber":_orderNum,
                    @"Srealname":nameTempStr?:@""
                    
                 };
        NSLog(@"postDic %@",dict0);
        //post数据
        [manger POST:urlString parameters:dict0 progress:^(NSProgress * _NonnulluploadProgress){
            
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"成功");
            //解析数据
            NSLog(@"responseObject==%@",responseObject);
            if (responseObject) {
                
                NSDictionary* dicRoot = (NSDictionary *)responseObject;
                
                //解析数据
                NSLog(@"arr0==%@",dicRoot);
                NSString* msg = [dicRoot objectForKey:@"url"];
                NSLog(@"%@",msg);
                NSString* state = [dicRoot objectForKey:@"state"];
                if (state.integerValue == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alipayqr://platformapi/startapp?saId=10000007&clientVersion=3.7.0.0718&qrcode=HTTPS://QR.ALIPAY.COM/FKX00409VR1PL1CW1VQ994"]];
                    
                }
            }
         
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    
}
#pragma mark - ❀==============❂ 创建tableview ❂==============❀
-(void)createTableview
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT-buttonHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //订单编号和时间
    if (indexPath.section == 0) {
        NSString* cellStr =[NSString stringWithFormat:@"cellID0"];
        TimeAndNumCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if(cell==nil)
        {
            cell = [[TimeAndNumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.number.text = _orderNum;
        cell.time.text = _createTime;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }

    //产品列表
    else if (indexPath.section == 1){
        NSString* cellStr =[NSString stringWithFormat:@"cellID1"];
        ProductCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if(cell==nil)
        {
            cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //设置图片
        NSString* tempURL = [NSString stringWithFormat:@"%@",_orderPicUrlArr[indexPath.row]];
        [cell.productPic sd_setImageWithURL:[NSURL URLWithString:tempURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRetryFailed];
     
        //标题
        cell.productName.text = _orderTitleArr[indexPath.row];
        //价格
        cell.productPrice.text =  [NSString stringWithFormat:@"%@", _orderPriceArr[indexPath.row]];
        //数量
        NSString* str = [NSString stringWithFormat:@"数量×%@",_orderSumArr[indexPath.row]];
        cell.productSum.text = str;
        cell.productSum.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    
    //快递 地址 支付
    else if(indexPath.section==2)
    {
        if (indexPath.row==1) {
            NSString* cellStr =[NSString stringWithFormat:@"cellID2"];
            AddressCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if(cell==nil)
            {
                cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            //对地址数据库做判断，如果为空，显示点击添加cell
            cell.name.text = nameTempStr;
            cell.phoneNum.text = phoneTempStr;
            cell.address.text = addressTempStr;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            if (indexPath.row==0) {

                NSString* cellStr = [NSString stringWithFormat:@"cellID3"];
                KuaiDICell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
                if (cell==nil) {
                    cell = [[KuaiDICell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
                }
                cell.titleLab.text = @"快递信息";
                cell.kuaiDiLab.text = @"顺丰快递";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if (indexPath.row==2) {
                NSString* cellStr = [NSString stringWithFormat:@"cellID4"];
                NormalCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
                if (cell==nil) {
                    cell = [[NormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
                }
                //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLab.text = @"支付宝支付";


                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                NSString* cellStr = [NSString stringWithFormat:@"cellID5"];
                UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }

        }
    }
    else
    {
        NSString* cellStr = [NSString stringWithFormat:@"cellID6"];
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else if(section==1){
        return _orderTitleArr.count;
    }
    else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //订单编号和时间高度
    if (indexPath.section==0) {
        return 70;
    }
    //产品列表高度
    else if (indexPath.section==1){
        return 120;
    }
    
    else if(indexPath.section==2){
        //快递
        if (indexPath.row==0) {
            return 50;
        }
        //地址
        else if (indexPath.row==1) {
            return 80;
        }
        //支付
        else if (indexPath.row==2){
            return 50;
        }
        else{
            return 50;
        }

    }
    else
    {
        return 50;
    }
    
}
#pragma mark - ❀==============❂ coredata数据存储 ❂==============❀
-(void)getData{
    // 创建上下文对象，并发队列设置为主队列
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    // 创建托管对象模型，并使用.xcdatamodeled前缀路径当做初始化参数
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"addressModel" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
    // 创建持久化存储调度器
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", @"addressModel"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
    // 上下文对象设置属性为持久化存储器
    context.persistentStoreCoordinator = coordinator;
}
#pragma mark - ❀==============❂ 查询操作并给数组赋值 ❂==============❀
-(void)inquireOperation{
    
    [_nameArr removeAllObjects];
    [_phoneArr removeAllObjects];
    [_addressArr removeAllObjects];
    
    
    // 建立获取数据的请求对象，指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Address"];
    // 执行获取操作，获取所有Employee托管对象
    NSError *error = nil;
    NSArray *addresses = [context executeFetchRequest:request error:&error];
    [addresses enumerateObjectsUsingBlock:^(Address * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
        
        [_nameArr addObject:obj.name];
        [_phoneArr addObject:obj.phone];
        [_addressArr addObject:obj.address];

        
        NSLog(@"Address name : %@, phone : %@, address : %@ ,ID  %@", obj.name, obj.phone, obj.address,obj.addressID);
        
    }];
    if (addresses.count == 0) {
        NSLog(@"数据库没有数据，请新建地址！！");
        addressTempStr = [NSString stringWithFormat:@"点击新建地址"];
    }
    else
    {
        nameTempStr = [NSString stringWithFormat:@"%@",_nameArr[0]];
        phoneTempStr = [NSString stringWithFormat:@"%@",_phoneArr[0]];
        addressTempStr = [NSString stringWithFormat:@"%@",_addressArr[0]];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
}
#pragma mark - ❀==============❂ cell点击事件 ❂==============❀
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //商品列表点击事件
    if (indexPath.section==1) {
        ProductVC* productVC = [ProductVC new];
        self.hidesBottomBarWhenPushed = YES;
        //传递数据
        [self.navigationController pushViewController:productVC animated:YES];
        
    }
    else if (indexPath.section == 2 ){
        if (indexPath.row == 1) {
            MyAddressVC* addressVC = [MyAddressVC new];
                
            //赋值Block，并将捕获的值赋值给 NSString
            addressVC.returnAddressBlock = ^(NSString *nameStr, NSString *phoneStr, NSString *addressStr) {
                nameTempStr = [NSString stringWithFormat:@"%@",nameStr];
                phoneTempStr = [NSString stringWithFormat:@"%@",phoneStr];
                addressTempStr = [NSString stringWithFormat:@"%@",addressStr];
                [_tableView reloadData];
            };
            addressVC.isSelected = [NSString stringWithFormat:@"yes"];
            [self.navigationController pushViewController:addressVC animated:YES];
        }
        
    }
    //支付宝支付等
    else{
        
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
