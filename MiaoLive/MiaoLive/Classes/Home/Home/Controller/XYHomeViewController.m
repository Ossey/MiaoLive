//
//  XYHomeViewController.m
//  
//
//  Created by mofeini on 16/9/2.
//  Copyright © 2016年 sey. All rights reserved.
//

#import "XYHomeViewController.h"
#import "XYHotViewController.h"
#import "XYNewLiveController.h"
#import "XYOnlineFriendViewController.h"
#import "XYHomeTitleButton.h"
#import "XYWebViewController.h"
#import "XYOfficialViewController.h"
#import "XYOverseasViewController.h"
#import "XYSameCityViewController.h"
#import "XYSignViewController.h"
#import "XYNetRedViewController.h"
#import "XYNetworkRequest.h"


@interface XYHomeViewController () {
    UIViewController *_childViewController;
}

@property (nonatomic, strong) NSMutableArray *tabNames;
@property (nonatomic, strong) XYHomeTitleButton *titleBtn;
@property (nonatomic, strong) XYHomeTitleButton *titleBtn1;
@end

@implementation XYHomeViewController
- (XYHomeTitleButton *)titleBtn1 {
    if (_titleBtn1 == nil) {
        _titleBtn1 = [[XYHomeTitleButton alloc] init];
    }
    return _titleBtn1;
}
- (XYHomeTitleButton *)titleBtn {
    
    if (_titleBtn == nil) {
        self.titleBtn = [[XYHomeTitleButton alloc] init];
    }
    return _titleBtn;
}

- (NSArray *)titles { // 当plist没有加载到标题时，使用这个里面的
    return @[@"热门",@"签约",@"红人",@"关注",@"海外",@"最新",@"同城",@"官方"];
}
- (NSString *)tabListPath {
    return [xyDocumentPath stringByAppendingPathComponent:@"tabList.plist"];
}

- (NSMutableArray *)tabNames {
    if (_tabNames == nil) {
        _tabNames = [NSMutableArray array];
    }
    return _tabNames;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadData];
    [self setup];
    
    // 设置默认选中的控制器的索引
    self.selectedIndex = 2;
    
    [self addObserver];
}

- (void)loadData {
    NSString *urlString = [xyBaseURLStr stringByAppendingPathComponent:@"Room/GetHotTab"];
    NSDictionary *parameters = @{@"devicetype": @2, @"version": @"2.1.3"};
    
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypeGET url:urlString parameters:parameters progress:nil finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
       
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        [responseObject writeToFile:self.tabListPath atomically:YES];
//        NSLog(@"%@", responseObject);
    }];
    
}

- (void)setup {
    [self reloadPlist];
    [self setupNavigationBar];
    [self setupAllChildViewController];
}

- (void)reloadPlist {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:self.tabListPath];
    NSArray *dataArray = dict[@"data"][@"tabList"];
    if (!dataArray.count) {
        [self.tabNames addObjectsFromArray:self.titles];
        return;
    }
    for (id obj in dataArray) {
        [self.tabNames addObject:obj[@"tabName"]];
    }
}
- (void)setupNavigationBar {

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_15x14"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"head_crown_24x24"] style:UIBarButtonItemStyleDone target:self action:@selector(rankCrown)];
    // 当默认进入时设置titleView为文字
    [self.titleBtn1 setTitle:@"广场" forState:UIControlStateNormal];
    self.navigationItem.titleView = self.titleBtn1;
    
    
}

- (void)addObserver {

    // 监听子控制器的view即将显示显示在屏幕上的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subViewWillAppear:) name:XYHomeSubViewsWillShowNotification object:nil];
}

#pragma mark - Event
- (void)rankCrown {
    
    XYWebViewController *webViewController = [[XYWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://live.9158.com/Rank/WeekRank?Random=10"]];
    webViewController.title = @"每周排行";
    [self.navigationController pushViewController:webViewController animated:YES];
}

// 更改显示的模式: 有两种模式(大图模式和小图模式)
- (void)changeShowType:(UIButton *)btn {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XYChangeShowLiveTypeNotification object:btn];
}

#pragma mark - 添加所有的子控制器
- (void)setupAllChildViewController {
    
    for (NSInteger i = 0; i < self.tabNames.count; ++i) {
        NSString *title = self.tabNames[i];
        switch (i) {
            case 0: /** 最热主播 */
                if ([title isEqualToString:@"热门"]) {
                    _childViewController = [XYHotViewController new];
                    ((XYHotViewController *)_childViewController).titleView = self.titleScrollView;
                }
                break;
            case 1: /** 签约 */
                if ([title isEqualToString:@"签约"]) {
                   _childViewController = [XYSignViewController new];
                    ((XYSignViewController *)_childViewController).titleView = self.titleScrollView;
                }
                break;
            case 2: /** 红人 */
                if ([title isEqualToString:@"红人"]) {
                    _childViewController = [XYNetRedViewController new];
                    ((XYNetRedViewController *)_childViewController).titleView = self.titleScrollView;
                }
                break;
            case 3: /** 关注主播 */
                if ([title isEqualToString:@"关注"]) {
                    _childViewController = [XYOnlineFriendViewController new];
                }
                break;
            case 4: /** 海外 */
                if ([title isEqualToString:@"海外"]) {
                    _childViewController = [XYOverseasViewController new];
                    ((XYOverseasViewController *)_childViewController).titleView = self.titleScrollView;
                }
                break;
            case 5: /** 最新主播 */
                if ([title isEqualToString:@"最新"]) {
                    _childViewController = [XYNewLiveController new];
                }
                break;
            
            case 6: /** 同城 */
                if ([title isEqualToString:@"同城"]) {
                    _childViewController = [XYSameCityViewController new];
                    ((XYSameCityViewController *)_childViewController).titleView = self.titleScrollView;
                }
                break;

            case 7: /** 官方 */
                if ([title isEqualToString:@"官方"]) {
                    _childViewController = [XYOfficialViewController new];
                    ((XYOfficialViewController *)_childViewController).titleView = self.titleScrollView;
                }
            default:
                break;
        }
        _childViewController.title = title;
        [self addChildViewController:_childViewController];
    }
    
}



// 当子控制的view显示在屏幕上时的通知回调
- (void)subViewWillAppear:(NSNotification *)note {
    
    // 动态改变导航条titleView
    if ([note.object isKindOfClass:[XYNewLiveController class]] || [note.object isKindOfClass:[XYOnlineFriendViewController class]]) {
        
        [self.titleBtn1 setTitle:@"广场" forState:UIControlStateNormal];
        self.navigationItem.titleView = self.titleBtn1;
    } else {
        [self.titleBtn setTitle:@"广场" forState:UIControlStateNormal];
        [self.titleBtn setImage:[UIImage imageNamed:@"title"] forState:UIControlStateNormal];
        [self.titleBtn setImage:[UIImage imageNamed:@"title"] forState:UIControlStateSelected];
        self.navigationItem.titleView = self.titleBtn;
        [self.titleBtn addTarget:self action:@selector(changeShowType:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


@end
