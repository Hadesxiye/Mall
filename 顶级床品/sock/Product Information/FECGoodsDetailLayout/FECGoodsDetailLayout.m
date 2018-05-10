//
//  FECGoodsDetailLayout.m
//  FECGoodsDetailLayout
//
//  Created by Qinz on 16/11/4.
//  Copyright © 2016年 FEC. All rights reserved.
//

#import "FECGoodsDetailLayout.h"
#import "ProductDetailModel.h"
#import "UIImageView+WebCache.h"

@interface FECGoodsDetailLayout ()<UITableViewDelegate,UITableViewDataSource>
{
    ProductDetailModel* modelRoot;
    NSMutableArray* dataArr;//存model对应的key
    
    NSArray* picURLArr;
    NSInteger picNum;
    
}

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIWebView *webView;


//添加在头部视图的tempScrollView
@property (nonatomic, strong) UIScrollView *tempScrollView;
//记录是否需要滚动视图差效果的动画
@property (nonatomic, assign) BOOL isConverAnimation;
//记录底部空间所需的高度
@property (nonatomic, assign) CGFloat bottomHeight;

@end

@implementation FECGoodsDetailLayout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}


-(void)setGoodsDetailLayout:(UIViewController *)viewController WebViewURL:(NSString *)webViewURL IsConverAnimation:(BOOL)isConverAnimation bottomHeighr:(CGFloat)bottomHeight :(NSArray *)UrlArr cellModel:(ProductDetailModel *)model{
    
    //url解析赋值
    NSString* tempStr = [NSString stringWithFormat:@"%@",model.sproduce];
    picURLArr = [tempStr componentsSeparatedByString:@";"];
    NSLog(@"urlarr==%@",picURLArr);
    picNum = picURLArr.count;
    
    dataArr = [NSMutableArray new];
    dataArr = [NSMutableArray arrayWithObjects:model.stitle,model.sname,model.stexture,model.sprice,model.ssize,model.samount,model.scolor,model.spic1,nil];
    NSLog(@"arr==%@",dataArr);
    
    [self layout:bottomHeight];
    
    //设置上下拉提示的视图
    [self setMsgView:UrlArr];
    
    [viewController.view addSubview:self];
    
    //将视图要置为最底层
    [viewController.view sendSubviewToBack:self];
    
    _isConverAnimation = isConverAnimation;
    // 加载图文详情
    

    
    
    WS(b_self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [b_self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webViewURL]]];
    });
}


-(void)layout:(CGFloat)bottomHeight{

    
    self.bottomHeight = bottomHeight;
    
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT- bottomHeight);
    self.backgroundColor = [UIColor whiteColor];
    
    self.bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, (kSCREEN_HEIGHT-bottomHeight)*2)];
    self.bigView.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT- bottomHeight)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //webview设置
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT- bottomHeight , kSCREEN_WIDTH, kSCREEN_HEIGHT - bottomHeight)];
    
    self.webView.scrollView.contentSize = CGSizeMake(SC_WIDTH, SC_WIDTH * picNum + bottomHeight + 100);
    
    
    for (int i = 0; i < picNum; i++) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 + SC_WIDTH * i, SC_WIDTH, SC_WIDTH)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",picURLArr[i]]]];
        [self.webView.scrollView addSubview:imageView];
        
    }
    
    
    
//    UIImageView* imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, SC_WIDTH)];
//    UIImageView* imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SC_WIDTH + 10, SC_WIDTH, SC_WIDTH )];
//    UIImageView* imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SC_WIDTH * 2 + 20, SC_WIDTH, SC_WIDTH )];
//
//    [imageView1 sd_setImageWithURL:[NSURL URLWithString:imageUrl1]];
//    [imageView2 sd_setImageWithURL:[NSURL URLWithString:imageUrl2]];
//    [imageView3 sd_setImageWithURL:[NSURL URLWithString:imageUrl3]];
//
//    imageView1.backgroundColor = [UIColor redColor];
//    imageView2.backgroundColor = [UIColor redColor];
//    imageView3.backgroundColor = [UIColor redColor];
//
//    [self.webView.scrollView addSubview:imageView1];
//    [self.webView.scrollView addSubview:imageView2];
//    [self.webView.scrollView addSubview:imageView3];
    
    
//    [_webView addSubview:scrollView];
//
    
    _webView.backgroundColor = [UIColor clearColor];
    
    self.webView.scrollView.delegate = self;
    
    [self addSubview:_bigView];
    [_bigView addSubview:_tableView];
    [_bigView addSubview:_webView];

}


-(void)setMsgView:(NSArray *)UrlArr{
    
    //添加头部和尾部视图
    UIView*headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH)];
    headerView.backgroundColor = [UIColor blueColor];
    _tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH)];
    [headerView addSubview:_tempScrollView];
    TableHeaderView*tableHeaderView = [TableHeaderView tableHeaderViewWithUrlArr:UrlArr];
    tableHeaderView.frame = headerView.frame;
    [_tempScrollView addSubview:tableHeaderView];
    _tableView.tableHeaderView = headerView;
    OnPullMsgView*pullMsgView = [OnPullMsgView onPullMsgView];
    UIView*footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, KmsgVIewHeight)];
    pullMsgView.frame = footView.bounds;
    [footView addSubview:pullMsgView];
    _tableView.tableFooterView = footView;
    //设置下拉提示视图
    DownPullMsgView*downPullMsgView = [DownPullMsgView downPullMsgView];
    UIView* downMsgView = [[UIView alloc]initWithFrame:CGRectMake(0, -KmsgVIewHeight, kSCREEN_WIDTH, KmsgVIewHeight)];
    downPullMsgView.frame = downMsgView.bounds;
    [downMsgView addSubview:downPullMsgView];
    [_webView.scrollView addSubview:downMsgView];
}

#pragma mark -- UIScrollViewDelegate 用于控制头部视图滑动的视差效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isConverAnimation) {
        CGFloat offset = scrollView.contentOffset.y;
        if (scrollView == _tableView){
            //重新赋值，就不会有用力拖拽时的回弹
            _tempScrollView.contentOffset = CGPointMake(_tempScrollView.contentOffset.x, 0);
            if (offset >= 0 && offset <= kSCREEN_WIDTH) {
                //因为tempScrollView是放在tableView上的，tableView向上速度为1，实际上tempScrollView的速度也是1，此处往反方向走1/2的速度，相当于tableView还是正向在走1/2，这样就形成了视觉差！
                _tempScrollView.contentOffset = CGPointMake(_tempScrollView.contentOffset.x, - offset / 2.0f);
            }
        }
    }else{}
}

#pragma mark -- 监听滚动实现商品详情与图文详情界面的切换
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    WS(b_self);
    
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == _tableView) {
        if (offset > _tableView.contentSize.height - kSCREEN_HEIGHT + self.bottomHeight + KendDragHeight) {
            [UIView animateWithDuration:0.4 animations:^{
                b_self.bigView.transform = CGAffineTransformTranslate(b_self.bigView.transform, 0, -kSCREEN_HEIGHT +  self.bottomHeight + KnavHeight);
            } completion:^(BOOL finished) {
                if (b_self.scrollScreenBlock) {
                    b_self.scrollScreenBlock(NO);
                }
                
            }];
        }
    }
    if (scrollView == _webView.scrollView) {
        if (offset < - KendDragHeight) {
            [UIView animateWithDuration:0.4 animations:^{
                [UIView animateWithDuration:0.4 animations:^{
                    b_self.bigView.transform = CGAffineTransformIdentity;
                    
                }];
            } completion:^(BOOL finished) {
                if (b_self.scrollScreenBlock) {
                    b_self.scrollScreenBlock(YES);
                }
            }];
        }
    }
}



///*******************下面TableView的代理是需要自行实现*********************

#pragma mark -- 每组返回多少个 需要根据实际情况设置！！！

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7 ;
}

#pragma mark -- 每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    if (indexPath.row==0) {
        return 70;
    }
    else if (indexPath.row==1){
        return 40;
    }
    else
    {
        return 40;
    }
}
#pragma mark -- 每个cell显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellStr =[NSString stringWithFormat:@"cellID"];
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell = [[DetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        
    }
    //title
    if (indexPath.row==0) {
        cell.titleLable.font = [UIFont systemFontOfSize:20];
        cell.titleLable.numberOfLines = 2;
        cell.titleLable.frame = CGRectMake(20,10, SC_WIDTH - 40, 80);
        cell.titleLable.text = [NSString stringWithFormat:@"%@",dataArr[indexPath.row]];
    }
    //name
    else if(indexPath.row==1){
        cell.titleLable.font = [UIFont systemFontOfSize:25];
        cell.titleLable.text = [NSString stringWithFormat:@"%@",dataArr[indexPath.row]];
    }
    //材质
    else if (indexPath.row==2){
        cell.titleLable.font = [UIFont systemFontOfSize:15];
        cell.titleLable.textColor = [UIColor grayColor];
        cell.titleLable.text = [NSString stringWithFormat:@"面料材质：%@",dataArr[indexPath.row]];
    }
    //price
    else if (indexPath.row==3){
        cell.titleLable.font = [UIFont systemFontOfSize:25];
        cell.titleLable.textColor = ColorRGB(255, 71, 87);
        cell.titleLable.text = [NSString stringWithFormat:@"￥:%@",dataArr[indexPath.row]];
    }
    else if (indexPath.row==4){
        cell.titleLable.font = [UIFont systemFontOfSize:15];
        cell.titleLable.text = [NSString stringWithFormat:@"尺码:%@",dataArr[indexPath.row]];
    }
    else{
        cell.titleLable.font = [UIFont systemFontOfSize:15];
        if (indexPath.row==5) {
            cell.titleLable.text = [NSString stringWithFormat:@"库存:%@",dataArr[indexPath.row]];
        }
        else{
            cell.titleLable.text = [NSString stringWithFormat:@"款式:%@",dataArr[indexPath.row]];
        }
        
    }
    NSLog(@"row===%ld",indexPath.row);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


#pragma mark -- 每组头部视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}


#pragma mark -- 选择每个cell执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



@end
