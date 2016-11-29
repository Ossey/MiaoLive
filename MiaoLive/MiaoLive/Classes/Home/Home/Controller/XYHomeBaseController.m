//
//  ViewController.m
//
//  Created by mofeini on 16/9/1.
//  Copyright © 2016年 sey. All rights reserved.
//

#import "XYHomeBaseController.h"

#define xyNormalColor xyColorWithRGB(160, 122, 138)
#define xySelectedColor xyColorWithRGB(231, 129, 166)
#define xyTitleScrollViewH 44.0

@interface XYHomeBaseController ()<UIScrollViewDelegate, UIScrollViewDelegate> {
    
    /** 作用：不重复添加子控件 */
     BOOL _isInitialize;
}

/**存放标题按钮的视图 */
@property (nonatomic, weak) UIScrollView *titleScrollView;
/** 存放子控制器view的容器视图 */
@property (nonatomic, weak) UIScrollView *containerView;
/** titleScrollView底部分割线 */
@property (nonatomic, weak) UIView *separatorView;
/** 记录选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 存放标题按钮的数组 */
@property (nonatomic, strong) NSMutableArray *titleButtons;


@end

@implementation XYHomeBaseController
#pragma mark - lazy loading
- (NSInteger)selectedIndex {
//    if (_selectedIndex > self.childViewControllers.count) {
//        return 0;
//    }
//    return _selectedIndex ?: 0;
    
    return  _selectedIndex == 0 || _selectedIndex > self.childViewControllers.count ? 0 : _selectedIndex;
}

- (CGFloat)titleBtnScale {
    return _titleBtnScale ?: 0.2;
}

- (UIScrollView *)containerView {
    if (_containerView == nil) {
        // 创建内容滚动视图
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:scrollView];
        
        // 弹簧
        scrollView.bounces = NO;
        // 分页
        scrollView.pagingEnabled = YES;
        // 指示器
        scrollView.showsHorizontalScrollIndicator = NO;
        _containerView = scrollView;
    }
    return _containerView;
    
}
- (UIView *)separatorView {
    if (_separatorView == nil) {
        UIView *separatorView = [[UIView alloc] init];
        separatorView.xy_y = CGRectGetHeight(self.titleScrollView.frame) - 1;
        separatorView.xy_height = 1;
        separatorView.xy_width = self.titleScrollView.contentSize.width;
        separatorView.xy_x = self.titleScrollView.xy_x;
        [self.titleScrollView addSubview:separatorView];
        _separatorView = separatorView;
    }
    return _separatorView;
}

- (UIScrollView *)titleScrollView {
    if (_titleScrollView == nil) {
        UIScrollView *titleScrollView = [[UIScrollView alloc] init];
        titleScrollView.backgroundColor = [UIColor whiteColor];
        titleScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), xyTitleScrollViewH);
        [self.view addSubview:titleScrollView];
        _titleScrollView = titleScrollView;
    }
    return _titleScrollView;
}

- (NSMutableArray *)titleButtons {

    if (_titleButtons == nil) {
        
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

#pragma mark - 切换到index索引对应的子控制
- (void)selecteTitleItemWithIndex:(NSInteger)index {
    
    if (index > self.titleButtons.count - 1 || index < 0) {
        return;
    }
    UIButton *btn = self.titleButtons[index];
    [self titleButtonClick:btn];
}


#pragma mark - 控制器view的声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*
     在viewWillAppear方法中添加buttons的目的是是为了获取准确的childVc数量，创建对应的button
     如果在viewDidLoad方法中创建button，系统会先调用子类的viewDidLoad方法时，由于super viewDidLoad会先调用父类的viewDidLoad方法创建buttons，而此时子类并没有创建那些子控件，所以会导致childVc为nil
     由于当前方法可能会多次调用，通过_isInitialize属性，控制这些button只创建一次
     */
    // 设置所有的子标题
    if (_isInitialize == NO) {
        
        [self setupAllTitle];
        // 注意: 在这里加载separatorView是为了在获取titleScrollView准确的contenSize，那separatorView
        self.separatorView.backgroundColor = xyColorWithRGB(220, 220, 220);
        
        _isInitialize = YES;
    }
}

- (void)viewWillLayoutSubviews {

    [super viewWillLayoutSubviews];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleScrollView.mas_bottom);
    }];

}
- (void)setupUI {
    // 设置内容滚动视图的代理:目的是为了在scollView结束滚动时加载对应子控制器的view
    self.containerView.delegate = self;
    
    // 取消导航控制器下scrollView的自动内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 监听点击关注界面去看最热好友的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookHotLive) name:XYlookHotLiveNotification object:nil];
}

- (void)lookHotLive {
//    [self titleButtonClick:self.titleButtons[0]];
    [self selecteTitleItemWithIndex:0];
}

#pragma mark - 设置所有的子标题
- (void)setupAllTitle {

    NSInteger count = self.childViewControllers.count;
    CGFloat x = 0;
    // 控制每个标题按钮的宽度，当小于5个的时候，让他们平分整个屏幕的宽度
    CGFloat w = count < 5 ? CGRectGetWidth(self.view.frame) / count : 80;
    
    // 添加所有的子控制器
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        x = i * w;
        button.frame = CGRectMake(x, 0, w, self.titleScrollView.bounds.size.height);
        UIViewController *vc = self.childViewControllers[i];
        // 设置按钮的标题
        [button setTitle:vc.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15 weight:0.5];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        
        // 处理按钮的点击事件
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleButtons addObject:button];

        [self.titleScrollView addSubview:button];
    }
    
    // 设置标题视图的滚动范围
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置内容滚动视图的滚动范围
    self.containerView.contentSize = CGSizeMake(count * xyScreenW, 0);
    
    // 让默认选择的按钮
    // 注意: 要先设置titleScrollView.contentSize，在设置默认选中的按钮，不然titleScrollView.contentSize为0，导致titleScrollView无法正确滚动居中
    [self selecteTitleItemWithIndex:self.selectedIndex];
    
}

#pragma mark - 设置选中按钮文字的默认颜色
- (void)selectedBtn:(UIButton *)button{

    _selectedButton.transform = CGAffineTransformIdentity;
    [_selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    // 设置标题居中
    [self setupTitleCenter:button];
    
    // 设置标题按钮的缩放
    button.transform = CGAffineTransformMakeScale(1.0f + self.titleBtnScale, 1.0f + self.titleBtnScale);
    _selectedButton = button;
}

#pragma mark - 设置标题居中
- (void)setupTitleCenter:(UIButton *)button {

    // 本质：移动标题滚动视图的偏移量
    
    // 计算当选择的标题按钮的中心点x在屏幕屏幕中心点时，标题滚动视图的x轴的偏移量
    CGFloat offsetX = button.center.x - xyScreenW * 0.5;
//    NSLog(@"%f", xyScreenW);
    // 当offsetX 小于0时，让offsetX等于0
    if (offsetX < 0) {
        offsetX = 0;
    }

    // 计算最大的偏移量
    // 问题: 此时self.titleScrollView.contentSize.width为0
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - xyScreenW;
    NSLog(@"self.titleScrollView.contentSize.width==%f", self.titleScrollView.contentSize.width);
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }

    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - 监听标题按钮的点击
- (void)titleButtonClick:(UIButton *)button {
    
    NSInteger i = [button tag];
    // 当点击按钮时，让点击的那个按钮的文字颜色改变为红色
    [self selectedBtn:button];
    
    // 添加对应的子控制器view
    [self setupOneChildView:i];
    
    CGFloat x = i * xyScreenW;
    // 内容滚动范围滚动到对应的位置
    self.containerView.contentOffset = CGPointMake(x, 0);
}


#pragma mark - 添加一个子控制器的view
- (void)setupOneChildView:(NSInteger)i {

    UIViewController *vc = self.childViewControllers[i];
    // 判断如果子控制器view的父控件已经有值了，就是说如果子控制器view已经添加上去了，就不再添加了,防止每次点击都会再次添加view
    if (vc.view.superview || vc.view.window) {
        return;
    }
//    CGFloat x = i * self.containerView.xy_width;
    CGFloat x = i * self.view.xy_width; // 此时self.containerView.xy_width为0，所以使用self.view加载view
//    NSLog(@"i==%ld, self.view.xy_width==%f", i, self.view.xy_width);
    vc.view.frame = CGRectMake(x, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    [self.containerView addSubview:vc.view];
}

#pragma mark - UIScrollViewDelegate
// scrollView滚动的时候调用,让字体跟随滚动渐变缩放
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger leftI = scrollView.contentOffset.x / xyScreenW;
    NSInteger rightI = leftI + 1;
    // 1.取出缩放的两个按钮
    // 取出左边按钮
    UIButton *leftBtn = self.titleButtons[leftI];
    //NSLog(@"%ld, %ld, %f", leftI, rightI, scrollView.contentOffset.x);
    
    // 取出右边的按钮
    UIButton *rightBtn;
    // 容错处理，防止数组越界
    if (rightI < self.titleButtons.count) {
        
        rightBtn = self.titleButtons[rightI];
    }
    
    // 2.缩放按钮
    // 计算需要缩放的比例
    CGFloat scaleR = scrollView.contentOffset.x / xyScreenW; // 放大
    scaleR -= leftI;
    CGFloat scaleL = 1 - scaleR; // 缩小，与放大取反即可
    NSLog(@"%f, %f", scaleR, scaleL);
    // 让按钮的缩放范围在1 ~ 1.3的范围，如果不设置按钮的缩放范围在0 ~ 1
    rightBtn.transform = CGAffineTransformMakeScale(scaleR * self.titleBtnScale + 1, scaleR * self.titleBtnScale + 1);
    leftBtn.transform = CGAffineTransformMakeScale(scaleL * self.titleBtnScale + 1, scaleL * self.titleBtnScale + 1);
    
    // 3.标题按钮文字颜色渐变
    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0.0f blue:0.0f alpha:1.0f];
    UIColor *rightColor = [UIColor colorWithRed:scaleR green:0.0f blue:0.0f alpha:1.0f];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    
        
}
// scrollView滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    // 计算当前角标
    NSInteger i = scrollView.contentOffset.x / xyScreenW;
    
    // 1.设置选中的按钮的默认颜色为红色
    // 注意：当我们创建完按钮时，应该讲按钮添加到一个可变数组中，方便我们使用的时候根据角标取出对应按钮
    UIButton *button = self.titleButtons[i];
    [self selectedBtn:button];
    
    // 2.加载对应的控制器的view
    [self setupOneChildView:i];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s", __func__);
}

@end
