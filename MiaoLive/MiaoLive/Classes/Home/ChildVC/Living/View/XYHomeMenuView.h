//
//  XYHomeMenuView.h
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//  用于显示更改collectionView样式

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYHomeMenuViewBtnType) {
    XYHomeMenuViewBtnTypeBig = 0, // 大图
    XYHomeMenuViewBtnTypeSmall       // 小图
};

NS_ASSUME_NONNULL_BEGIN

@interface XYHomeMenuView : UIView

/**
 * @explain 点击menuView上不同类型按钮的事件回调
 *
 * type  不同类型按钮
 */
@property (nonatomic, copy) void (^menuViewClickBlock)(XYHomeMenuViewBtnType type);
/** 
 * dissmiss以后的回调 -- 
 * 因为内部已经对点击coverView时做了disMiss的处理，如果外界要是需要在disMiss后做事情，事情这个属性即可
 */
@property (nonatomic, copy) void (^dismissCompletionBlock)();

/** 
 * show以后的回调
 * 这样写回调的比直接在show或dismiss后面回调的好处是，不管你处理了多少个show或dismiss都会在这个block中统一执行回调，而不需要你写一下show就回调执行一次你要做的代码
 */
@property (nonatomic, copy) void (^showCompletionBlock)();

- (void)showMenuView;
- (void)dismissMenuView;
- (void)showMenuView:(nullable void(^)())block;
- (void)dismissMenuView:(nullable void(^)())block;
+ (instancetype)menuViewToSuperView:(UIView *)superView;
@end
NS_ASSUME_NONNULL_END
