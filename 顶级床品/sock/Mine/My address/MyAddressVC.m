//
//  MyAddressVC.m
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "MyAddressVC.h"
#import "AddressCell.h"
#import "Address+CoreDataClass.h"
#import "MBProgressHUD.h"

@interface MyAddressVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton* addBtn;
    UIView* addAddressView;
    UIView* backgroundView;
    UITableView* _tableView;
    
    NSString* tempAddressID;
    NSString* nameTemp;
    NSString* phoneTemp;
    NSString* addressTemp;
    
    
    NSMutableArray* _nameArr;
    NSMutableArray* _phoneArr;
    NSMutableArray* _addressArr;
    NSMutableArray* _idArr;
    
    UITextField* nameField;
    UITextField* phoneField;
    UITextField* addressField;
    UIButton* yesBtn;
    UIButton* cancelBtn;
    
    int KeyboardHeight;
    
    NSManagedObjectContext *context;
    BOOL haveAddress;
    
    UILabel* haveAddressLab;
    UIView* labelView;
}

@end

@implementation MyAddressVC

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    haveAddress = NO;
    [self createLabel];
    //初始化数据暂存数组
    _nameArr = [NSMutableArray new];
    _phoneArr = [NSMutableArray new];
    _addressArr = [NSMutableArray new];
    _idArr = [NSMutableArray new];

 
    //初始化coredata
    [self getData];
    //创建导航栏右上角button
    [self setNavRightButton];

    //查询是否有数据
    [self checkModel];
    
    [self createTableView];
    
    [self createAddressView];
    
//    [self insertOperationName:@"测试" phone:@"11111111" address:@"地址地址地址地址地址地址地址地址地址地址地址"];
//
//    [self inquireOperation];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}
#pragma mark - ❀==============❂ 键盘高度获取 ❂==============❀
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    KeyboardHeight = keyboardRect.size.height;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{
        addAddressView.frame = CGRectMake(0, SC_HEIGHT/3 * 2 - KeyboardHeight , SC_WIDTH, SC_HEIGHT/3);
        
    } completion:^(BOOL finished) {
        NSLog(@"动画结束");
    }];
}
//当键退出时调用 改变addressview的高度
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{
        addAddressView.frame = CGRectMake(0, SC_HEIGHT/3 * 2 , SC_WIDTH, SC_HEIGHT/3);
        
    } completion:^(BOOL finished) {
        NSLog(@"动画结束");
    }];
}
-(void)setNavRightButton
{
//    addBtn = [UIButton new];
//    addBtn.frame = CGRectMake(0, 0, 30, 30);
//    [addBtn setBackgroundImage:[UIImage imageNamed:@"plusIcon.png"] forState:UIControlStateNormal];
//    [addBtn setBackgroundColor:[UIColor clearColor]];
//    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIBarButtonItem* rigthBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAddress)];
    
    self.navigationItem.rightBarButtonItem  = rigthBtn;
    
}
#pragma mark ❀==============❂ 查询是否有数据 ❂==============❀
-(void)checkModel{
    [self inquireOperation];
    
    if (haveAddress==NO) {
        [self createPromptView];
        NSLog(@"新建地址pls");
        _tableView.hidden = YES;
    }
    else{
        _tableView.hidden = NO;
        NSLog(@"已存在数据 ");
    }
    
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
#pragma mark ❀==============❂ 生成时间ID ❂==============❀
-(void)getTempAddressID
{
    //获取当前时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents  *components  =  [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitYear fromDate:[NSDate date]];
    NSLog(@"%ld年%ld月%ld日%ld时%ld分%ld秒" ,(long)components.year ,(long)components.month,(long)components.day,(long)components.hour,(long)components.minute,(long)components.second);
    
    tempAddressID = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld",(long)components.year ,(long)components.month,(long)components.day,(long)components.hour,(long)components.minute,(long)components.second];
}
#pragma mark ❀==============❂ 显示提示新建地址图 ❂==============❀
-(void)createPromptView
{
//    [self textWaiting:[NSString stringWithFormat:@"暂无地址，请新建地址"]];
}
#pragma mark ❀==============❂ coredata数据存储 ❂==============❀
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
#pragma mark ❀==============❂ 插入操作 ❂==============❀
-(void)insertOperationWithID:(NSString* )addressID Name:(NSString *)nameStr phone:(NSString* )phoneStr address:(NSString *)addressStr{
    // 创建托管对象，并指明创建的托管对象所属实体名
    Address *address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:context];
    
    address.addressID = tempAddressID;
    address.name = nameStr;
    address.phone = phoneStr;
    address.address = addressStr;
  
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
-(void)deleteOperationWithID:(NSString *)idStr{
    // 建立获取数据的请求对象，指明对Employee实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Address"];
    // 创建谓词对象，过滤出符合要求的对象，也就是要删除的对象
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"addressID = %@", idStr];
    request.predicate = predicate;
    // 执行获取操作，找到要删除的对象
    NSError* error = nil;
    NSArray *employees = [context executeFetchRequest:request error:&error];
    // 遍历符合删除要求的对象数组，执行删除操作
    [employees enumerateObjectsUsingBlock:^(Address * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
#pragma mark ❀==============❂ 修改操作 ❂==============❀
-(void)modifyOperationWithName:(NSString *)nameStr newName:(NSString *)newName newPhone:(NSString *)newPhone newAddress:(NSString *)newAddress{
    // 建立获取数据的请求对象，并指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Address"];
    // 创建谓词对象，设置过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", nameStr];
    request.predicate = predicate;
    // 执行获取请求，获取到符合要求的托管对象
    NSError *error = nil;
    NSArray *addresses = [context executeFetchRequest:request error:&error];
    [addresses enumerateObjectsUsingBlock:^(Address * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.name = newName;
        obj.phone = newPhone;
        obj.address = newAddress;
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
-(void)createLabel{
    labelView = [UIView new];
    labelView.frame = CGRectMake(0,  100, SC_WIDTH, 100);
    haveAddressLab = [UILabel new];
    haveAddressLab.frame = CGRectMake(0,0, SC_WIDTH, 100);
    haveAddressLab.textColor = [UIColor grayColor];
    haveAddressLab.text = @"暂无地址，点击右上角新建地址";
    haveAddressLab.textAlignment = NSTextAlignmentCenter;
    haveAddressLab.font = [UIFont systemFontOfSize:15];
    [labelView addSubview:haveAddressLab];

}
#pragma mark ❀==============❂ 查询操作并给数组赋值 ❂==============❀
-(void)inquireOperation{
    
    [_nameArr removeAllObjects];
    [_phoneArr removeAllObjects];
    [_addressArr removeAllObjects];
    [_idArr removeAllObjects];
    
    
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
        [_idArr addObject:obj.addressID];
        
        NSLog(@"Address name : %@, phone : %@, address : %@ ,ID  %@", obj.name, obj.phone, obj.address,obj.addressID);
 
    }];
    if (addresses.count == 0) {
         NSLog(@"数据库没有数据，请新建地址！！");
        haveAddress = NO;
    }
    else
    {
        haveAddress = YES;
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
}
    

#pragma mark ❀==============❂ 创建tableview ❂==============❀
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //移除分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* strID = [NSString stringWithFormat:@"cellID"];
    AddressCell* cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell==nil) {
        cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
        
    }
    UIView* xianView = [UIView new];
    xianView.frame = CGRectMake(20, 69, SC_WIDTH - 40, 1);
    xianView.backgroundColor = ColorRGB(242, 242, 242);
    [cell addSubview:xianView];
    cell.name.text = _nameArr[indexPath.row];
    cell.phoneNum.text = _phoneArr[indexPath.row];
    cell.address.text = _addressArr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_idArr.count==0) {
        [self.view addSubview:labelView];
    }
    else{
        [labelView removeFromSuperview];
    }
    return _idArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
#pragma mark ❀==============❂ cell点击事件,block传值 ❂==============❀
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取当前点击的cell
    if ([_isSelected isEqualToString:@"yes"]) {
        NSString* nameTemp = [NSString stringWithFormat:@"%@",_nameArr[indexPath.row]];
        NSString* phoneTemp = [NSString stringWithFormat:@"%@",_phoneArr[indexPath.row]];
        NSString* addressTemp = [NSString stringWithFormat:@"%@",_addressArr[indexPath.row]];
        
        __weak typeof(self) weakself = self;
        
        if (weakself.returnAddressBlock) {
            //将自己的值传出去，完成传值
            weakself.returnAddressBlock(nameTemp,phoneTemp,addressTemp);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        return;
    }
}
#pragma mark ❀==============❂ 侧滑删除cell ❂==============❀
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    
    //删除数据，和删除动画
    NSString* tempID = [NSString stringWithFormat:@"%@",_idArr[indexPath.row]];
    [_nameArr removeObjectAtIndex:indexPath.row];
    [_phoneArr removeObjectAtIndex:indexPath.row];
    [_addressArr removeObjectAtIndex:indexPath.row];
    [_idArr removeObjectAtIndex:indexPath.row];
    
    [self deleteOperationWithID:tempID];
    
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark ❀==============❂ 显示和隐藏addressview ❂==============❀
-(void)addAddress
{
    nameField.text = nil ;
    phoneField.text = nil ;
    addressField.text = nil ;
    backgroundView.hidden = NO;
    addAddressView.hidden = NO;
    
    [nameField resignFirstResponder];
    [phoneField resignFirstResponder];
    [addressField resignFirstResponder];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{
        addAddressView.frame = CGRectMake(0, SC_HEIGHT/3 * 2, SC_WIDTH, SC_HEIGHT/3);
        
    } completion:^(BOOL finished) {
        NSLog(@"动画结束");
    }];
    
}
-(void)hidAddress:(UIButton *)btn
{
    NSLog(@"点击了%@",btn.titleLabel.text);
    if (btn==yesBtn) {
        if (nameField.text == nil||[nameField.text isEqualToString:@""]) {
            [self textWaiting:[NSString stringWithFormat:@"请输入联系人姓名"]];
            return;
        }
        if (phoneField.text == nil||[phoneField.text isEqualToString:@""]) {
            [self textWaiting:[NSString stringWithFormat:@"请输入联系人电话"]];
            return;
        }
        if (addressField.text == nil||[addressField.text isEqualToString:@""]) {
            [self textWaiting:[NSString stringWithFormat:@"请输入收货地址"]];
            return;
        }
 
        [self getTempAddressID];
        [self insertOperationWithID:tempAddressID Name:nameField.text phone:phoneField.text address:addressField.text];
        [self inquireOperation];
        [_tableView reloadData];
 
    }
    else
    {
        
    }
    
    [nameField resignFirstResponder];
    [phoneField resignFirstResponder];
    [addressField resignFirstResponder];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{
        addAddressView.frame = CGRectMake(0, SC_HEIGHT, SC_WIDTH, SC_HEIGHT/3);
        
    } completion:^(BOOL finished) {
        NSLog(@"动画结束");
        backgroundView.hidden = YES;
        addAddressView.hidden = YES;
    }];
    
    
}
#pragma mark ❀==============❂ 创建addressview ❂==============❀
-(void)createAddressView{
    addAddressView = [UIView new];
    addAddressView.frame = CGRectMake(0, SC_HEIGHT, SC_WIDTH, SC_HEIGHT/3);
    addAddressView.backgroundColor = ColorRGB(241, 242, 246);
    
//    backgroundView = [UIView new];
//    backgroundView.frame = CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT);
//    backgroundView.backgroundColor = [UIColor colorWithRed:178/255.0 green:190/255.0 blue:195/255.0 alpha:0.5];
//    [self.view addSubview:backgroundView];
    backgroundView.hidden = YES;
    
    yesBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    yesBtn.frame = CGRectMake(SC_WIDTH - 70 , 10, 50, 30);
    cancelBtn.frame = CGRectMake(20 , 10, 50, 30);
    
    
    [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [yesBtn addTarget:self action:@selector(hidAddress:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(hidAddress:) forControlEvents:UIControlEventTouchUpInside];
    

    [addAddressView addSubview:yesBtn];
    [addAddressView addSubview:cancelBtn];
    
    nameField = [UITextField new];
    nameField.frame = CGRectMake(30, 50, SC_WIDTH - 60, 40);
    nameField.placeholder = @"请输入联系人姓名";
    nameField.backgroundColor = [UIColor clearColor];;
    
    phoneField = [UITextField new];
    phoneField.frame = CGRectMake(30, 100 , SC_WIDTH -60 , 40);
    phoneField.placeholder = @"请输入联系人电话";
    phoneField.backgroundColor = [UIColor clearColor];
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    addressField = [UITextField new];
    addressField.frame = CGRectMake(30, 150 , SC_WIDTH - 60 , 40);
    addressField.placeholder = @"请输入邮寄地址";
    addressField.backgroundColor = [UIColor clearColor];;

    [addAddressView addSubview:nameField];
    [addAddressView addSubview:phoneField];
    [addAddressView addSubview:addressField];
    [self.view addSubview:addAddressView];
    
  
    
    
    addAddressView.hidden = YES;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [nameField resignFirstResponder];
    [phoneField resignFirstResponder];
    [addressField resignFirstResponder];
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
