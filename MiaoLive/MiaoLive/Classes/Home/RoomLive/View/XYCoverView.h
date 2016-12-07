//
//  XYCoverView.h
//  LiveDemo
//
//  Created by mofeini on 16/12/7.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYCoverView : UIView

/**
 * @explain 创建一个XYCoverView实例的对象，并将当前对象添加为传入的superView的子控件, 外界不要再添加子控件
 *
 * @param   superView  父控件
 * @param   block  回调实例的对象
 */
+ (void)coverViewWithSuperView:(UIView *)superView block:(void(^)(XYCoverView *view))block;
@end

NS_ASSUME_NONNULL_END
