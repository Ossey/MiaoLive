//
//  XYLoginViewController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/16.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYLoginViewController.h"
#import "XYLoginView.h"
#import "XYMainViewController.h"
#import "UIViewController+XYHUD.h"

@interface XYLoginViewController ()

/** 背景 */
@property (nonatomic, weak) UIImageView *backgroundView;
/** 登录 */
@property (nonatomic, weak) XYLoginView *loginView;

@end

@implementation XYLoginViewController


#pragma mark - ViewController'view Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


- (void)setup {
    
    self.backgroundView.hidden = NO;
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}



#pragma mark - Lazy Loading

- (UIImageView *)backgroundView {

    if (_backgroundView == nil) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        backgroundView.image = [UIImage imageNamed:@"login_bg"];
        [self.view addSubview:backgroundView];
        _backgroundView = backgroundView;
    }
    return _backgroundView;
}

- (XYLoginView *)loginView {
    if (_loginView == nil) {
        XYLoginView *loginView = [[XYLoginView alloc] init];
        loginView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        __weak typeof(self) weakSelf = self;
        [loginView setClickLoginTypeBlock:^(XYLoginType type) {
            [weakSelf login:type];
        }];
        [self.view addSubview:loginView];
        _loginView = loginView;
    }
    return _loginView;
}

#pragma mark - Private Method
- (void)login:(XYLoginType)type {
    
    // 实际开发需要根据登录的type去判断，是哪种类型的登录
    // 这里直接切换跟控制器为主界面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        xyApp.keyWindow.rootViewController = [XYMainViewController new];
        
        [self xy_showMessage:@"登录成功"];
        
        
    });
    
}


- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end
