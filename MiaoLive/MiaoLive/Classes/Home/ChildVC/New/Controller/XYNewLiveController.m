//
//  XYNewLiveController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/18.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  最新界面

/**
 服务器http://live.9158.com/Room/GetNewRoomOnline?page=1，下拉刷新时page自增
 每次启动程序时都会加载此界面的数据
 */

#import "XYNewLiveController.h"
#import "XYNewLiveCell.h"
#import "XYRefreshGifHeader.h"
#import "XYLiveUserItem.h"
#import "XYNewLiveFlowLayout.h"
#import "XYRoomLiveController.h"
#import "XYLiveItem.h"
#import "XYProfileNavigationController.h"
#import "XYNetworkRequest.h"

@interface XYNewLiveController () {
    NSTimer *_timer;
    
}

@property (nonatomic, strong) XYNewLiveFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *newlives;
/** 存放已显示的cell的indexPath的数组 */
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *showedIndexPaths;
@end

@implementation XYNewLiveController
- (NSMutableArray *)showedIndexPaths {
    if (_showedIndexPaths == nil) {
        _showedIndexPaths = [NSMutableArray array];
    }
    return _showedIndexPaths;
}
- (NSMutableArray *)newlives {
    if (_newlives == nil) {
        _newlives = [NSMutableArray array];
    }
    return _newlives;
}

- (XYNewLiveFlowLayout *)flowLayout {

    if (_flowLayout == nil) {
        XYNewLiveFlowLayout *flowLayout = [XYNewLiveFlowLayout new];
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}

- (instancetype)init
{
    if (self = [super initWithCollectionViewLayout:self.flowLayout]) {
        
    }
    return self;
}
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register cell classes
    [self.collectionView registerClass:[XYNewLiveCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startTimer];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 销毁定时器
    [self stopTimer];
}

- (void)setup {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.mj_header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        // 请求最新直播数据
        [self getNewLiveList];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getNewLiveList];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)getNewLiveList {
    // http://live.9158.com/Room/GetNewRoomOnline?page=1
    NSString *urlStr = [xyBaseURLStr stringByAppendingPathComponent:@"Room/GetNewRoomOnline"];
    NSDictionary *parameters = @{@"page": @(self.currentPage)};
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypeGET url:urlStr parameters:parameters progress:nil finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            self.currentPage--;
            [self xy_showMessage:@"网络异常"];
            return;
        }
        // 停止刷新
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        // 当msg字段为success时，说明获取的数据中data有list字段(list字段就是需要的数据)，如data没有list字段，转模型时会崩溃,另外方法就是通过code字段判断，code为100时返回的有list数据，为106时，没有数据
        NSString *msg = responseObject[@"msg"];
        if ([msg isEqualToString:@"fail"]) {
            // 数据加载完毕没有更多数据了
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            [self xy_showMessage:@"暂时没有更多数据"];
            // 恢复当前页码
            self.currentPage--;
        }
        
        if ([msg isEqualToString:@"success"]) {
            // 数组转模型
            NSArray *listArr = responseObject[@"data"][@"list"];
            for (id obj in listArr) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    XYLiveUserItem *userItem = [XYLiveUserItem LiveUserItemWithDict:obj];
                    [self.newlives addObject:userItem];
                }
            }
            if (self.newlives) {
                [self.collectionView reloadData];
            }
        }
        
    }];
    
    
}

#pragma mark - 定时器
- (void)startTimer {
    if (_timer == nil) {
        // 开启定时器，每一分钟刷新一次数据
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 * 60 target:self selector:@selector(getNewData) userInfo:nil repeats:YES];
        
    }
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)getNewData {
    [self.collectionView.mj_header beginRefreshing];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.newlives.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYNewLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.userItem = self.newlives[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
// Cell即将显示的时候调用
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // 将所有已经显示过的cell放在showedIndexPaths数组中，只有第一次显示的时候才需要做动画
    if ([self.showedIndexPaths containsObject:indexPath]) {
        return;
    } else {
        [self.showedIndexPaths addObject:indexPath];
        // 给cell做缩放动画
        [self cellAnimateScale:cell];
    }
}

// 缩放动画
- (void)cellAnimateScale:(UICollectionViewCell *)cell {
    CGFloat duration = 0.5;
    cell.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

// 移动动画-- 暂时不用-- 备用
- (void)cellAnimateMove:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",NSStringFromCGRect(cell.frame));
    
    CGRect toFrame = cell.frame;
    // Y ScrollView滑动到底部的时的Y
    cell.frame = CGRectMake(cell.frame.origin.x, self.collectionView.contentSize.height + self.collectionView.contentOffset.y + self.collectionView.contentInset.top, cell.bounds.size.width, cell.bounds.size.height);
    cell.layer.cornerRadius = cell.bounds.size.width * 0.5;
    
    CGFloat duration = (indexPath.item) * 0.2 + 0.2;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        cell.frame = toFrame;
        
    } completion:^(BOOL finished) {
        
    }];
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 对模型数组进行处理: 因为XYRoomLiveController需要的传递的是XYLiveItem模型，而当前数据源为XYLiveUserItem模型
    NSMutableArray *arrayM = [NSMutableArray array];
    for (XYLiveUserItem *userItem in self.newlives) {
        XYLiveItem *liveItem = [[XYLiveItem alloc] init];
        liveItem.myname = userItem.nickname;
        liveItem.gps = userItem.position;
        liveItem.starlevel = userItem.starlevel;
        liveItem.flv = userItem.flv;
        liveItem.bigpic = userItem.photo;
        liveItem.useridx = userItem.useridx;
        liveItem.allnum = userItem.allnum; // 当前XYLiveUserItem模型中,此字段为0
        [arrayM addObject:liveItem];
    }
    XYRoomLiveController *roomLive = [[XYRoomLiveController alloc] initWithLives:arrayM currentIndex:indexPath.item];
    XYProfileNavigationController *nav = [[XYProfileNavigationController alloc] initWithRootViewController:roomLive];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
