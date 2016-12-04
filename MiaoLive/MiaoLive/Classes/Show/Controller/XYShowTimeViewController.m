//
//  XYShowTimeViewController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/16.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYShowTimeViewController.h"
#import <LFLiveKit.h>

@interface XYShowTimeViewController () <LFLiveSessionDelegate>

/** 美颜开关按钮 */
@property (nonatomic, weak) UIButton *beautifulfaceBtn;
/** 关闭 */
@property (nonatomic, weak) UIButton *closeBtn;
/** 切换前后摄像头 */
@property (nonatomic, weak) UIButton *cameraChangeBtn;
/** 开始直播按钮 */
@property (nonatomic, weak) UIButton *startShowBtn;
/** 推流会话 */
@property (nonatomic, strong) LFLiveSession *session;
/** 返回的视频显示的view */
@property (nonatomic, weak) UIView *livingView;
/** 当前区域网所在IP地址 */
@property (nonatomic,copy) NSString *ipAddress;
@end

@implementation XYShowTimeViewController
- (UIView *)livingView {
    if (_livingView == nil) {
        // 初始化
        UIView *livingView = [[UIView alloc] init];
        [self.view insertSubview:livingView atIndex:0];
        [livingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        _livingView = livingView;
    }
    return _livingView;
}

- (LFLiveSession *)session {
    if (!_session) {
        //采用默认的音视频质量 LFLiveAudioConfiguration（音频设置）LFLiveVideoConfiguration（视频质量）
        //初始化session要传入音频配置和视频配置
        //音频的默认配置为:采样率44.1 双声道
        //视频默认分辨率为360 * 640
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2]];
        _session.preView = self.view;
        // 设置代理
        _session.delegate = self;
        // 是否输出调试信息
        _session.showDebugInfo = NO;
        _session.running = YES;
        // 设置返回的视频显示在指定的view上
        _session.preView = self.livingView;
    }
    return _session;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    // 推流端
    [self requesetAccessForMedio];
    [self requesetAccessForVideo];
    // 默认开启后置摄像头
    self.session.captureDevicePosition = AVCaptureDevicePositionBack;
}


- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setTitle:@"智能美颜已开启" forState:UIControlStateNormal];
        [btn setTitle:@"智能美颜已关闭" forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"icon_beautifulface_19x19"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_beautifulface_19x19"] forState:UIControlStateSelected];
        [self.view addSubview:btn];
        self.beautifulfaceBtn = btn;
        [btn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.5]];
        btn.layer.cornerRadius = 20;
        [btn.layer setMasksToBounds:YES];
    } buttonClickCallBack:^(UIButton *btn) {
        // 由于美颜功能默认是开启的，当点击按钮时关闭智能美颜
        btn.selected = !btn.isSelected;
        self.session.beautyFace = !self.session.beautyFace;
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setImage:[UIImage imageNamed:@"camera_change_40x40"] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        self.cameraChangeBtn = btn;
        [btn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.5]];
        btn.layer.cornerRadius = 20;
        [btn.layer setMasksToBounds:YES];
    } buttonClickCallBack:^(UIButton *btn) {
        // 切换摄像头
        btn.selected = !btn.isSelected;
        self.session.captureDevicePosition = !btn.isSelected ? AVCaptureDevicePositionBack :AVCaptureDevicePositionFront;
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setImage:[UIImage imageNamed:@"talk_close_40x40"] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        self.closeBtn = btn;
        [btn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.5]];
        btn.layer.cornerRadius = 20;
        [btn.layer setMasksToBounds:YES];
    } buttonClickCallBack:^(UIButton *btn) {
        // 关闭直播
        [self dismissViewControllerAnimated:YES completion:^{
            [self.session stopLive];
            self.session.delegate = nil;
            [self.livingView removeFromSuperview];
        }];
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setTitle:@"开始直播" forState:UIControlStateNormal];
        [btn setTintColor:[UIColor whiteColor]];
        [btn setBackgroundColor:xyAppTinColor];
        [btn setBackgroundImage:[UIImage xy_imageWithColor:xyColorWithRGB(200, 0, 0)] forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
        self.startShowBtn = btn;
        btn.layer.cornerRadius = 20;
        [btn.layer setMasksToBounds:YES];
    } buttonClickCallBack:^(UIButton *btn) {
        // 开始直播
        [self startLive];
    }];
    
}
//ffmpeg -re -i /Users/mofeini/Desktop/CollectionView.mov -vcodec libx264 -acodec aac -strict -2 -f flv rtmp://localhost:5930/rtmplive/room
// 开始直播
- (void)startLive {
    
    LFLiveStreamInfo *streamInfo = [LFLiveStreamInfo new];
    // 设置RTMP要推流的地址
    streamInfo.url = @"rtmp://192.168.1.101:5930/rtmplive/room";
    [self.session startLive:streamInfo];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    [self makeConstr];
}

- (void)makeConstr {

    CGFloat margin = 10;
    [self.beautifulfaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(margin);
        make.top.mas_equalTo(self.view).mas_offset(margin + 20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(180);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-margin);
        make.top.mas_equalTo(self.beautifulfaceBtn);
        make.width.height.mas_equalTo(40);
    }];
    [self.cameraChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.closeBtn.mas_left).mas_offset(-margin);
        make.top.mas_equalTo(self.beautifulfaceBtn);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.startShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view).mas_offset(-60);
        make.bottom.mas_equalTo(self.view).mas_offset(-150);
        make.height.mas_equalTo(40);
    }];
    

}

/**
 *  请求摄像头资源
 */
- (void)requesetAccessForVideo{
    __weak typeof(self) weakSelf = self;
    //判断授权状态
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            //发起授权请求
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //运行会话
                        [weakSelf.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            //已授权则继续
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.session setRunning:YES];
            });
            break;
        }
        default:
            break;
    }
}

/**
 *  请求音频资源
 */
- (void)requesetAccessForMedio{
    __weak typeof(self) weakSelf = self;
    //判断授权状态
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            //发起授权请求
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //运行会话
                        [weakSelf.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            //已授权则继续
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.session setRunning:YES];
            });
            break;
        }
        default:
            break;
    }
}

- (void)dealloc {
    
    
    NSLog(@"%s", __func__);
}

@end
