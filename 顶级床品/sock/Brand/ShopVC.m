//
//  ShopVC.m
//  sock
//
//  Created by 周峻觉 on 2018/4/28.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "ShopVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ShopVC ()
{
    NSInteger mapStyle;
}
@property(nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation ShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor = [UIColor blueColor];

    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.scrollView.frame = self.view.bounds;
    
    UIView* shopView1 = [self createShopViewWith:@"正大旗舰店" address:@"上海市浦东新区陆家嘴西路168号正大广场3楼" image:[UIImage imageNamed:@"门店1.png"]];
    [self.scrollView addSubview:shopView1];
    
    UIView* shopView2 = [self createShopViewWith:@"新世界旗舰店" address:@"上海市淮海中路300号香港新世界大厦购物广场G层" image:[UIImage imageNamed:@"门店2.png"]];
    [self.scrollView addSubview:shopView2];
    CGRect frame = shopView2.frame;
    frame.origin.y = CGRectGetMaxY(shopView1.frame);
    shopView2.frame = frame;
    
    UIView* shopView3 = [self createShopViewWith:@"港汇店" address:@"上海市徐汇区虹桥路1号港汇广场4楼" image:[UIImage imageNamed:@"门店3.png"]];
    [self.scrollView addSubview:shopView3];
    frame = shopView3.frame;
    frame.origin.y = CGRectGetMaxY(shopView2.frame);
    shopView3.frame = frame;
    
    UIView* shopView4 = [self createShopViewWith:@"万达店" address:@"上海市杨浦区邯郸路660号万达商业广场b1楼" image:[UIImage imageNamed:@"门店4.png"]];
    frame = shopView4.frame;
    frame.origin.y = CGRectGetMaxY(shopView3.frame);
    shopView4.frame = frame;
    
    shopView1.userInteractionEnabled = YES;
    shopView2.userInteractionEnabled = YES;
    shopView3.userInteractionEnabled = YES;
    shopView4.userInteractionEnabled = YES;
    
    //给uiview添加点击事件
    UITapGestureRecognizer *tapGesturRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1:)];
    UITapGestureRecognizer *tapGesturRecognizer2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction2:)];
    UITapGestureRecognizer *tapGesturRecognizer3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction3:)];
    UITapGestureRecognizer *tapGesturRecognizer4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction4:)];
    
    [shopView1 addGestureRecognizer:tapGesturRecognizer1];
    [shopView2 addGestureRecognizer:tapGesturRecognizer2];
    [shopView3 addGestureRecognizer:tapGesturRecognizer3];
    [shopView4 addGestureRecognizer:tapGesturRecognizer4];
    
    [self.scrollView addSubview:shopView1];
    [self.scrollView addSubview:shopView2];
    [self.scrollView addSubview:shopView3];
    [self.scrollView addSubview:shopView4];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(shopView4.frame)+30);
}
-(void)tapAction1:(id)tap
{
    mapStyle = 1;
    [self mapJump];
}
-(void)tapAction2:(id)tap
{
    mapStyle = 2;
    [self mapJump];
}
-(void)tapAction3:(id)tap
{
    mapStyle = 3;
    [self mapJump];
}
-(void)tapAction4:(id)tap
{
    mapStyle = 4;
    [self mapJump];
    
}
#pragma mark - ❀==============❂ 地图转跳 ❂==============❀
-(void)mapJump{
    //判断安装的app
    BOOL baidu = [self APCheckIfAppInstalled:@"baidumap://"];
    BOOL gaode = [self APCheckIfAppInstalled:@"iosamap://"];
    //弹出响应的提示框
    //显示弹出框列表选择
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
                                                        }];
    
    UIAlertAction* Apple = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [self Apple];
                                                         }];
    if (baidu) {
        UIAlertAction* Baidu = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self baidu];
                                                      }];
        [alert addAction:Baidu];
    }
    if (gaode) {
        UIAlertAction* Gaode = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self gaode];
                                                      }];
        [alert addAction:Gaode];
    }
    
    [alert addAction:Apple];
    [alert addAction:cancelAction];
    
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
}
-(void)baidu{
    if (mapStyle==1) {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/geocoder?address=上海市浦东新区陆家嘴西路168号正大广场3楼&src=webapp.geo.yourCompanyName.yourAppName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else if (mapStyle == 2){
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/geocoder?address=上海市淮海中路300号香港新世界大厦购物广场G层&src=webapp.geo.yourCompanyName.yourAppName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else if (mapStyle == 3){
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/geocoder?address=上海市徐汇区虹桥路1号港汇广场4楼&src=webapp.geo.yourCompanyName.yourAppName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else{
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/geocoder?address=上海市杨浦区邯郸路660号万达商业广场b1楼&src=webapp.geo.yourCompanyName.yourAppName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}
-(void)gaode{
    //http://uri.amap.com/marker?position=116.473195,39.993253&name=首开广场&src=mypage&coordinate=gaode&callnative=0
    if (mapStyle==1) {
        NSString *urlString = [[NSString stringWithFormat:@"http://uri.amap.com/marker?position=121.499321,31.237055"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else if (mapStyle == 2){
        NSString *urlString = [[NSString stringWithFormat:@"http://uri.amap.com/marker?position=121.473575,31.223527"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else if (mapStyle == 3){
        NSString *urlString = [[NSString stringWithFormat:@"http://uri.amap.com/marker?position=121.437035,31.194229"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else{
        NSString *urlString = [[NSString stringWithFormat:@"http://uri.amap.com/marker?position=121.513863,31.300251"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}
-(void)Apple{
    CLGeocoder *geocoder=[CLGeocoder new];
    if (mapStyle==1) {
        // 使用地理信息反编码，来获取位置和信息
        [geocoder geocodeAddressString:@"上海市浦东新区陆家嘴西路168号正大广场3楼" completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"查询记录数目：%i",(int)[placemarks count]);
            if ([placemarks count]>0) {
                CLPlacemark *placemark=placemarks[0];
                
                CLLocationCoordinate2D coordinate=placemark.location.coordinate;
                NSDictionary *address=placemark.addressDictionary;
                
                // MKPlacemark 是地图相关信息的类
                MKPlacemark *place=[[MKPlacemark alloc]initWithCoordinate:coordinate/*位置*/ addressDictionary:address/*相关的信息*/];
                
                // MKMapItem 类封装了有关地图上点的信息
                MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:place];
                // 调用苹果地图的方法
                [mapItem openInMapsWithLaunchOptions:nil];
                
            }
        }];
    }
    else if (mapStyle == 2){
        // 使用地理信息反编码，来获取位置和信息
        [geocoder geocodeAddressString:@"上海市淮海中路300号香港新世界大厦购物广场G层" completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"查询记录数目：%i",(int)[placemarks count]);
            if ([placemarks count]>0) {
                CLPlacemark *placemark=placemarks[0];
                
                CLLocationCoordinate2D coordinate=placemark.location.coordinate;
                NSDictionary *address=placemark.addressDictionary;
                
                // MKPlacemark 是地图相关信息的类
                MKPlacemark *place=[[MKPlacemark alloc]initWithCoordinate:coordinate/*位置*/ addressDictionary:address/*相关的信息*/];
                
                // MKMapItem 类封装了有关地图上点的信息
                MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:place];
                // 调用苹果地图的方法
                [mapItem openInMapsWithLaunchOptions:nil];
                
            }
        }];
    }
    else if (mapStyle == 3){
        // 使用地理信息反编码，来获取位置和信息
        [geocoder geocodeAddressString:@"上海市徐汇区虹桥路1号港汇广场4楼" completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"查询记录数目：%i",(int)[placemarks count]);
            if ([placemarks count]>0) {
                CLPlacemark *placemark=placemarks[0];
                
                CLLocationCoordinate2D coordinate=placemark.location.coordinate;
                NSDictionary *address=placemark.addressDictionary;
                
                // MKPlacemark 是地图相关信息的类
                MKPlacemark *place=[[MKPlacemark alloc]initWithCoordinate:coordinate/*位置*/ addressDictionary:address/*相关的信息*/];
                
                // MKMapItem 类封装了有关地图上点的信息
                MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:place];
                // 调用苹果地图的方法
                [mapItem openInMapsWithLaunchOptions:nil];
                
            }
        }];
    }
    else{
        // 使用地理信息反编码，来获取位置和信息
        [geocoder geocodeAddressString:@"上海市杨浦区邯郸路660号万达商业广场b1楼" completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"查询记录数目：%i",(int)[placemarks count]);
            if ([placemarks count]>0) {
                CLPlacemark *placemark=placemarks[0];
                
                CLLocationCoordinate2D coordinate=placemark.location.coordinate;
                NSDictionary *address=placemark.addressDictionary;
                
                // MKPlacemark 是地图相关信息的类
                MKPlacemark *place=[[MKPlacemark alloc]initWithCoordinate:coordinate/*位置*/ addressDictionary:address/*相关的信息*/];
                
                // MKMapItem 类封装了有关地图上点的信息
                MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:place];
                // 调用苹果地图的方法
                [mapItem openInMapsWithLaunchOptions:nil];
                
            }
        }];
    }
    
}
-(BOOL)APCheckIfAppInstalled:(NSString *)urlSchemes
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlSchemes]])
    {
        NSLog(@" installed");
        
        return  YES;
    }
    else
    {
        return  NO;
    }
}
- (UIView *)createShopViewWith:(NSString *)title address:(NSString *)address image:(UIImage *)image
{
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWith, 50)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame), screenWith-40, (screenWith-40)*467/756)];
    imageView.image = image;
    UILabel* addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(imageView.frame), screenWith-40, 50)];
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.text = address;
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(addressLabel.frame), screenWith-40, 0.4)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWith, CGRectGetMaxY(addressLabel.frame))];
    
    [view addSubview:titleLabel];
    [view addSubview:imageView];
    [view addSubview:addressLabel];
    [view addSubview:line];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
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
