//
//  XYHomeBaseController.h
//  
//
//  Created by mofeini on 16/9/1.
//  Copyright © 2016年 sey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYHomeBaseController : UIViewController

/** 存放标题按钮的视图 */
@property (nonatomic, weak, readonly) UIScrollView *titleScrollView;
/** 标题按钮缩放比例, 默认为0.2, 有效范围0.0~1.0 */
@property (nonatomic, assign) CGFloat titleBtnScale;
/** 选中标题按钮的索引, 默认为0, 当外界设置的索引大于子控制器的总数时，设置的索引无效，变为默认值0 */
@property (nonatomic, assign) NSInteger selectedIndex;
@end

