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

/**
 根据青花瓷抓取第一次进入此页面的GET请求:@"http://live.9158.com/Fans/GetHotLive?page=1
 下拉刷新时: page 会 加 1
 */

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
@end

@implementation XYHomeLiveController
#pragma mark - Lazy loading
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

static NSString *const cellReusableIdentifier = @"XYHotViewController";
static NSString *const adCellReusableIdentifier = @"XYHotADCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYHotLiveCell class]) bundle:nil] forCellReuseIdentifier:cellReusableIdentifier];
    [self.tableView registerClass:[XYHotADCell class] forCellReuseIdentifier:adCellReusableIdentifier];
    self.tableView.mj_header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.currentPage = 1;
        // 请求最热直播数据
        [self getHotLiveList];
        // 请求顶部广告数据
        [self getTopAD];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getHotLiveList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark - 数据请求
// 请求顶部banner数据
- (void)getTopAD {
    
    // 10秒后再加载请求banner数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *urlStr = [xyBaseURLStr stringByAppendingPathComponent:@"Living/GetAD"];
        NSDictionary *parameters = @{@"tabid": @1};
        [[XYNetworkTool shareNetWork] GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *result = responseObject[@"data"];
            if (![self isEmptyArray:result]) {
                [self.topADS removeAllObjects]; // 防止重复添加AD
                for (NSDictionary *dict in result) {
                    XYTopADItem *item = [XYTopADItem adItemWithDict:dict];
                    [self.topADS addObject:item];
                    [self.tableView reloadData];
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
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
            [self.tableView reloadData];
        } else {
            [self xy_showMessage:@"暂时没有更多最新数据"];
            // 恢复当前页
            self.currentPage--;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.currentPage--;
        [self showInfo:@"网络异常, 请尝试刷新"];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 加1是因为第一行设置为banner了
    return self.topADS.count ? self.lives.count + 1 : self.lives.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 第0行展示banner
    if (self.topADS.count && indexPath.row == 0) {
        XYHotADCell *cell = [tableView dequeueReusableCellWithIdentifier:adCellReusableIdentifier forIndexPath:indexPath];
        cell.adItems = self.topADS;
        if (cell.adItems.count) { // 容错处理，防止加载ad失败时，点击崩溃
            [cell setImageClickBlock:^(XYTopADItem *adItem) {
                if (adItem.link.length) {
                    XYWebViewController *webVc = [[XYWebViewController alloc] initWithURL:[NSURL URLWithString:adItem.link]];
                    webVc.title = adItem.title;
                    [self.navigationController pushViewController:webVc animated:YES];
                }
            }];
            
        }
        return cell;
    }
    
    XYHotLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusableIdentifier forIndexPath:indexPath];
    if (self.lives.count) {
        NSInteger row = self.topADS.count ? indexPath.row - 1 : indexPath.row;
        cell.liveItem = self.lives[row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.topADS.count) {
        return indexPath.row == 0 ? 100 : 465;
    } else {
        return 465;
    }
    
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger currentIndex = self.topADS.count ? indexPath.row - 1 : indexPath.row;
    XYRoomLiveController *liveVc = [[XYRoomLiveController alloc] initWithLives:self.lives currentIndex:currentIndex];
    // 包装为导航控制器的原因是让modal的控制器可以push新的控制器
    XYProfileNavigationController *nav = [[XYProfileNavigationController alloc] initWithRootViewController:liveVc];
    [self presentViewController:nav animated:YES completion:nil];
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
