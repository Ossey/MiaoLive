//
//  XYHomeLiveController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/27.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYHomeLiveController.h"
#import "XYHotLiveCell.h"
#import "XYRefreshGifHeader.h"
#import "XYNetworkTool.h"
#import "XYLiveItem.h"
#import "UIViewController+XYExtension.h"
#import "XYTopADItem.h"
#import "XYHotADCell.h"
#import "XYWebViewController.h"
#import "XYRoomLiveController.h"
#import "XYProfileNavigationController.h"
#import "XYHomeLiveFlowLayout.h"
#import "XYMenuView.h"

/**
 根据青花瓷抓取第一次进入此页面的GET请求:@"http://live.9158.com/Fans/GetHotLive?page=1
 下拉刷新时: page 会 加 1
 */
static NSString *const cellReusableIdentifier = @"XYHotViewController";
static NSString *const adCellReusableIdentifier = @"XYHotADCell";

@interface XYHomeLiveController () 
/** 当前页 */
@property (nonatomic, assign) NSInteger currentPage;
/** 最热直播数据模型数组 */
@property (nonatomic, strong) NSMutableArray *lives;
/** 广告数据模型数组 */
@property (nonatomic, strong) NSMutableArray *topADS;
/** 请求直播数据的urlStr */
@property (nonatomic, strong) NSString *loadLiveURLStr; // 请求
/** 请求直播数据的字段 */
@property (nonatomic, strong) NSMutableDictionary *loadLiveParameters; // 请求
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) XYHomeLiveFlowLayout *flowLayout;
//@property (nonatomic, weak) UIView *showStyleView;
@end

@implementation XYHomeLiveController
#pragma mark - Lazy loading

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        XYHomeLiveFlowLayout *flowLayout = [[XYHomeLiveFlowLayout alloc] init];
        _flowLayout = flowLayout;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
        
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
        
    }
    return _collectionView;
}

- (NSString *)loadLiveURLStr {
    NSString *urlStr;
    // 拼接网络请求的url字符串
    if (self.liveType == XYHomeLiveTypeOnlineFriends) {
        urlStr = [xyBaseURLStr stringByAppendingPathComponent:@"Fans/GetMyOnlineFriendsList"];
    } else if(self.liveType == XYHomeLiveTypeSameCity) {
        urlStr = [xyBaseURLStr stringByAppendingPathComponent:@"Room/GetSameCity"];
    } else {
        urlStr = [xyBaseURLStr stringByAppendingPathComponent:@"Room/GetHotLive_v2"];
    }
    return urlStr;
}

- (NSMutableDictionary *)loadLiveParameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"page"] = @(self.currentPage);
    parameters[@"useridx"] = @65952190;
    parameters[@"type"] = @(self.liveType);
    parameters[@"province"] = @"%E6%B5%99%E6%B1%9F%E7%9C%81"; // 此字段为省份
    parameters[@"lon"] = @119.95734222242542; // 此字段为经度
    parameters[@"lat"] = @30.26647308164829; // 此字段为纬度
    parameters[@"cache"] = @1;
    return parameters;
}
- (XYHomeLiveType)liveType {
    return 0;
}


- (NSMutableArray *)topADS {
    
    if (_topADS == nil) {
        _topADS = [NSMutableArray array];
    }
    return _topADS;
}
- (NSMutableArray *)lives {
    if (_lives == nil) {
        _lives =[NSMutableArray array];
    }
    return _lives;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self addobserver];
}


- (void)setup {
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor]; 
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XYHotLiveCell" bundle:nil] forCellWithReuseIdentifier:cellReusableIdentifier];
    
    // 添加collectionView的头部视图
    [self.collectionView registerClass:[XYHotADCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:adCellReusableIdentifier];
    
    self.collectionView.mj_header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.currentPage = 1;
        // 请求最热直播数据
        [self getHotLiveList];
        // 请求顶部广告数据
        [self getTopAD];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getHotLiveList];
    }];
    
    [self.collectionView.mj_header beginRefreshing];

    
}

- (void)addobserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLiveStyle) name:XYChangeShowLiveTypeNotification object:nil];
}

- (void)showLiveStyle {

    XYMenuView *menuView = [XYMenuView menuViewToSuperView:self.view scrollViewHeight:40 animationOrientation:1 menViewStyle:1];

    menuView.maskAlpha = 0.3;
    
    [menuView showMenuView];
    
    [menuView setMenuViewClickBlock:^(XYMenuViewBtnType type) {
        
        if (type == 0) {
            self.flowLayout.columnNumber = 1;
        } else if (type == 1) {
            self.flowLayout.columnNumber = 2;

        }
    }];
    
}

#pragma mark - 数据请求
// 请求顶部banner数据
- (void)getTopAD {
    
    // 10秒后再加载请求banner数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *urlStr = [xyBaseURLStr stringByAppendingPathComponent:@"Living/GetAD"];
        NSDictionary *parameters = @{@"tabid": @1};
        [[XYNetworkTool shareNetWork] GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *result = responseObject[@"data"];
            if (![self isEmptyArray:result]) {
                [self.topADS removeAllObjects]; // 防止重复添加AD
                for (NSDictionary *dict in result) {
                    XYTopADItem *item = [XYTopADItem adItemWithDict:dict];
                    [self.topADS addObject:item];
                    [self.collectionView reloadData];
                }
            } else {
                [self showInfo:@"网络异常"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
            [self showInfo:@"网络异常,请重新加载"];
        }];
        
    });
    
}

// 请求最热主播数据
- (void)getHotLiveList {
  
    [[XYNetworkTool shareNetWork] GET:self.loadLiveURLStr parameters:self.loadLiveParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *_Nullable responseObject) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        // 转换模型
        NSMutableArray *resultArray = [NSMutableArray array];
        
        // 注意:在获取服务器返回字段list对应数据时， 需要先判断服务器返回的msg字段的值为success才解析，因为success时data字段才有值，不然为空字符串，转模型会奔溃
        if ([responseObject[@"msg"] isEqualToString:@"success"]) {

            for (id obj in responseObject[@"data"][@"list"]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    XYLiveItem *item = [XYLiveItem LiveItemWithDict:obj];
                    [resultArray addObject:item];
                }
            }
 
        }
        
        if (![self isEmptyArray:resultArray]) {
            [self.lives addObjectsFromArray:resultArray];
            [self.collectionView reloadData];
        } else {
            [self xy_showMessage:@"暂时没有更多最新数据"];
            // 恢复当前页
            self.currentPage--;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.currentPage--;
        [self showInfo:@"网络异常, 请尝试刷新"];
    }];
}



#pragma mark - collectionView view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 加1是因为第一行设置为banner了
//    return self.topADS.count ? self.lives.count + 1 : self.lives.count;
    return self.lives.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    
    XYHotLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReusableIdentifier forIndexPath:indexPath];
    if (self.lives.count) {

        cell.liveItem = self.lives[indexPath.row];
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger currentIndex = indexPath.row;
    XYRoomLiveController *liveVc = [[XYRoomLiveController alloc] initWithLives:self.lives currentIndex:currentIndex];
    // 包装为导航控制器的原因是让modal的控制器可以push新的控制器
    XYProfileNavigationController *nav = [[XYProfileNavigationController alloc] initWithRootViewController:liveVc];
    [self presentViewController:nav animated:YES completion:nil];
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        XYHotADCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:adCellReusableIdentifier forIndexPath:indexPath];
    
        header.adItems = self.topADS;
        return header;
    }
    //如果底部视图
    //    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
    //
    //    }
    return nil;
}






#pragma mark - ScrollView Delegate
// 滚动scrollView时，控制器导航条和tabBar隐藏和显示
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    if (velocity <- 5) {
        //向上拖动，隐藏导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.titleView.xy_y = -44;
        [self tabBarHidden];
        
    }else if (velocity > 5) {
        //向下拖动，显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.titleView.xy_y = 0;
        [self tabBarShow];
    }else if(velocity == 0){
        //停止拖拽
    }
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//
//    if (velocity.y > 0.0) {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        [self.mainTabBarController tabBarHidden];
//    } else if (velocity.y < 0.0){
//
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        [self.mainTabBarController tabBarShow];
//    }
//}


@end
