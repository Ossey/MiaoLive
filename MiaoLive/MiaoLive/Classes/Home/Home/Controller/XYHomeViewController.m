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
#import "XYHomeTitleView.h"
#import "XYWebViewController.h"
#import "XYOfficialViewController.h"
#import "XYOverseasViewController.h"
#import "XYSameCityViewController.h"
#import "XYSignViewController.h"
#import "XYNetRedViewController.h"
#import "XYNetworkTool.h"

@interface XYHomeViewController () {
    UIViewController *_childViewController;
}

@property (nonatomic, strong) NSMutableArray *tabNames;

@end

@implementation XYHomeViewController
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
    self.selectedIndex = 4;
    
}

- (void)loadData {
    NSString *urlString = [xyBaseURLStr stringByAppendingPathComponent:@"Room/GetHotTab"];
    NSDictionary *parameters = @{@"devicetype": @2, @"version": @"2.1.3"};
    
    [[XYNetworkTool shareNetWork] GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        [responseObject writeToFile:self.tabListPath atomically:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
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
    UIButton *titleView = [[UIButton alloc] init];
    [titleView setTitle:@"广场" forState:UIControlStateNormal];
    [titleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.titleView = titleView;
}

#pragma mark - Event
- (void)rankCrown {
    
    XYWebViewController *webViewController = [[XYWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://live.9158.com/Rank/WeekRank?Random=10"]];
    webViewController.title = @"排行";
    [self.navigationController pushViewController:webViewController animated:YES];
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


@end
