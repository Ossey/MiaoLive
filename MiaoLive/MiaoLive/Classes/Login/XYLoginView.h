//
//  XYLoginView.h
//  MiaoLive
//
//  Created by mofeini on 16/11/16.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, XYLoginType) {
    
    XYLoginTypeWeChat = 1,
    XYLoginTypeQQ,
    XYLoginTypeWeibo,
    XYLoginType9158,
    XYLoginTypeChenlong
};


@interface XYLoginView : UIView

/**
 点击登录按钮的回调，根据type可知道点击的是哪个登录按钮
 */
@property (nonatomic, copy) void(^clickLoginTypeBlock)(XYLoginType type);

@end

NS_ASSUME_NONNULL_END
