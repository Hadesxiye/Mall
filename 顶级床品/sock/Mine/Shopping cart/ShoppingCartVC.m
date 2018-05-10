 //
//  ShoppingCartVC.m
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "ShoppingCartVC.h"
#import "SDCycleScrollView.h"
#import "OrderVC.h"
#import "ShoppingCartCell.h"
#import "ShoppingCartModel.h"
#import "ProductInCart+CoreDataClass.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface ShoppingCartVC ()<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    UILabel* leftLab;
    UIButton* rightBtn;
    UIButton* editBtn;
    UIView* buttomView;
    UIView* editView;
    
    NSMutableArray* productIDArr;
    NSMutableArray* picUrlArr;
    NSMutableArray* titleArr;
    NSMutableArray* priceArr;
    NSMutableArray* sumArr;
    

    NSMutableArray* isChoose;
    NSMutableArray* editIsChoose;
    BOOL isEdit;
    
    NSMutableArray* indexArr;
    NSManagedObjectContext *context;
}
@end

@implementation ShoppingCartVC
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArr = [NSMutableArray new];
    priceArr = [NSMutableArray new];
    sumArr = [NSMutableArray new];
    picUrlArr = [NSMutableArray new];
    productIDArr = [NSMutableArray new];
    
    
    
    indexArr = [NSMutableArray new];
    
    isEdit = NO;
    editBtn = [UIButton new];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setBackgroundColor:[UIColor clearColor]];
    [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
    editBtn.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem* item0 = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    
    
    //将任何类型的控件添加到导航按钮的方法
//    UIBarButtonItem* item00 = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    //创建按钮数组
//    NSArray* arrayBtn = [NSArray arrayWithObjects:item00 ,nil];
    
    //将右侧按钮数组赋值
    self.navigationItem.rightBarButtonItem = item0;
    
    [self getData];
    
    [self createEditView];
    [self createButtonView];
    
    [self createTableView];
    
    // Do any additional setup after loading the view.
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
#pragma mark - ヾ(=･ω･=)o============== tableview数据模型接收coredata数据 ==============Σ(((つ•̀ω•́)つ
-(void)getData
{
    
    editIsChoose = [NSMutableArray new];
    isChoose = [NSMutableArray new];
    
    //初始化数据库
    [self getCoreData];
    //进行数据查询,查询全部数据给住数组赋值
    [self inquireOperation];
    
    //默认为no，非编辑模式
    isEdit = NO;
    //默认ischoose初始为1，全部选中状态
    
    for (int i = 0; i < productIDArr.count; i ++) {
        
        [isChoose addObject:@"1"];
        //默认editIsChoose初始为0，为全部未选中状态
        [editIsChoose addObject:@"0"];
    }

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
    // 创建托管对象，并指明创建的托管对象所属实体名
    
    ProductInCart *products = [NSEntityDescription insertNewObjectForEntityForName:@"ProductInCart" inManagedObjectContext:context];
    
    products.productID = @"";
    products.title = @"";
    products.price = @"";
    products.sum = @"";
    products.picUrl = @"";
    
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
-(void)deleteOperationWithIDArr:(NSString *)productID{
    // 建立获取数据的请求对象，指明对Employee实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProductInCart"];
    // 创建谓词对象，过滤出符合要求的对象，也就是要删除的对象
    for (int i = 0; i < productIDArr.count; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productID = %@", productID];
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
-(void)modifyOperationWithID:(NSString *)productID resultSum:(NSString *)resultSum{
    // 建立获取数据的请求对象，并指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProductInCart"];
    // 创建谓词对象，设置过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productID = %@", productID];
    request.predicate = predicate;
    // 执行获取请求，获取到符合要求的托管对象
    NSError *error = nil;
    NSArray *addresses = [context executeFetchRequest:request error:&error];
    [addresses enumerateObjectsUsingBlock:^(ProductInCart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //修改数量
        obj.sum = resultSum;
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
    
    [productIDArr removeAllObjects];
    [titleArr removeAllObjects];
    [priceArr removeAllObjects];
    [sumArr removeAllObjects];
    [picUrlArr removeAllObjects];
    
    
    // 建立获取数据的请求对象，指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProductInCart"];
    // 执行获取操作，获取所有Employee托管对象
    NSError *error = nil;
    NSArray *addresses = [context executeFetchRequest:request error:&error];
    [addresses enumerateObjectsUsingBlock:^(ProductInCart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
        
        [productIDArr addObject:obj.productID];
        [titleArr addObject:obj.title];
        [priceArr addObject:obj.price];
        [sumArr addObject:obj.sum];
        [picUrlArr addObject:obj.picUrl];
        
        NSLog(@"id : %@, title : %@ ,price  %@,sum: %@,url: %@", obj.productID, obj.title, obj.price,obj.sum,obj.picUrl);

    }];
    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
}


#pragma mark - ヾ(=･ω･=)o============== 创建tableview ==============Σ(((つ•̀ω•́)つ
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT-buttonHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
}

//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString* cellStr =[NSString stringWithFormat:@"cellID"];
    ShoppingCartCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell = [[ShoppingCartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.titleLab.text = titleArr[indexPath.row];
    
    //加载图片
    NSString* tempURL = [NSString stringWithFormat:@"%@",picUrlArr[indexPath.row]];
//    [cell.productPic sd_setImageWithURL:[NSURL URLWithString:tempURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRetryFailed];
    [cell.productPic sd_setImageWithURL:[NSURL URLWithString:tempURL] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}];

    
    //对价格赋值
    NSString* priceTempStr = [NSString stringWithFormat:@"%@",priceArr[indexPath.row]];
    float priceTemp = priceTempStr.floatValue;
    NSString* temp = [NSString stringWithFormat:@"￥ %.2f",priceTemp];
#pragma mark - ヾ(=･ω･=)o============== 富文本操作 ==============Σ(((つ•̀ω•́)つ
    //进行富文本操作
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:temp];
    
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 2)]; //设置字符串首部前两个字符的文字大小（只是单纯设置文字大小，没有设置文字类型）
    
//    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:20] range:NSMakeRange(0, 2)]; //设置字符串首部前两个字符的文字类型和大小，比如Helvetica-Bold字体，20号字体大小
    
//    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)]; //设置字符串首部前两个字符的文字颜色
    
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(temp.length - 3, 3)];
//    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range]; //设置颜色
    
    cell.priceLab.attributedText = AttributedStr;
    
    //对总数赋值
    cell.sumLab.text = sumArr[indexPath.row];
    
    //给button添加tag和点击事件
    cell.chooseBtn.tag = indexPath.row + 100;
    [cell.chooseBtn addTarget:self action:@selector(productSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    //对button状态进行设置
    //非编辑状态
    if (isEdit == NO) {
        NSString* temp = [NSString stringWithFormat:@"%@",isChoose[indexPath.row]];
        NSInteger zeroOrOne = temp.integerValue;
        //1为选择，0为未选中
        if (zeroOrOne == 0) {
            cell.chooseBtn.selected = NO;
        }
        else{
            cell.chooseBtn.selected = YES;
        }
    }
    //进入编辑状态
    else{
        NSString* temp = [NSString stringWithFormat:@"%@",editIsChoose[indexPath.row]];
        NSInteger zeroOrOne = temp.integerValue;
        //1为选择，0为未选中
        if (zeroOrOne == 0) {
            cell.chooseBtn.selected = NO;
        }
        else{
            cell.chooseBtn.selected = YES;
        }
    }
    
    cell.addBtn.tag = indexPath.row + 200;
    [cell.addBtn addTarget:self action:@selector(produdtAdd:) forControlEvents:UIControlEventTouchUpInside];
    cell.minBtn.tag = indexPath.row + 300;
    [cell.minBtn addTarget:self action:@selector(productMin:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //取消选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return productIDArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
#pragma mark - ヾ(=･ω･=)o============== cell点击事件进入productVC ==============Σ(((つ•̀ω•́)つ
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"进去productVC！");
}
#pragma mark - ヾ(=･ω･=)o============== cell上的按钮点击事件 ==============Σ(((つ•̀ω•́)つ
-(void)productSelected:(UIButton *)btn
{
    //tag-100
    NSInteger tagValue = btn.tag-100;
   
    //判断是否是编辑状态  temp = 1为选中 0为未选中
    //正常状态
    if (isEdit==NO) {

        NSString* temp = isChoose[tagValue];
        
        if ([temp isEqualToString:@"1"]) {
            [isChoose replaceObjectAtIndex:tagValue withObject:@"0"];
        }
        else
        {
            [isChoose replaceObjectAtIndex:tagValue withObject:@"1"];
        }
    }
    //编辑状态
    else{
        NSString* temp = editIsChoose[tagValue];
        
        if ([temp isEqualToString:@"1"]) {
            [editIsChoose replaceObjectAtIndex:tagValue withObject:@"0"];
        }
        else
        {
            [editIsChoose replaceObjectAtIndex:tagValue withObject:@"1"];
        }
    }
    // 刷新数据源方法
    NSUInteger section = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tagValue inSection:section];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

//改变数据模式里对应的数量
-(void)produdtAdd:(UIButton *)btn
{
    //tag-200
    NSInteger tagValue = btn.tag-200;
    
    //resultSumStr 最终sum的str  tempID 修改的idStr
    NSString* tempStr = sumArr[tagValue];
    NSString* tempID = productIDArr[tagValue];
    //判断是否小于99
    if (tempStr.integerValue < 99) {
        NSInteger sumTemp = tempStr.integerValue + 1;
        [sumArr replaceObjectAtIndex:tagValue withObject:[NSString stringWithFormat:@"%ld",sumTemp]];
        
        NSString* resultSumStr = [NSString stringWithFormat:@"%ld",sumTemp];
        //进行数据库修改
        [self modifyOperationWithID:tempID resultSum:resultSumStr];
        // 刷新数据源方法
        NSUInteger section = 0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tagValue inSection:section];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [buttomView removeFromSuperview];
        
        [self createButtonView];
    }
    else
    {
        return;
    }
}
-(void)productMin:(UIButton *)btn
{
    //tag-300
    NSInteger tagValue = btn.tag-300;
    NSString* tempStr = sumArr[tagValue];
    NSString* tempID = productIDArr[tagValue];
    
 
    //tempid 为修改的id resultSumStr为最终sum
    if (tempStr.integerValue > 1) {
        NSInteger sumTemp = tempStr.integerValue - 1;
        NSString* resultSumStr = [NSString stringWithFormat:@"%ld",sumTemp];
        [sumArr replaceObjectAtIndex:tagValue withObject:[NSString stringWithFormat:@"%ld",sumTemp]];
        //修改数据库数据
        [self modifyOperationWithID:tempID resultSum:resultSumStr];
        
        // 刷新数据源方法
        NSUInteger section = 0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tagValue inSection:section];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [buttomView removeFromSuperview];
        [self createButtonView];
    }
    else
    {
        return;
    }
}

#pragma mark - ヾ(=･ω･=)o============== 创建底部视图 ==============Σ(((つ•̀ω•́)つ
-(void)createButtonView
{
    buttomView = [UIView new];
    buttomView.frame = CGRectMake(0, SC_HEIGHT-buttonHeight, SC_WIDTH, buttonHeight);
    
    leftLab = [UILabel new];
    rightBtn = [UIButton new];
    
    leftLab.frame = CGRectMake(0, 0, SC_WIDTH/2, buttonHeight);
    rightBtn.frame = CGRectMake(SC_WIDTH/2, 0, SC_WIDTH/2, buttonHeight);
    
    leftLab.textAlignment = NSTextAlignmentCenter;
    leftLab.backgroundColor = ColorRGB(251, 197, 49);
    float totalPrice = 0;
    for (int i = 0; i<priceArr.count;i++) {
        NSString* priceTemp = [NSString stringWithFormat:@"%@",priceArr[i]];
        NSString* sumTemp = [NSString stringWithFormat:@"%@",sumArr[i]];
        
        totalPrice = totalPrice + priceTemp.floatValue * sumTemp.integerValue;
    }
    //富文本操作
    NSString* temp = [NSString stringWithFormat:@"合计：￥%.2lf",totalPrice];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:temp];
    
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 3)];
    
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(3, temp.length - 3)];
    
    leftLab.attributedText = AttributedStr;
    leftLab.textColor = [UIColor whiteColor];
    
    [rightBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:ColorRGB(232, 65, 24)];
    [rightBtn addTarget:self action:@selector(clickBuy) forControlEvents:UIControlEventTouchUpInside];
    
    [buttomView addSubview:leftLab];
    [buttomView addSubview:rightBtn];
    [self.view addSubview:buttomView];
}
#pragma mark - ヾ(=･ω･=)o============== 编辑状态底部视图 ==============Σ(((つ•̀ω•́)つ
-(void)dealEditView
{
    if (isEdit==NO) {
        buttomView.hidden = YES;
    }
    else{
        buttomView.hidden = NO;
    }
}
#pragma mark - ❀==============❂ 创建编辑状态下底部视图 ❂==============❀
-(void)createEditView
{
    editView = [UIView new];
    editView.frame = CGRectMake(0, SC_HEIGHT-buttonHeight, SC_WIDTH, buttonHeight);
    editView.backgroundColor = [UIColor whiteColor];
    
    
    UIButton* selectAllBtn;
    UIButton* deleteBtn;
    
    selectAllBtn = [UIButton new];
    deleteBtn = [UIButton new];
    
    selectAllBtn.frame = CGRectMake(40, 10, 50, 30);
    deleteBtn.frame = CGRectMake(SC_WIDTH - 110 , 5, 80, 40);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"获取框"] forState:UIControlStateNormal];
    
    
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [selectAllBtn addTarget:self action:@selector(clickSelectAll) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
    
    [editView addSubview:selectAllBtn];
    [editView addSubview:deleteBtn];
    [self.view addSubview:editView];
    editView.hidden = YES;
}
#pragma mark - ❀==============❂ 全选删除操作 ❂==============❀
-(void)clickSelectAll
{
    NSInteger status = 0;//大于0 存在未选中或全部未选中  0全部选中
    for (int i = 0; i < editIsChoose.count; i++) {
        if ([editIsChoose[i] isEqualToString:@"0"]) {
            status = status + 1;
        }
    }
    //全部不是0 全部选中
    if (status == 0 ) {
        for (int n = 0; n < editIsChoose.count; n++) {
            
            [editIsChoose replaceObjectAtIndex:n withObject:@"0"];
        }
    }
    //4个0 全部未选中
    else if (status == editIsChoose.count){
        for (int n = 0; n < editIsChoose.count; n++) {
            
            [editIsChoose replaceObjectAtIndex:n withObject:@"1"];
        }
    }
    //存在未选中切不是全选
    else{
        for (int n = 0; n < editIsChoose.count; n++) {
            
            [editIsChoose replaceObjectAtIndex:n withObject:@"1"];
        }
    }
    
    [_tableView reloadData];
}
    
-(void)clickDelete  //数据库删除操作
{
    [indexArr removeAllObjects];
    
    for (NSInteger i = editIsChoose.count - 1; i >= 0; i--) {
        if ([editIsChoose[i] isEqualToString:@"1"]) {
            //将要删除的位置先存入数组，全部存入再从大开始删。
            [indexArr addObject:[NSString stringWithFormat:@"%ld",i]];
        }
        else{
            
        }
    }
        for (NSInteger n = 0; n < indexArr.count; n++) {
            NSString* temp = [NSString stringWithFormat:@"%@",indexArr[n]];
            NSInteger tempInt = temp.integerValue;
            [editIsChoose removeObjectAtIndex:tempInt];
            [isChoose removeObjectAtIndex:tempInt];
            
            NSLog(@"%@",productIDArr);
            
            NSString* tempID = [NSString stringWithFormat:@"%@",productIDArr[tempInt]];
            //数据库删除
            [self deleteOperationWithIDArr:tempID];
            //数组删除
            [productIDArr removeObjectAtIndex:tempInt];
            [picUrlArr removeObjectAtIndex:tempInt];
            [titleArr removeObjectAtIndex:tempInt];
            [priceArr removeObjectAtIndex:tempInt];
            [sumArr removeObjectAtIndex:tempInt];
            
        }
    
    [_tableView reloadData];
}
#pragma mark - ヾ(=･ω･=)o============== button点击事件 ==============Σ(((つ•̀ω•́)つ
-(void)clickEdit
{
    [self dealEditView];
    //进入编辑模式
    if (isEdit==NO) {
        [editBtn setTitle:@"完成" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        editView.hidden = NO;
    }
    //退出编辑模式
    else{
        //循环刷新editischoose数组，全部置0
        for (int i = 0 ;i < editIsChoose.count ; i++ ) {
            [editIsChoose replaceObjectAtIndex:i withObject:@"0"];
        }
        editView.hidden = YES;
        [buttomView removeFromSuperview];
        [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self createButtonView];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    isEdit = !isEdit;
    [_tableView reloadData];
}
-(void)clickBuy
{
    NSInteger sumSock = 0;
    //对总数进行判断
    for (int i = 0; i < sumArr.count; i++) {
        NSString* temp = [NSString stringWithFormat:@"%@",sumArr[i]];
        sumSock = sumSock + temp.integerValue;
    }

    NSLog(@"数据上传服务器，转跳下一页");
    OrderVC* order = [OrderVC new];
    
    //数据传递给下一页
    order.orderProductIDArr = productIDArr;
    order.orderNameArr = titleArr;
    order.orderTitleArr = titleArr;
    order.orderPriceArr = priceArr;
    order.orderSumArr = sumArr;
    order.orderPicUrlArr = picUrlArr;
    order.priceStr = leftLab.text;
    [self.navigationController pushViewController:order animated:YES];
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
