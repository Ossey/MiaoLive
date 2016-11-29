//
//  XYShowTipView.h
//  MiaoLive
//
//  Created by mofeini on 16/11/28.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, XYTipViewStyle) {
    XYTipViewStyleCertification = 0,
    XYTipViewStyleAuthorization
};
typedef NS_ENUM(NSInteger, XYTipBtnType) {
    XYTipBtnTypeGoCertification = 0, // 去认证
    XYTipBtnTypeAfter, // 以后认证
    XYTipBtnTypeCameraAutSetting, // 摄像头权限设置
    XYTipBtnTypeMicrophoneAutSetting, // 麦克风权限设置
    XYTipBtnTypeLocationAutSetting, // 地理权限设置
    XYTipBtnTypeClose // 关闭
};

NS_ASSUME_NONNULL_BEGIN

@class XYShowTipView;
@protocol XYShowTipViewDelegate <NSObject>

@optional
/**
 * @explain 点击按钮的事件回调, 里面必须装字典哦
 *
 * @param   tipView 对象
 * @param   btnType  点击的按钮的类型，通过XYTipBtnType提供的枚举判断点击的按钮
 *
 * @return  点击的按钮对应的硬件信息通过字典放在数组中返回，下面提供6个key
 */
- (NSArray *)showTipView:(XYShowTipView *)tipView didClickButton:(XYTipBtnType)btnType;

@end

@interface XYShowTipView : UIView 

/** 下面3个属性是tipBtnClickBlock返回值中字典的固定key */
UIKIT_EXTERN NSString *const openStatuKey;
UIKIT_EXTERN NSString *const checkTypeKey;
UIKIT_EXTERN NSString *const msgKey;
/** 下面4个属性是tipBtnClickBlock返回值中字典的固定value */
UIKIT_EXTERN NSString *const LocationValue;
UIKIT_EXTERN NSString *const MicrophoneValue;
UIKIT_EXTERN NSString *const CameraValue;
UIKIT_EXTERN NSString *const CameraAuthorityValue;

/** 代理属性 */
@property (nonatomic, weak) id<XYShowTipViewDelegate> delegate;

/** 
 * @explain 点击按钮的事件回调, 里面必须装字典哦
 *          此block和代理的作用相同，若同时执行block和代理时，有限执行block，不会再执行代理
 */
@property (nonatomic, copy) NSArray<NSDictionary *> * (^tipBtnClickBlock)(XYTipBtnType type);

/** dissmiss以后的回调 */
@property (nonatomic, copy) void (^dismissCompletionBlock)();

/** show以后的回调 */
@property (nonatomic, copy) void (^showCompletionBlock)();

@property (nonatomic, assign) XYTipViewStyle style;
/**
 * @explain 添加当前弹框菜单view到你的视图上
 *
 * @param   superView  当前view会成为superView的子控件
 * @return  实例化的对象
 */
+ (instancetype)showToSuperView:(UIView *)superView;
+ (instancetype)showToSuperView:(UIView *)superView tipViewStyle:(XYTipViewStyle)style;

/**
 * @explain 会销毁掉并移除当前控件
 */
- (void)dismiss:( void(^ _Nullable )())block;
- (void)show:(void(^ _Nullable )())block;
- (void)dismiss;
- (void)show;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
