//
//  XYRoomLiveController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/22.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYRoomLiveController.h"
#import "XYRefreshGifHeader.h"
#import "XYLiveViewCell.h"
#import "XYLiveFlowLayout.h"
#import "XYContributionListController.h"

@interface XYRoomLiveController ()

@property (nonatomic, strong) XYLiveFlowLayout *flowLayout;
@end

@implementation XYRoomLiveController
- (XYLiveFlowLayout *)flowLayout {

    if (_flowLayout == nil) {
        _flowLayout = [[XYLiveFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (instancetype)initWithLives:(NSArray *)liveItems currentIndex:(NSInteger)currentIndex {

    if (self = [self init]) {
        _liveItems = liveItems;
        _currentIndex = currentIndex;
    }
    return self;
}

- (instancetype)init {
    if (self = [super initWithCollectionViewLayout:self.flowLayout]) {
    }
    return self;
}

static NSString * const reuseIdentifier = @"XYLiveViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.collectionView.backgroundColor = xyColorWithRGB(255, 255, 255);
    // Register cell classes
    [self.collectionView registerClass:[XYLiveViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    XYRefreshGifHeader *header = [XYRefreshGifHeader headerWithRefreshingBlock:^{
        [self.collectionView.mj_header endRefreshing];
        _currentIndex++;
        if (self->_currentIndex == self->_liveItems.count) {
            self->_currentIndex = 0;
        }
        [self.collectionView reloadData];
        
    }];
    header.stateLabel.hidden = NO;
    [header setTitle:@"下拉切换另一位主播" forState:MJRefreshStatePulling];
    [header setTitle:@"下拉切换另一位主播" forState:MJRefreshStateIdle];
    self.collectionView.mj_header = header;
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickContributionList) name:XYLiveClickContributionListNotification object:nil];
}

#pragma mark - Event
- (void)clickContributionList {
    XYContributionListController *vc = [XYContributionListController new];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XYLiveViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.parentVc = self;
    cell.liveItem = _liveItems[_currentIndex];
    // 取出相关联主播的索引
    NSInteger relateIdex = _currentIndex;
    if (relateIdex + 1 == _liveItems.count) {
        // 当是最后一个的时，让关联主播为第一个
        relateIdex = 0;
    } else {
        _currentIndex += 1;
    }
    
    // 关联主播的模型
    cell.relateLiveItem = _liveItems[relateIdex];
    [cell setClickRelateLiveBlock:^{
        // 点击关联主播时，让主播索引+1
        _currentIndex += 1;
        [self.collectionView reloadData];
    }];
    
    return cell;
}


@end
