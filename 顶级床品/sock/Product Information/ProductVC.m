//
//  ProductVC.m
//  sock
//
//  Created by 王浩祯 on 2018/3/7.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "ProductVC.h"

#import "FECGoodsDetailLayout.h"
#import "DetailCell.h"
#import "AFNetworking.h"

#import "ShoppingCartVC.h"
#import "OrderVC.h"
#import "ProductDetailModel.h"
#import "ProductInCart+CoreDataClass.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface ProductVC ()
{
    UIButton* leftBtn;
    UIButton* rightBtn;
    UIButton* shoppingIconBtn;
    NSMutableArray* dataArr;
    NSMutableArray* urlArr;
    FECGoodsDetailLayout* detailView;
    
    NSManagedObjectContext *context;
    NSMutableArray* _productIDInData;
    NSMutableArray* _productSumInData;
    
    //选择数量view子控件
    UIView* _chooseSumView;
    UIButton* _cancelBtn;
    UIButton* _confirmBtn;
    UIButton* _addSumBtn;
    UIButton* _minSumBtn;
    UILabel* _sumLab;
    NSInteger _sum;
    BOOL isJunp;
}



@end

@implementation ProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isJunp = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    urlArr = [NSMutableArray new];
    dataArr = [NSMutableArray new];
    _productIDInData = [NSMutableArray new];
    _productSumInData = [NSMutableArray new];
    //设置导航栏返回时显示的文字
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self getCoreData];
    [self getData];
    [self createShoppingIcon];
    
    
    [self createButtonView];

    
    
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
#pragma mark ヾ(=･ω･=)o============== 购物车图标 ==============Σ(((つ•̀ω•́)つ
-(void)createShoppingIcon
{
    shoppingIconBtn = [[UIButton alloc]initWithFrame:CGRectMake(SC_WIDTH-70, SC_HEIGHT-120, 50, 50)];
    [shoppingIconBtn addTarget:self action:@selector(clickToShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    [shoppingIconBtn setBackgroundColor:[UIColor clearColor]];
    [shoppingIconBtn setBackgroundImage:[UIImage imageNamed:@"购物车.png"] forState:UIControlStateNormal];
    [self.view addSubview:shoppingIconBtn];
}
#pragma mark ヾ(=･ω･=)o============== 创建按钮视图 ==============Σ(((つ•̀ω•́)つ
-(void)createButtonView
{
    UIView* buttomView = [UIView new];
    buttomView.frame = CGRectMake(0, SC_HEIGHT-buttonHeight, SC_WIDTH, buttonHeight);
    
    leftBtn = [UIButton new];
    rightBtn = [UIButton new];
    
    leftBtn.frame = CGRectMake(0, 0, SC_WIDTH/2, buttonHeight);
    rightBtn.frame = CGRectMake(SC_WIDTH/2, 0, SC_WIDTH/2, buttonHeight);
    
    [leftBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:ColorRGB(251, 197, 49)];
    [leftBtn addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:ColorRGB(232, 65, 24)];
    [rightBtn addTarget:self action:@selector(clickBuy) forControlEvents:UIControlEventTouchUpInside];
    
    [buttomView addSubview:leftBtn];
    [buttomView addSubview:rightBtn];
    [self.view addSubview:buttomView];
}
#pragma mark ❀==============❂ coredata数据存储 ❂==============❀
-(void)getCoreData{
    // 创建上下文对象，并发队列设置为主队列
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    // 创建托管对象模型，并使用.xcdatamodeled前缀路径当做初始化参数
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"ShoppingCartData" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
    // 创建持久化存储调度器
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", @"ShoppingCartData"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
    // 上下文对象设置属性为持久化存储器
    context.persistentStoreCoordinator = coordinator;
}

#pragma mark ❀==============❂ 插入操作 ❂==============❀
-(void)insertOperation{
    
    ProductDetailModel* model = [dataArr objectAtIndex:0];
    NSLog(@"model = %@",model);
    
    // 创建托管对象，并指明创建的托管对象所属实体名
    
    ProductInCart *products = [NSEntityDescription insertNewObjectForEntityForName:@"ProductInCart" inManagedObjectContext:context];
 
    NSLog(@"sid==%@ name %@  price %@  spic %@",model.sid,model.sname,model.sprice,model.spic1);
    

    products.productID = [NSString stringWithFormat:@"%@",model.sid];
    
    //products.title = [NSString stringWithFormat:@"%@",model.sname];
    products.title = [NSString stringWithFormat:@"%@",model.stitle];
    
    products.price = [NSString stringWithFormat:@"%@",model.sprice];
    
    products.sum = [NSString stringWithFormat:@"%ld",_sum];
    
    products.picUrl = [NSString stringWithFormat:@"%@",model.spic1];
    
    // 通过上下文保存对象，并在保存前判断是否有更改
    NSError *error = nil;
    if (context.hasChanges) {
        [context save:&error];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Insert Data Error : %@", error);
    }
}
#pragma mark ❀==============❂ 删除操作 ❂==============❀
-(void)deleteOperationWithIDArr:(NSArray *)productIDArr{
    // 建立获取数据的请求对象，指明对Employee实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProductInCart"];
    // 创建谓词对象，过滤出符合要求的对象，也就是要删除的对象
    for (int i = 0; i < productIDArr.count; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productID = %@", productIDArr[i]];
        request.predicate = predicate;
        // 执行获取操作，找到要删除的对象
        NSError* error = nil;
        NSArray *employees = [context executeFetchRequest:request error:&error];
        // 遍历符合删除要求的对象数组，执行删除操作
        [employees enumerateObjectsUsingBlock:^(ProductInCart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [context deleteObject:obj];
        }];
        // 保存上下文
        if (context.hasChanges) {
            [context save:nil];
        }
        // 错误处理
        if (error) {
            NSLog(@"CoreData Delete Data Error : %@", error);
        }
    }
    
}
#pragma mark ❀==============❂ 修改操作 ❂==============❀
-(void)modifyOperationWithExistID:(NSString *)existID NewSum:(NSString *)sum{
    // 建立获取数据的请求对象，并指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProductInCart"];
    // 创建谓词对象，设置过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productID = %@", existID];
    request.predicate = predicate;
    // 执行获取请求，获取到符合要求的托管对象
    NSError *error = nil;
    NSArray *addresses = [context executeFetchRequest:request error:&error];
    [addresses enumerateObjectsUsingBlock:^(ProductInCart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        obj.sum = sum;
        
    }];
    // 将上面的修改进行存储
    if (context.hasChanges) {
        [context save:nil];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Update Data Error : %@", error);
    }
}
#pragma mark ❀==============❂ 查询操作并给数组赋值 ❂==============❀
-(void)inquireOperation{
    
    [_productIDInData removeAllObjects];
    [_productSumInData removeAllObjects];
 
    // 建立获取数据的请求对象，指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProductInCart"];
    // 执行获取操作，获取所有Employee托管对象
    NSError *error = nil;
    NSArray *addresses = [context executeFetchRequest:request error:&error];
    [addresses enumerateObjectsUsingBlock:^(ProductInCart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
        
        [_productIDInData addObject:obj.productID];
        [_productSumInData addObject:obj.sum];
        
        NSLog(@"id : %@  sum  %@", obj.productID,obj.sum);
        
    }];
    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
}


#pragma mark ヾ(=･ω･=)o============== 点击事件 ==============Σ(((つ•̀ω•́)つ
-(void)clickToShoppingCart
{
    NSLog(@"进入购物车!");
    ShoppingCartVC* shop = [ShoppingCartVC new];
    [self.navigationController pushViewController:shop animated:YES];
    
}

-(void)clickAdd
{
    [self chooseSumView];
    
    NSLog(@"加入购物车!");
    
    
}
-(void)clickBuy //数据依旧存入数据库，同时页面传值给订单页面  订单界面点击支付时，从数据库根据id删除数据
{
    NSLog(@"立即购买！");
    //执行add操作
    isJunp = YES;
    [self clickAdd];

}
#pragma mark - ❀==============❂ 选择数量view ❂==============❀
-(void)chooseSumView{
    _chooseSumView = [UIView new];
    _chooseSumView.frame = CGRectMake(0, SC_HEIGHT - 250 - buttonHeight , SC_WIDTH, 250 + buttonHeight);
    _chooseSumView.backgroundColor = ColorRGB(241, 242, 246);
    //150 150
    ProductDetailModel* model = [dataArr objectAtIndex:0];
    NSString* urlStr = [NSString stringWithFormat:@"%@",model.spic1];
    UIImageView* sumViewImageView = [UIImageView new];
    sumViewImageView.frame = CGRectMake(20,20 , 100, 100);
    [sumViewImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:SDWebImageRetryFailed];
    [_chooseSumView addSubview:sumViewImageView];
    
    //价格label
    UILabel* priceLab = [UILabel new];
    priceLab.frame = CGRectMake(140 , 40, 200, 30);
    priceLab.textColor = ColorRGB(255, 71, 87);
    priceLab.text = [NSString stringWithFormat:@"￥%@",model.sprice];
    priceLab.font  = [UIFont systemFontOfSize:20];
    [_chooseSumView addSubview:priceLab];
    
    //库存label
    UILabel* kucunLab = [UILabel new];
    kucunLab.frame = CGRectMake(140, 70, 200, 30);
    kucunLab.text = [NSString stringWithFormat:@"库存: %@",model.samount];
    kucunLab.textColor = ColorRGB(87, 96, 111);
    [_chooseSumView addSubview:kucunLab];
    
    //尺码label
    UILabel* chimaLab1 = [UILabel new];
    chimaLab1.frame = CGRectMake(20, 150, 80, 30);
    chimaLab1.text = @"尺码";
    chimaLab1.font = [UIFont boldSystemFontOfSize:20];
    [_chooseSumView addSubview:chimaLab1];
    
    UILabel* chimaLab2 = [UILabel new];
    chimaLab2.frame = CGRectMake(80, 150, 100, 30);
    chimaLab2.text = [NSString stringWithFormat:@"%@",model.ssize];
    chimaLab2.textColor = ColorRGB(87, 96, 111);
    chimaLab2.textAlignment = NSTextAlignmentCenter;
    chimaLab2.font = [UIFont systemFontOfSize:18];
    [_chooseSumView addSubview:chimaLab2];
    
    //数量
    UILabel* sumTitleLab = [UILabel new];
    sumTitleLab.frame = CGRectMake(20, 200, 80, 30);
    sumTitleLab.text = @"数量";
    sumTitleLab.font = [UIFont boldSystemFontOfSize:20];
    [_chooseSumView addSubview:sumTitleLab];
    
    UIImageView* sumBackView = [UIImageView new];
    sumBackView.frame = CGRectMake(80, 200, 100, 30);
    [sumBackView setImage:[UIImage imageNamed:@"biankuang"]];
    sumBackView.userInteractionEnabled = YES;
    _sum = 1;
    _sumLab = [UILabel new];
    _addSumBtn = [UIButton new];
    _minSumBtn = [UIButton new];
    
    _sumLab.frame = CGRectMake(30, 0, 40, 30);
    _sumLab.text = [NSString stringWithFormat:@"%ld",_sum];
    _sumLab.textAlignment = NSTextAlignmentCenter;
    [sumBackView addSubview:_sumLab];
 
    _addSumBtn.frame = CGRectMake(75, 5, 20, 20);
    [_addSumBtn setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [_addSumBtn addTarget:self action:@selector(addSum) forControlEvents:UIControlEventTouchUpInside];
    [sumBackView addSubview:_addSumBtn];
    
    _minSumBtn.frame = CGRectMake(5, 5, 20, 20);
    [_minSumBtn setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    [_minSumBtn addTarget:self action:@selector(minSum) forControlEvents:UIControlEventTouchUpInside];
    [sumBackView addSubview:_minSumBtn];
    
    [_chooseSumView addSubview:sumBackView];
    //确定取消按钮
    _cancelBtn = [UIButton new];
    _cancelBtn.frame = CGRectMake(0, 250 , SC_WIDTH/2, buttonHeight);
    [_cancelBtn setBackgroundColor:ColorRGB(116, 125, 140)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(chooseSumViewCancel) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_chooseSumView addSubview:_cancelBtn];
    
    _confirmBtn = [UIButton new];
    _confirmBtn.frame = CGRectMake(SC_WIDTH/2, 250, SC_WIDTH/2, buttonHeight);
    [_confirmBtn setBackgroundColor:ColorRGB(232, 65, 24)];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(chooseSumViewConfirm) forControlEvents:UIControlEventTouchUpInside];
    [_chooseSumView addSubview:_confirmBtn];
    
   
    
    
    [self.view addSubview:_chooseSumView];
}
-(void)chooseSumViewCancel{
    [_chooseSumView removeFromSuperview];
    isJunp = NO;
    return;
}
-(void)addSum{
    if (_sum < 100) {
        _sum = _sum + 1;
        _sumLab.text = [NSString stringWithFormat:@"%ld",_sum];
    }
    else{
        return;
    }
}
-(void)minSum{
    if (_sum > 1) {
        _sum = _sum - 1;
        _sumLab.text = [NSString stringWithFormat:@"%ld",_sum];
    }
    else{
        return;
    }
}
-(void)chooseSumViewConfirm{
    //查询数据库是否存在id
    ProductDetailModel* model = [dataArr objectAtIndex:0];
    [self inquireOperation];
    
    //如果数据库没数据
    if (_productIDInData.count==0) {
        //获取id sum 存入 productid 和 productSum
        [self insertOperation];
    }
    //如果数据库有数据
    else{
        BOOL haveData = NO;
        for (int i = 0; i < _productIDInData.count; i++) {
            //如果存在，则修改此id的数据,查询原来的sum,和现在的sum相加判断 ，得出新的sum传入修改
            if ([_productIDInData[i] isEqualToString:model.sid]) {
                NSString* tempID = [NSString stringWithFormat:@"%@",_productIDInData[i]];
                
                NSString* tempSum = [NSString stringWithFormat:@"%@",_productSumInData[i]];
                NSInteger _sumtemp = 0;
                _sumtemp = _sum + tempSum.integerValue;
                
                if (_sumtemp > 99) {
                    tempSum = [NSString stringWithFormat:@"99"];
                }
                else{
                    tempSum = [NSString stringWithFormat:@"%ld",_sumtemp];
                }
                [self modifyOperationWithExistID:tempID NewSum:tempSum];
                haveData = YES;
                break;
            }
            //判断不存在，插入数据
            else{
                
            }
        }
        //遍历结束依旧没有数据,则插入数据
        if (haveData == NO) {
            [self insertOperation];
        }
    }
    //如果是点击的立即购买
    if (isJunp==YES) {
        //界面传值
        OrderVC* order = [OrderVC new];
        
        ProductDetailModel* model = [dataArr objectAtIndex:0];
        NSMutableArray* tempIDArr = [NSMutableArray arrayWithObject:model.sid];
        NSMutableArray* tempPicUrl = [NSMutableArray arrayWithObject:model.spic1];
        NSMutableArray* tempNameArr = [NSMutableArray arrayWithObject:model.sname];
        NSMutableArray* tempTitleArr = [NSMutableArray arrayWithObject:model.stitle];
        NSString* tempPrice = [NSString stringWithFormat:@"%@",model.sprice];
        NSMutableArray* tempPriceArr = [NSMutableArray arrayWithObject:tempPrice];
        NSString* tempSum = [NSString stringWithFormat:@"%ld",_sum];
        NSMutableArray* tempSumArr = [NSMutableArray arrayWithObject:tempSum];
        
        order.orderProductIDArr = tempIDArr;
        order.orderPicUrlArr = tempPicUrl;
        order.orderNameArr = tempNameArr;
        order.orderTitleArr = tempTitleArr;
        order.orderPriceArr = tempPriceArr;
        order.orderSumArr = tempSumArr;
        
        NSString* priceStrTemp = [NSString stringWithFormat:@"%@",model.sprice];
//        NSString* sumStr = [NSString stringWithFormat:@"%@",model.samount];
        double singlePrice = priceStrTemp.doubleValue;
        double totalSum = tempSum.doubleValue;
        order.priceStr = [NSString stringWithFormat:@"%.2f",singlePrice * totalSum];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:order animated:YES];
        isJunp = NO;
    }
    //点击的加入购物车
    else{
        
    }
    [_chooseSumView removeFromSuperview];
    
}
#pragma mark - ❀==============❂ 获取网络数据 ❂==============❀
-(void)getData{
    //post字典
    NSDictionary *dict0;
    
    NSString *urlString = @"http://219.235.6.7:8080/bedding/selectbedding/selectone.action";
    
    AFHTTPSessionManager *manger =[AFHTTPSessionManager manager];
    dict0= @{
             @"Sid":_Sid
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
            
            ProductDetailModel* model = [ProductDetailModel SimWithDict:dicRoot];
            [dataArr addObject:model];
            
            urlArr = [NSMutableArray arrayWithObjects:model.spic1,model.spic2,model.spic3, nil];
            //调用方法
            //初始化实例
            
            detailView = [[FECGoodsDetailLayout alloc]init];
            //    [detailView setGoodsDetailLayout:self WebViewURL:@"https://www.baidu.com" IsConverAnimation:YES bottomHeighr:0 Url:];
            [detailView setGoodsDetailLayout:self WebViewURL:@"" IsConverAnimation:YES bottomHeighr:0 :urlArr cellModel:model];
            NSLog(@"%@",dataArr);
            }
 
         [self createUI];
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark ヾ(=･ω･=)o============== 创建视觉差视图 ==============Σ(((つ•̀ω•́)つ
-(void)createUI
{
    

    //滚动监听
    detailView.scrollScreenBlock = ^(BOOL isFirst){
        if (isFirst) {
            NSLog(@"滚动到了第一屏");
        }else{
            NSLog(@"第二屏");
        }
    };
}
//利用生命周期设置是否隐藏 navigationBar
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
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
