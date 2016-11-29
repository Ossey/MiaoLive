//
//  XYThirdPartyLoginView.h
//  MiaoLive
//
//  Created by mofeini on 16/11/16.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYThirdLoginType) {
    
    XYThirdLoginTypeWeChat = 1,
    XYThirdLoginTypeQQ,
    XYThirdLoginTypeWeibo
};

@interface XYThirdPartyLoginView : UIView

/**
 点击登录按钮的回调，根据type可知道点击的是哪个登录按钮
 */
@property (nonatomic, copy) void(^clickThirdLoginTypeBlock)(XYThirdLoginType type, UIButton *thirdLoginBtn);
@end
