//
//  XYLiveViewCell.m
//  MiaoLive
//
//  Created by mofeini on 16/11/22.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYLiveViewCell.h"
#import <BarrageRenderer.h>
#import "NSSafeObject.h"
#import "XYLiveItem.h"
#import "UIViewController+XYExtension.h"
#import <SDWebImageDownloader.h>
#import "XYNetworkTool.h"
#import "XYLiveBottomToolView.h"
#import "XYLiveBottomSendeTaskView.h"
#import "XYMenuView.h"


@interface XYLiveViewCell ()

/** 直播流播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
/** 直播间底部视图 */
@property (nonatomic, weak) XYLiveBottomToolView *toolView;
/** 直播间发送聊天信息的弹框，当点击publicTask按钮时，将toolView替换为sendTaskView，并将sendTaskView弹出 */
@property (nonatomic, weak) XYLiveBottomSendeTaskView *sendTaskView;
/** 蒙板,将所有的子控件添加到蒙版视图上面，主要目：移动子控件的frame时，只需要移动 coverView即可*/
@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, strong) XYMenuView *menuView;

@end
@implementation XYLiveViewCell
#pragma mark - Lazy Loading
- (XYMenuView *)menuView {
    if (_menuView == nil) {
//        _menuView = [XYMenuView menuViewToSuperView:self.coverView];
        _menuView = [XYMenuView menuViewToSuperView:xyApp.keyWindow];
        _menuView.menuViewStyle = XYMenuViewStyleVertical;
        [_menuView setItemBackGroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_menuView setDismissCompletionBlock:^{
            weakSelf.toolView.hidden = NO;
        }];
        _menuView.separatorColor = [UIColor colorWithWhite:0 alpha:0.6];
        [_menuView setMenuViewClickBlock:^(XYMenuViewBtnType type) {
            
        }];
    }
    return _menuView;
}
- (XYLiveBottomSendeTaskView *)sendTaskView {
    if (_sendTaskView == nil) {
        XYLiveBottomSendeTaskView *view = [[XYLiveBottomSendeTaskView alloc] init];
        view.hidden = YES;
        view.backgroundColor = xyColorWithRGB(238, 238, 238);
        [self.coverView addSubview:view];
        _sendTaskView = view;

    }
    return _sendTaskView;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        UIView *coverView = [[UIView alloc] init];
//        [self.contentView addSubview:coverView]; // 添加到self.contentView中会产生问题导致tf弹出键盘时，约束产生问题
        [self.superview addSubview:coverView];
        [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnCoverView)]];
        _coverView = coverView;
        coverView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
    }
    return _coverView;
}
- (XYLiveBottomToolView *)toolView {
    if (_toolView == nil) {
        XYLiveBottomToolView *toolView = [XYLiveBottomToolView new];
        [self.coverView addSubview:toolView];
        _toolView = toolView;
        
        // 点击底部工具栏的事件
        [toolView setLiveToolClickBlock:^(LiveToolType type) {
            NSLog(@"%ld", type);
            switch (type) {
                case LiveToolTypePublicTalk:
                    [self clickPublickTalk];
                    break;
                    
                case LiveToolTypePrivateTalk:
                    [self clickPrivateTalk];
                    break;
                case LiveToolTypeSendGift:
                    [self clickSendGift];
                    break;
                case LiveToolTypeDailytasks:
                    [self clickDailytasks];
                    break;
                case LiveToolTypeContributionList:
                    [self clickContributionList];
                    break;
                case LiveToolTypeShare:
                    break;
                case LiveToolTypeClose:
                    [xyApp.keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [self.moviePlayer stop];
                        [self.moviePlayer.view removeFromSuperview];
                        self.moviePlayer  = nil;
                    }];
                    break;
            }
        }];
    }
    return _toolView;
}
- (UIImageView *)placeHolderView {
    if (_placeHolderView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.contentView.bounds;
        imageView.image = [UIImage imageNamed:@"profile_user_414x414"];
        _placeHolderView = imageView;
        [self.parentVc showGifLoding:nil inView:self.placeHolderView];
        // 强制布局
        [_placeHolderView layoutIfNeeded];
    }
    return _placeHolderView;
}


- (void)setLiveItem:(XYLiveItem *)liveItem {

    _liveItem = liveItem;
    [self playFlv:liveItem.flv placeHolderURLStr:liveItem.bigpic];
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
    }
    return self;
}

- (void)setup {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)layoutSubviews {

    [super layoutSubviews];

    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self);
        make.bottom.mas_equalTo(self).priorityHigh();
    }];
    
    [self.sendTaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.coverView);
        make.bottom.mas_equalTo(self.coverView);
        make.height.mas_equalTo(44);
    }];
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.coverView);
        make.bottom.mas_equalTo(self.coverView).mas_offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    if (_moviePlayer.view) {
        [_moviePlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
}

#pragma mark - Private Method
- (void)playFlv:(NSString *)flv placeHolderURLStr:(NSString *)placeHolderURLStr {

    if (_moviePlayer) {
        [self.contentView insertSubview:self.placeHolderView aboveSubview:_moviePlayer.view];
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    if (placeHolderURLStr.length) {
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:placeHolderURLStr] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (error) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.parentVc showGifLoding:nil inView:self.placeHolderView];
                self.placeHolderView.backgroundColor = [UIColor redColor];
                self.placeHolderView.image = image;
            });
            
        }];
    }
    
    IJKFFOptions *options = [[IJKFFOptions alloc] init];
    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
    
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"7"];
    // 设置音量大小,256为标准音量。（要设置成两倍音量时则输入512，依此类推
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    // 创建直播流播放器
    IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:flv withOptions:options];
//    player.view.frame = self.contentView.bounds;
    // 填充
    player.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置不自动播放(必须设置为NO,防止自动播放，才能更好的控制直播状态)
    player.shouldAutoplay = NO;
    // 默认不显示
    player.shouldShowHudView = NO;
    
    [self.contentView insertSubview:player.view atIndex:0];
    
    [player prepareToPlay];
    self.moviePlayer = player;
    
    // 设置监听
    [self addObserver];
    
}

- (void)addObserver {

    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}


#pragma mark - Event 
- (void)tapOnCoverView {

    if (self.sendTaskView.hidden == NO) {
        [self.sendTaskView.tf resignFirstResponder];
        self.sendTaskView.hidden = YES;
        self.toolView.hidden = NO;
    }
}
- (void)clickPublickTalk {
    
    // 隐藏toolView，显示sendTaskView,并弹出textField
    self.toolView.hidden = YES;
    self.sendTaskView.hidden = NO;
    [self.sendTaskView.tf becomeFirstResponder];

}

- (void)clickPrivateTalk {
    [self.menuView showMenuView:^{
        [self.toolView setHidden:YES];
    }];
}

// 赠送礼物
- (void)clickSendGift {
    [self.menuView showMenuView:^{
        self.toolView.hidden = YES;
    }];
}

// 日常任务
- (void)clickDailytasks {
    [self.menuView showMenuView:^{
        self.toolView.hidden = YES;
    }];
}

// 房间贡献榜
- (void)clickContributionList {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XYLiveClickContributionListNotification object:nil];
}

- (void)keyboardFrameChange:(NSNotification *)note {
#warning Bug未解决: 当键盘弹出后，当前cell整体会向上移动 | 将coverView添加到self.superView上暂时解决
        
    // 获取键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat offsetY = xyScreenH - frame.origin.y;
    NSLog(@"%@--offsetY==%f", NSStringFromCGRect(frame), offsetY);
    // 让coverView跟随键盘移动
    [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_offset(-offsetY);
    }];

    [UIView animateWithDuration:duration animations:^{
        [self.superview layoutIfNeeded];
        
    }];
    
}


- (void)didFinish {

    // 如果是网速或其他原因导致直播stop了，也要显示gif
    if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled && !self.parentVc.gifView) {
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
        return;
    }
    
    //      1、重新获取直播地址，服务端控制是否有地址返回。
    //      2、用户http请求该地址，若请求成功表示直播未结束，否则结束
    __weak typeof(self) weakSelf = self;
    [[XYNetworkTool shareNetWork] GET:self.liveItem.flv parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功%@, 等待继续播放", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败, 加载失败界面, 关闭播放器%@", error);
        [weakSelf.moviePlayer shutdown];
        [weakSelf.moviePlayer.view removeFromSuperview];
        weakSelf.moviePlayer = nil;
    }];
}

- (void)stateDidChange {
    if ((self.moviePlayer.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.moviePlayer.isPlaying) {
            [self.moviePlayer play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_placeHolderView) {
                    [_placeHolderView removeFromSuperview];
                    _placeHolderView = nil;
                }
                [self.parentVc hideGufLoding];
            });
        } else {
            // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
            if (self.parentVc.gifView.isAnimating) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.parentVc hideGufLoding];
                });
                
            }

        }
    } else if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled) {  // 网络不佳时,自动暂停状态
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
        
    }
}


- (void)dealloc {
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
