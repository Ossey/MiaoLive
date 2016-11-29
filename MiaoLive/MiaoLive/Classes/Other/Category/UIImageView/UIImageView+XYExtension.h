//
//  UIImageView+XYExtension.h
//  MiaoShow
//
//  Created by mofeini on 16/11/22.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (XYExtension)

/**
 * @explain 播放GIF
 *
 * @param   images  要播放的图片数组
 */
- (void)playGifAnim:(NSArray *)images;
/**
 * @explain 停止动画
 */
- (void)stopGifAnim;
@end
