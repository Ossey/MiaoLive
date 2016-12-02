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
#import "XYLiveItem.h"
#import "UIViewController+XYExtension.h"
#import "XYTopADItem.h"
#import "XYHotADCell.h"
#import "XYWebViewController.h"
#import "XYRoomLiveController.h"
#import "XYProfileNavigationController.h"
#import "XYHomeLiveFlowLayout.h"
#import "XYHomeMenuView.h"
#import "XYHotLivelViewSmalCell.h"
#import "XYDBManager.h"
#import "XYNetworkRequest.h"

/**
 根据青花瓷抓取第一次进入此页面的GET请求:@"http://live.9158.com/Fans/GetHotLive?page=1
 下拉刷新时: page 会 加 1
 */
static NSString *const cellReusableIdentifier = @"XYHotViewController";
static NSString *const adCellReusableIdentifier = @"XYHotADCell";
static NSString *const smallCellReusableIdentifier = @"XYHotLivelViewSmalCell";

@interface XYHomeLiveController () {
    UIButton *_navigationTitleBtn;
}
/** 当前页 */
@property (nonatomic, assign) NSInteger currentPage;
/** 最热直播数据模型数组 */
@property (nonatomic, strong) NSMutableArray<XYLiveItem *> *lives;
/** 广告数据模型数组 */
@property (nonatomic, strong) NSMutableArray<XYTopADItem *> *topADS;
/** 请求直播数据的urlStr */
@property (nonatomic, strong) NSString *loadLiveURLStr;
/** 请求直播数据的字段 */
@property (nonatomic, strong) NSMutableDictionary *loadLiveParameters;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) XYHomeLiveFlowLayout *flowLayout;
@property (nonatomic, strong) XYHomeMenuView *menuView;
@end

@implementation XYHomeLiveController
#pragma mark - Lazy loading
- (XYHomeMenuView *)menuView {
    if (_menuView == nil) {
        _menuView = [XYHomeMenuView menuViewToSuperView:self.view];
    }
    return _menuView;
}

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

- (NSMutableDictionary *)loadLiveParametersWithPage:(NSInteger)page {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"page"] = @(page);
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)setup {
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor]; 
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XYHotLiveCell" bundle:nil] forCellWithReuseIdentifier:cellReusableIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XYHotLivelViewSmalCell" bundle:nil] forCellWithReuseIdentifier:smallCellReusableIdentifier];
    
    // 添加collectionView的头部视图
    [self.collectionView registerClass:[XYHotADCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:adCellReusableIdentifier];
    
    self.collectionView.mj_header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    // 没有缓存过上次刷新数据的时间，说明是第一次启用app，也就没有加载过数据就直接刷新
    [self.collectionView.mj_header beginRefreshing];
    
    

}

- (void)addobserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLiveStyle:) name:XYChangeShowLiveTypeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickTitleButtonNote:) name:XYHomeSubViewsWillShowNotification object:nil];
}

- (void)clickTitleButtonNote:(NSNotification *)note {
    
    // 当点击了别的标题按钮时，让menuVew 隐藏
    [self.menuView dismissMenuView];
}

- (void)showLiveStyle:(NSNotification *)note {

    // 获取导航titleView的按钮
    UIButton *btn = note.object;
    _navigationTitleBtn = btn;
    
    btn.isSelected ? [self.menuView dismissMenuView] : [self.menuView showMenuView];;
    
    // 这样写回调的比直接在show或dismiss后面回调的好处是，不管你处理了多少个show或dismiss都会在这个block中统一执行回调，而不需要你写一下show就回调执行一次你要做的代码
    // show回调
    [self.menuView setShowCompletionBlock:^{
        btn.selected = YES;
    }];
    // dissmiss回调
    [self.menuView setDismissCompletionBlock:^{
        btn.selected = NO;
    }];
    
    
    __weak typeof(self) weakSelf = self;
    [self.menuView setMenuViewClickBlock:^(XYHomeMenuViewBtnType type) {
        
        if (type == 0) {
            weakSelf.flowLayout.columnNumber = 1;
        } else if (type == 1) {
            weakSelf.flowLayout.columnNumber = 2;

        }
    }];
    
 btn.selected = !btn.isSelected;
    
}

#pragma mark GetDataSoure



- (void)loadNewData {

    /**
     取出lives数组中的模型，判断下当前数组中最后20个模型对应的pos对应的useridx与新请求的数据(每次请求都是20个)是否发生改变，如果发送改变就将新的20个数据添加到数据的后面
     */
    
    NSLog(@"下拉刷新");

    // 请求顶部广告数据
    [self getTopAD];
    self.currentPage = 1;
    [self getDataWithPage:self.currentPage];
}

- (void)loadMoreData {
    NSLog(@"上拉加载");
    self.currentPage++;
//    NSLog(@"currentPage==%ld", self.currentPage);
    NSRange range = NSMakeRange(self.currentPage * 10, 10);
    [[XYDBManager shareManager] queryDatabaseWithRange:range completion:^(NSArray *resultArray) {
        if (![self isEmptyArray:resultArray]) {
            [self.lives addObjectsFromArray:resultArray];
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];
             NSLog(@"数据库加载%lu条更多数据", resultArray.count);
        } else {
            // 数据库没有更多数据时，从网络请求
            [self getDataWithPage:self.currentPage];
        }
    }];
    
}


#pragma mark - 数据请求
// 请求顶部banner数据
- (void)getTopAD {
    
    // 10秒后再加载请求banner数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *urlStr = [xyBaseURLStr stringByAppendingPathComponent:@"Living/GetAD"];
        NSDictionary *parameters = @{@"tabid": @1};
        [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypeGET url:urlStr parameters:parameters progress:nil finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
            if (error) {
                [self xy_showMessage:@"网络异常, 请尝试刷新"];
                return;
            }
            
            NSArray *result = responseObject[@"data"];
            if (![self isEmptyArray:result]) {
                [self.topADS removeAllObjects]; // 防止重复添加AD
                for (NSDictionary *dict in result) {
                    XYTopADItem *item = [XYTopADItem adItemWithDict:dict];
                    [self.topADS addObject:item];
                    [self.collectionView reloadData];
                }
            } else {
                
                [self xy_showMessage:@"网络异常, 请尝试刷新"];
            }

        }];
    });
    
}
- (void)getDataWithPage:(NSInteger)page {
    NSLog(@"发送网络请求！");
    NSMutableDictionary *parameters = [self loadLiveParametersWithPage:page];
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypeGET url:self.loadLiveURLStr parameters:parameters progress:nil finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) { // 网络请求失败
            self.currentPage--;
            NSLog(@"%@", error.localizedDescription);
            [self xy_showMessage:@"网络异常, 请尝试刷新"];
            if (!self.lives.count) {
                // 网络错误且lives模型数组中没有数据时再去读取本地数据
                NSRange range = NSMakeRange(_currentPage * 10, 10);
                [[XYDBManager shareManager] queryDatabaseWithRange:range completion:^(NSArray *resultArray) {
                    [self.lives addObjectsFromArray:resultArray];

                }];
            }
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            return;
        }
        
        // 应该先获取当前登录用户ID，如当前无用户ID，则用户未登陆，就不需要加载数据，但是我未做登录，暂时跳过
        // 从后台请求数据
        [self loadLivesFromNetwork:responseObject];
    }];
}



// 从服务器请求数据
- (void)loadLivesFromNetwork:(NSDictionary *)responseObject {
    
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
        if (self.currentPage == 1) {
            // 当currentPage为1时是下拉刷新，由于服务器字段不全,此时会导致重复请求新数据，所以每次下拉刷新时移除以前的数据
            [self.lives removeAllObjects];
        }
        /**
         * 刷新数据思路:网络上获取到数据之后存入缓存和数据库，网络正常时若缓存中有直接从缓存中读取，缓存中没有从数据库中加载，网络失败时，从数据库中加载数据
         */
        for (XYLiveItem *item in resultArray) {

            // 将每一个模型的数据缓存到本地
            [[XYDBManager shareManager] insertDatabaseWithModel:item ID:[NSString stringWithFormat:@"%ld", (long)item.pos]];
        }
        [self.lives addObjectsFromArray:resultArray];
        [self.collectionView reloadData];
        
    } else {
        [self xy_showMessage:@"暂时没有更多最新数据"];
        // 恢复当前页
        self.currentPage--;
    }
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
}

// 根据缓存的条数，判断下一页到底是加载数据库里面的数据，还是重新从网络上请求最新的数据，这里有一点瑕疵，就是当缓存的数目不为10的倍数的时候，比如说是12条数据，那么它只会加载缓存中的前10条数据，当要加载下一页的数据时，只能从网络上获取下一页的数据
//- (void)footerRereshing
//{
//    _page++;
//    NSInteger count = [[XYDBManager shareManager] databaseCount];
//    if(count/10 >= _page)
//    {
//        // 从数据库中的读取数据
////        [[XYDBManager shareManager] checkDatabaseFromPage:_page];
////        [[XYDBManager shareManager]
//    } else
//    {
//        // 从网络加载数据
//        [self getHotLiveList];
//    }
//}


#pragma mark - collectionView view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.lives.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // 根据banner的模型数组，动态修改collectionView头部视图的高度
    if (self.topADS.count > 0) {
        self.flowLayout.headerReferenceSize = CGSizeMake(xyScreenW, 100);
        
    } else {
        self.flowLayout.headerReferenceSize = CGSizeZero;
    }
    
    
    // 根据flowLayout.columnNumber属性，决定显示哪种类型的cell
    if (self.flowLayout.columnNumber == 1) {
        XYHotLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReusableIdentifier forIndexPath:indexPath];
        
        if (self.lives.count) {
            
            cell.liveItem = self.lives[indexPath.row];
        }
        return cell;
        
    } else if (self.flowLayout.columnNumber == 2) {
        XYHotLivelViewSmalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:smallCellReusableIdentifier forIndexPath:indexPath];
        
        if (self.lives.count) {
            
            cell.liveItem = self.lives[indexPath.row];
        }
        return cell;

    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger currentIndex = indexPath.row;
    XYRoomLiveController *liveVc = [[XYRoomLiveController alloc] initWithLives:self.lives currentIndex:currentIndex];
    // 包装为导航控制器的原因是让modal的控制器可以push新的控制器
    XYProfileNavigationController *nav = [[XYProfileNavigationController alloc] initWithRootViewController:liveVc];
    [self presentViewController:nav animated:YES completion:nil];
}

//  返回collectionView头部视图: 需要注意的是当flowLayout.headerReferenceSize的值为CGSizeZero时，不会调用此方法创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
       //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        XYHotADCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:adCellReusableIdentifier forIndexPath:indexPath];
        [header setImageClickBlock:^(XYTopADItem *topAD) {
            if (topAD.link.length) {
                XYWebViewController *web = [[XYWebViewController alloc] initWithURL:[NSURL URLWithString:topAD.link]];
                web.navigationItem.title = topAD.title;
                [self.navigationController pushViewController:web animated:YES];
            }
            }];

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
