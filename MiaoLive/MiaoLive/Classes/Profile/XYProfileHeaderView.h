//
//  XYProfileHeaderView.h
//  MiaoLive
//
//  Created by mofeini on 16/11/17.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYProfileHeaderView : UITableViewHeaderFooterView

/**
 *  点击个人资料管理的代码块回调
 *  通知外界点击了个人资料管理，请跳转到个人资料管理界面
 */
@property (nonatomic, copy) void(^profileDataManagerCompleteHandle)();

@end
