//
//  UIViewController+XYExtension.h
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XYExtension)
/** Gif加载状态 */
@property(nonatomic, weak) UIImageView *gifView;

/**
 *  判断数组是否为空
 *
 *  @param array 数组
 *
 *  @return yes or no
 */
- (BOOL)isEmptyArray:(NSArray *)array;

/**
 *  显示GIF加载动画
 *
 *  @param images gif图片数组, 不传的话默认是自带的
 *  @param view   显示在哪个view上, 如果不传默认就是self.view
 */
- (void)showGifLoding:(NSArray *)images inView:(UIView *)view;
/**
 *  取消GIF加载动画
 */
- (void)hideGufLoding;


#pragma mark - TabBar相关
/** 隐藏tabBar */
- (void)tabBarHidden;
/** 出现tabBarHidden */
- (void)tabBarShow;
/** 判断当前的TabBar状态 */
- (BOOL)tabBarIsHidden;
@end
