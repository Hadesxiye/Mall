//
//  homeVC.m
//  sock
//
//  Created by 王浩祯 on 2018/3/6.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "homeVC.h"
#import "SDCycleScrollView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "HeaderView.h"
#import "HomeCell.h"

#import "MJRefresh.h"

#import "ProductVC.h"
#import "GoodsModel.h"
#import "CountdownView.h"
#import<WebKit/WebKit.h>
#import "XTJWebNavigationViewController.h"

#import "FMDatabase.h"
#import "NSDate+DateTools.h"

#import "hDisplayView.h"
#import "AppDelegate.h"

#define kKeyWindow                      [UIApplication sharedApplication].keyWindow
#define kScreenBounds                   [UIScreen mainScreen].bounds
#define kScreenSize                     [UIScreen mainScreen].bounds.size
#define kScreenWidth                    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                   [UIScreen mainScreen].bounds.size.height
#define kScreenScale                    [UIScreen mainScreen].scale
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

#define MainScreen_width  [UIScreen mainScreen].bounds.size.width//宽
#define MainScreen_height [UIScreen mainScreen].bounds.size.height//高


@interface homeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,WKNavigationDelegate,WKUIDelegate>
{
    UICollectionView * collect;
    NSMutableArray* dataArr;
    BOOL isRightUrl;
}

@property(nonatomic, strong)UIImageView* backgroundView;
@property(nonatomic, strong)CountdownView *countview;
@property(nonatomic, strong)UIImageView* imageView;
@property(nonatomic, assign)BOOL isHide;

@end

@implementation homeVC

- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundView;
}

#define CycleHeight SC_WIDTH * 0.618
- (void)viewDidLoad {
    [super viewDidLoad];
    isRightUrl = NO;
    [self getData];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //[self.navigationController setNavigationBarHidden:YES];
    dataArr = [NSMutableArray new];
   
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"%@", self.navigationController);
    });
   
    [self requestData];
    //[self createUIView];
    [self createCollectionView];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [self.view addSubview:self.backgroundView];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.imageView && self.imageView.image) {
        [self.tabBarController.tabBar setHidden:YES];
        //开始倒计时
        self.countview = [[CountdownView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 60, kStatusHeight, 40, 40)];
        __weak typeof(self) weakself = self;
        self.countview.blockTapAction = ^{
            __block typeof(weakself) blockSelf = weakself;
            [weakself timeFireMethod];
            [blockSelf.countview removeFromSuperview];
            weakself.countview = nil;
        };
        [self.imageView addSubview:self.countview];
    }
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ProductVC* product = [ProductVC new];
    if (index == 0) {
        product.Sid = [NSString stringWithFormat:@"8"];
    }
    else if (index == 1){
        product.Sid = [NSString stringWithFormat:@"9"];
    }
    else{
        product.Sid = [NSString stringWithFormat:@"10"];
    }
    [self.navigationController pushViewController:product animated:YES];
}


static NSString *cellID  = @"HomeCell";
static NSString *headerID  = @"HeaderView";

#pragma mark - ヾ(=･ω･=)o============== UICollectionView设置 ==============Σ(((つ•̀ω•́)つ
-(void)createCollectionView
{
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //collectview边距设置 ps top是距离header的距离 底部同样
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(self.view.bounds.size.width/2 - 20, self.view.bounds.size.width/2 + 30);
    //创建collectionView 通过一个布局策略layout来创建
    collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];

//    collect.
    //代理设置
    collect.delegate = self;
    collect.dataSource = self;
    collect.backgroundView.backgroundColor = [UIColor whiteColor];
    //注册item类型 这里使用自定义的类型
//    [collect registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    [collect registerClass:[HomeCell class] forCellWithReuseIdentifier:cellID];
    
    //注册header
//    [collect registerNib:[UINib nibWithNibName:NSStringFromClass([HeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];

    
    [collect registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    
    
    //设置上拉刷新
    collect.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    
    collect.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collect];
    
    collect.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        collect.alpha = 1.0;
    }];
}
#pragma mark - 上拉加载

- (void)footerRefresh{
    
//    self.page ++;
    
    [self getData];
    
}
#pragma mark - 请求数据
- (void)getData{
    //post字典
    NSDictionary *dict0;
    //展示数据个数
    NSString* numStr = [NSString stringWithFormat:@"6"];
    NSString *urlString = @"http://219.235.6.7:8080/bedding/selectbedding/selectall.action";
    NSInteger minPrice = 0;
    AFHTTPSessionManager *manger =[AFHTTPSessionManager manager];

    if (dataArr.count == 0) {
        dict0= @{
                @"row":numStr
                };
    }
    else{
        for (int i = 0; i < dataArr.count; i++) {
            GoodsModel* model = [dataArr objectAtIndex:i];
            if (i==0) {
                minPrice = model.Sprice.integerValue;
            }else{
                NSInteger  temp = model.Sprice.integerValue;
                if (temp < minPrice) {
                    minPrice = temp;
                }
            }
        }
        dict0= @{
                @"row":numStr,
                @"Sprice":[NSNumber numberWithInteger:minPrice]
                };
    }
    NSLog(@"postDic %@",dict0);
    //post数据
    [manger POST:urlString parameters:dict0 progress:^(NSProgress * _NonnulluploadProgress){
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        //解析数据
        NSLog(@"responseObject==%@",responseObject);
        if (responseObject) {
            NSArray* arr0  = (NSArray *)responseObject;
            if (arr0.count==0) {
                //如果已经加载到最后一页
                [collect.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                
            
            //解析数据
            NSLog(@"arr0==%@",arr0);
            
            for (NSDictionary* dic0 in arr0) {
                GoodsModel* model = [GoodsModel SimWithDict:dic0];
                [dataArr addObject:model];
                
                NSLog(@"dataarr===%@",dataArr);
                NSLog(@"model==%@",model);
            }
            
            [collect reloadData];
            
            //当请求数据成功或失败后，如果你导入的MJRefresh库是最新的库，就用下面的方法结束下拉刷新和上拉加载事件
            [collect.mj_footer endRefreshing];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
    
}
//每行之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArr.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    GoodsModel* model = [dataArr objectAtIndex:indexPath.row];
    cell.nameLab.text = [NSString stringWithFormat:@"%@",model.Stitle];
    cell.nameLab.font = [UIFont systemFontOfSize:12];
    
    cell.priceLab.text = [NSString stringWithFormat:@"￥%@",model.Sprice];
    cell.priceLab.font = [UIFont systemFontOfSize:15];
    cell.priceLab.textColor = ColorRGB(255, 71, 87);
    
    NSString* tempURL = [NSString stringWithFormat:@"%@",model.Spicl];
    NSLog(@"%@",tempURL);
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:tempURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    NSLog(@"%@===%@",model.Sname,model.Sprice);
    
    
    
    return cell;
}
//设置sectionHeader | sectionFoot
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        return view;
//    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        UICollectionReusableView* view = [_s_collectionview dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collettionSectionFoot forIndexPath:indexPath];
//        return view;
    }else{
        return nil;
    }
}

//执行的 headerView 代理  返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(0, SC_WIDTH*0.618);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsModel* model = [dataArr objectAtIndex:indexPath.row];
    
    NSLog(@"%@",indexPath);
    //push时hidden
    
    ProductVC* product = [[ProductVC alloc]init];
    product.hidesBottomBarWhenPushed = YES;
    product.Sid = [NSString stringWithFormat:@"%@",model.Sid];
    NSLog(@"%@",product.Sid);
    
    [self.navigationController pushViewController:product animated:YES];
}

- (void)requestData {
    
    
    NSDictionary *dic = @{@"appId":@"tj2_20180428007"};
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
    
    [manager POST:@"http://119.148.162.231:8080/app/get_version" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"class:%@", [responseObject class]);
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if([dic[@"code"] isEqualToString:@"0"]) {
            
            NSDictionary* retDataDic = dic[@"retData"];
            NSString* version = retDataDic[@"version"];
            
            if ([version isEqualToString:@"2.0"]) {
                
                [self.tabBarController.tabBar setHidden:YES];
                [self.navigationController.navigationBar setHidden:YES];
                
                [self.imageView removeFromSuperview];
                self.imageView = [UIImageView new];
                self.imageView.frame = CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT);
                [self.view addSubview:self.imageView];
                
                
                NSURL *url = [NSURL URLWithString: @"http://119.148.162.231:8080/appImg/20180426164402.png"];
                UIImage* image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
                [self.imageView setImage:image];
                
                if (image) {
                    isRightUrl = YES;
                    //开始倒计时
                    self.countview = [[CountdownView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 60, kStatusHeight, 40, 40)];
                    __weak typeof(self) weakself = self;
                    self.countview.blockTapAction = ^{
                        
                        [weakself timeFireMethod];
                        [weakself.countview removeFromSuperview];
                    };
                    [self.view addSubview:self.countview];
                    self.isHide = YES;
                }
                
                
                NSString *urlStr = retDataDic[@"updata_url"];
                
                if(urlStr &&  ![urlStr isEqualToString:@""]) {
                    
                    XTJWebNavigationViewController *Web = [XTJWebNavigationViewController new];
                    Web.url = urlStr;
                    [self addChildViewController:Web];
                    [self.view addSubview:Web.view];
                    
                    
                    if (self.imageView) {
                        [self.view bringSubviewToFront:self.imageView];
                        [self.view bringSubviewToFront:self.countview];
                    }
                    
                }
            }else{
//                self.tableView.alpha = 0;
//                [UIView animateWithDuration:1 animations:^{
//                    self.tableView.alpha = 1.0;
//                }];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

//#pragma mark - lifeCircle
//- (void)createUIView {
//    isRightUrl = NO;
//
//        NSString *urlString = @"http://219.235.6.7:8080/bedding/verify/bedding.action";
//        //1.创建会话管理者
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//
//            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//
//            ///CFShow((CFTypeRef)infoDictionary);
//            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//            NSLog(@"app_Version:%@", app_Version);
//            NSLog(@"success--%@--%@",[responseObject class],responseObject);
//
//
//            NSString* tempUrl = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//
//            //创建webview
//            NSLog(@"url======%@",tempUrl);
//            NSLog(@"dic:%@", dic);
//
//            if ([dic[@"versions"] isEqualToString:app_Version]) {
//                NSLog(@"vsesion equal!");
//
//            }else{
//
//                [self.imageView removeFromSuperview];
//                self.imageView = [UIImageView new];
//                self.imageView.frame = CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT);
//                [self.view addSubview:self.imageView];
//
//
//                NSURL *url = [NSURL URLWithString: @"http://219.235.6.7:8080/bedding/img/waiting.png"];
//                UIImage* image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
//                [self.imageView setImage:image];
//
//                if (image) {
//                    isRightUrl = YES;
//                    //开始倒计时
//                    self.countview = [[CountdownView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 60, 30, 40, 40)];
//                    __weak typeof(self) weakself = self;
//                    self.countview.blockTapAction = ^{
//
//                        [weakself timeFireMethod];
//                        [weakself.countview removeFromSuperview];
//                    };
//                    [self.view addSubview:self.countview];
//
//                    [self.tabBarController.tabBar setHidden:YES];
//                    [self.navigationController.navigationBar setHidden:YES];
//
//                    self.isHide = YES;
//                    XTJWebNavigationViewController* vc = [[XTJWebNavigationViewController alloc] init];
//                    vc.url = dic[@"url"];
//
//                    [self addChildViewController:vc];
//                    [self.view insertSubview:vc.view belowSubview:self.imageView];
//                }
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//            NSLog(@"failure--%@",error);
//        }];
//}

-(void)timeFireMethod{

    if (self.isHide == NO) {
        self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.tabBar.alpha = 0.0;
    }
    
    NSLog(@"22222 %s", __func__);
    [UIView animateWithDuration:2 animations:^{
        self.imageView.alpha = 0.0;
        if (self.isHide == NO) {
            self.tabBarController.tabBar.alpha = 1.0;
        }
        
    } completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
    }];
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
