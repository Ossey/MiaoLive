//
//  XYProfileViewController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/16.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYProfileViewController.h"
#import "XYProfileHeaderView.h"
#import "XYEditProfileController.h"
#import "XYSettingViewController.h"

@interface XYProfileViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) XYProfileHeaderView *headerView;
@property (nonatomic, weak) NSLayoutConstraint *headerViewHConst;
/** 手指开始触发pan手势的原始的位置Y */
@property (nonatomic, assign) CGFloat originalLocationY;
/** 手势发生中手指的位置Y */
@property (nonatomic, assign) CGFloat fingerLocationY;
@property (nonatomic, assign) CGFloat originalOffsetY;

@end

@implementation XYProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
static NSString *const cellReuseIdentifier = @"XYProfileViewControllerCell";
- (void)setup {

    self.topBackgroundView.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 添加tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [self.view sendSubviewToBack:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];

    XYProfileHeaderView *headerView = [XYProfileHeaderView xy_viewFromXib];
    [self.view addSubview:headerView];
    self.headerView = headerView;
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 使用contentInset的目的: 当tableView滚动后，还会弹出来
    // 当调用contentInset会自动调用scrollViewDidScroll
    tableView.contentInset = UIEdgeInsetsMake(260, 0, 49, 0);

    // 添加约束
    [self addConstraint];
    
    /**
     问题: 滑动headerView时，tableView并不会跟随滚动，这是因为headerView把事件接收了
     分析: 如果将headerView的userInteractionEnabled设置为NO，那此时headerView不能响应事件了，就会把事件传递给父控件，而headerView的父控件是当前控制器的view，所以还是不能解决当前问题
     解决方法: 给headerView添加滑动手势，当headerView的y值滑动多少时，让tableViewView的contentOffset改变多少y
     */
    // 给headerView添加滑动手势
     [headerView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)]];
    
    // 点击headerView的个人管理时，跳转到个人管理界面
    __weak typeof(self) weakSelf = self;
    [headerView setProfileDataManagerCompleteHandle:^{
        [weakSelf.navigationController pushViewController:[XYEditProfileController new] animated:YES];
    }];
}

// 添加约束
- (void)addConstraint {
    NSDictionary *views = NSDictionaryOfVariableBindings(_headerView, _tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_headerView]|" options:kNilOptions metrics:nil views:views]];
    
    NSLayoutConstraint *headerViewHConst = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:kNilOptions attribute:kNilOptions multiplier:0.0 constant:260];
    [self.view addConstraint:headerViewHConst];
    self.headerViewHConst = headerViewHConst;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:kNilOptions metrics:nil views:views]];
}

#pragma mark - Actions 
// 手势的目地：拖动headerView时，让tableView也跟随滚动
- (void)panGesture:(UIPanGestureRecognizer *)pan {
    
    // 获取手指所在的位置Y
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.originalOffsetY = self.tableView.contentOffset.y;
        self.originalLocationY = [pan locationInView:self.view].y;
//        NSLog(@"originalLocationY==%f, -- originalOffsetY==%f", self.originalLocationY, self.originalOffsetY);
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        self.fingerLocationY = [pan locationInView:self.view].y;
//        NSLog(@"fingerLocationY==%f", self.fingerLocationY);
    }
    
    CGFloat offsetY = self.fingerLocationY - self.originalLocationY;
    NSLog(@"offsetY==%f", offsetY);
    // 让tableView跟随手指在headerView的上滚动而滚动
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y - offsetY) animated:NO];
    
    // 给手指所在的原始点成为上一次滑动的点
    self.originalLocationY = self.fingerLocationY;
    
    // 当手指停止滚动时，让scrollView滚动到手指开始滚动时的位置
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.originalOffsetY) animated:YES];
    }
    
    [self.view layoutIfNeeded];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 8) {
        return 20;
    }
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 8) {
        cell.backgroundColor = xyColorWithRGB(240, 240, 240);
        cell.accessoryType = 0;
        cell.textLabel.text = nil;
        cell.selectionStyle = 0;
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"设置";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.navigationController pushViewController:[XYSettingViewController new] animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // 跟随scrollView滚动后现在图片应该的高度
    self.headerViewHConst.constant = -scrollView.contentOffset.y;

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    
    NSLog(@"%s", __FUNCTION__);
}

@end
