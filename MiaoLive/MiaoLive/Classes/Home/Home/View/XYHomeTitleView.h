//
//  XYHomeTitleView.h
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYHomeTitleViewItemType) {
    XYHomeTitleViewItemTypeHot = 0, // 最热
    XYHomeTitleViewItemTypeNew, // 最新
    XYHomeTitleViewItemTypeCare // 关注
};

NS_ASSUME_NONNULL_BEGIN
@interface XYHomeTitleView : UIView

/** 下划线 */
@property (nonatomic, weak, readonly) UIView *underLineView;
@property (nonatomic, copy) void(^homeTitleViewTypeBlock)(XYHomeTitleViewItemType type);
@property (nonatomic, assign) XYHomeTitleViewItemType selectedType;
/**
 * @explain 传入对应的标题的枚举，就执行对应的按钮点击
 *
 * @param   type  XYHomeTitleViewItemType 类型的枚举
 */
- (void)titleViewClickWithType:(XYHomeTitleViewItemType)type;
@end
NS_ASSUME_NONNULL_END
