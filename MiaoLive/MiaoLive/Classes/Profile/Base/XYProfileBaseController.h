//
//  XYProfileBaseController.h
//  自定义导航条
//
//  Created by mofeini on 16/9/25.
//  Copyright © 2016年 sey. All rights reserved.
//  自定义导航条的基类，请不要直接使用，若使用请继承自当前类




#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@interface XYProfileBaseController : UIViewController
/** 导航条topBackgroundView */
@property (nonatomic, strong, readonly) UIImageView *topBackgroundView;
/** 导航条左侧返回按钮的文字， 当前导航控制器下全局有效 */
//@property (nonatomic, copy) NSString *xy_globalBarTitle;

/** 导航条右侧按钮 */
@property (nonatomic, weak) UIButton *rightButton;
/** 导航条自定义的titleView， 注意: 当设置了xy_customTitleView，属性title则无效 */
@property (nonatomic, weak) UIView *xy_customTitleView;
/** 导航条title , 注意: 当设置了xy_title，属性xy_customTitleView则无效 */
@property (nonatomic, copy) NSString *xy_title;
/** 导航条前景色，包括左侧按钮和右侧按钮文字颜色 */
@property (nonatomic, strong) UIColor *xy_tintColor;
/** 导航条左侧和右侧按钮文字字体 */
@property (nonatomic, strong) UIFont *xy_buttonFont;

/** 是否隐藏导航条左侧按钮 */
@property (nonatomic, assign, getter=isHiddenLeftButton) BOOL hiddenLeftButton;

/**
 *  @explain 设置导航返回按钮的文字及图片
 */
- (void)xy_setBackBarTitle:(nullable NSString *)title titleColor:(nullable UIColor *)color image:(nullable UIImage *)image forState:(UIControlState)state;

/**
 * @explain 自定义顶部bar的左侧返回按钮的点击事件，注意: 非特殊情况下，请不要重写这个方法，不然会造成方法内部实现无效；
 *          此种情况需要重写此方法: 比如在modal的基础上push的控制器，需要重新此方法调用pop方法返回哦
 */
- (void)xy_leftButtonClick;
@end
NS_ASSUME_NONNULL_END


